import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habesha_speak/app.dart';
import 'package:habesha_speak/core/audio_service.dart';
import 'package:habesha_speak/core/journey_regions.dart';
import 'package:habesha_speak/core/notification_service.dart';
import 'package:habesha_speak/core/purchase_service.dart';
import 'package:habesha_speak/core/router.dart';
import 'package:habesha_speak/core/storage_service.dart';
import 'package:habesha_speak/l10n/app_localizations.dart';
import 'package:habesha_speak/models/settings.dart';
import 'package:habesha_speak/screens/lesson/lesson_screen.dart';
import 'package:habesha_speak/state/content_provider.dart';
import 'package:habesha_speak/state/fidel_lesson_provider.dart';
import 'package:habesha_speak/state/lesson_provider.dart';
import 'package:habesha_speak/state/progress_provider.dart';
import 'package:habesha_speak/widgets/journey/region_node_marker.dart';
import 'package:habesha_speak/state/settings_provider.dart';

/// A `TtsClient`/`AudioPlayerClient` that never touches a real platform
/// channel - see the class doc on `AudioService` in `audio_service.dart`
/// for why tests must not construct the real ones.
class FakeTtsClient implements TtsClient {
  @override
  Future<bool> isLanguageAvailable(String language) async => false;
  @override
  Future<void> setLanguage(String language) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> setSpeechRate(double rate) async {}
  @override
  Future<void> speak(String text) async {}
  @override
  Future<void> stop() async {}
}

class FakeAudioPlayerClient implements AudioPlayerClient {
  @override
  Future<void> play(String assetPath, {required double volume, double rate = 1.0}) async {}
  @override
  Future<void> stop() async {}
}

/// A `NotificationClient` that never touches a real platform channel - see
/// `FakeTtsClient` above for why. Always grants permission, so tests that
/// flip the daily-reminder switch exercise the real
/// `NotificationService.syncWithSettings` logic against something that just
/// records what it was asked to do.
class FakeNotificationClient implements NotificationClient {
  bool permissionGranted = true;
  int scheduleCalls = 0;
  int cancelCalls = 0;
  int? lastScheduledHour;
  int? lastScheduledMinute;

  @override
  Future<void> initialize() async {}
  @override
  Future<bool> requestPermission() async => permissionGranted;
  @override
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    scheduleCalls++;
    lastScheduledHour = hour;
    lastScheduledMinute = minute;
  }

  @override
  Future<void> cancel(int id) async {
    cancelCalls++;
  }
}

/// Widget/flow tests care about app behavior, not the real (and now large,
/// ~1000-file) `assets/audio/` bundle - giving `AudioService` a fake, empty
/// bundle here keeps it from touching that wildcard asset directory at all
/// during these tests, the same reasoning as `FakeTtsClient`/
/// `FakeAudioPlayerClient` above.
class _EmptyAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw FlutterError('no assets in this fake bundle');
  }
}

AudioService _fakeAudioService() => AudioService(
      tts: FakeTtsClient(),
      player: FakeAudioPlayerClient(),
      bundle: _EmptyAssetBundle(),
      voiceRetryDelay: Duration.zero,
    );

/// Shared setup for widget tests. Each test that uses this should live in
/// its own file - flutter_test gives every *file* a fresh process, which
/// avoids cross-test interference between independently-pumped app trees
/// within a single file.
///
/// Onboarding is forced to "completed" by default regardless of what
/// [initialPrefs] provides - no current test targets the onboarding-redirect
/// state through this helper, and every existing test's tap sequences
/// assume it's already landed on the main app shell. Pass
/// `forceOnboardingCompleted: false` to test the onboarding flow itself.
Future<void> pumpTestApp(
  WidgetTester tester, {
  Map<String, Object> initialPrefs = const {},
  bool forceOnboardingCompleted = true,
  AudioService? audioService,
  NotificationClient? notificationClient,
}) async {
  final prefs = Map<String, Object>.from(initialPrefs);
  final existingSettingsJson = prefs['amaseganlo.settings'] as String?;
  final baseSettings = existingSettingsJson != null
      ? AppSettings.fromJson(
          jsonDecode(existingSettingsJson) as Map<String, dynamic>,
        )
      : const AppSettings();
  if (forceOnboardingCompleted) {
    prefs['amaseganlo.settings'] = jsonEncode(
      baseSettings.copyWith(onboardingCompleted: true).toJson(),
    );
  } else if (existingSettingsJson == null) {
    prefs['amaseganlo.settings'] = jsonEncode(baseSettings.toJson());
  }

  SharedPreferences.setMockInitialValues(prefs);
  final storage = StorageService();
  await storage.init();

  final resolvedAudioService = audioService ?? _fakeAudioService();
  await resolvedAudioService.init();

  final contentProvider = ContentProvider();
  // Etappe 24 Nachtrag 3: real asset loads (rootBundle.loadString - this
  // now reads well over 300 small files under assets/content/) must run
  // via runAsync() here. Inside a bare `await`, flutter_test's FakeAsync
  // test zone never lets the underlying real I/O callbacks resolve once
  // there are enough of them in flight, and the whole test hangs until its
  // outer timeout - runAsync() steps outside that fake zone into the real
  // event loop for exactly this class of "genuine async I/O" work.
  await tester.runAsync(() => contentProvider.load());

  final progressProvider = ProgressProvider(storage);
  // UnavailablePurchaseClient never touches a real platform channel and
  // resolves isAvailable() to false instantly - the same reasoning as the
  // fake TTS/audio/asset-bundle clients above.
  final purchaseService = PurchaseService(storage: storage, client: UnavailablePurchaseClient());
  await purchaseService.init();
  final notificationService = NotificationService(client: notificationClient ?? FakeNotificationClient());
  await notificationService.init();
  final settingsProvider = SettingsProvider(storage);
  // Mirrors the syncReminderSettings wiring in main.dart's _runApp() -
  // without it, toggling the reminder switch updates AppSettings but never
  // actually reaches NotificationService, since nothing else in this test
  // harness's widget tree does that job.
  settingsProvider.addListener(() => notificationService.syncWithSettings(settingsProvider.settings));
  final router = buildRouter(
    onboardingCompleted: () => settingsProvider.settings.onboardingCompleted,
    refreshListenable: settingsProvider,
  );

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: contentProvider),
        ChangeNotifierProvider.value(value: progressProvider),
        Provider<AudioService>.value(value: resolvedAudioService),
        Provider<NotificationService>.value(value: notificationService),
        ChangeNotifierProvider.value(value: purchaseService),
        ChangeNotifierProvider(
          create: (_) => LessonProvider(
            content: contentProvider.repository,
            progress: progressProvider,
            audioService: resolvedAudioService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FidelLessonProvider(
            content: contentProvider.repository,
            progress: progressProvider,
            audioService: resolvedAudioService,
          ),
        ),
      ],
      child: HabeshaSpeakApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpTestLesson(
  WidgetTester tester, {
  required String unitId,
  required String lessonId,
  AudioService? audioService,
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = StorageService();
  await storage.init();

  final resolvedAudioService = audioService ?? _fakeAudioService();
  await resolvedAudioService.init();

  final contentProvider = ContentProvider();
  await tester.runAsync(() => contentProvider.load());

  final progressProvider = ProgressProvider(storage);

  final router = GoRouter(
    initialLocation: '/lesson/$unitId/$lessonId',
    routes: [
      GoRoute(
        path: '/learn',
        builder: (context, state) => const Scaffold(body: Text('home')),
      ),
      GoRoute(
        path: '/lesson/:unitId/:lessonId',
        builder: (context, state) => LessonScreen(
          unitId: state.pathParameters['unitId']!,
          lessonId: state.pathParameters['lessonId']!,
        ),
      ),
      GoRoute(
        path: '/lesson/:unitId/:lessonId/complete',
        builder: (context, state) => const Scaffold(body: Text('complete')),
      ),
    ],
  );

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(storage)),
        ChangeNotifierProvider.value(value: contentProvider),
        ChangeNotifierProvider.value(value: progressProvider),
        Provider<AudioService>.value(value: resolvedAudioService),
        ChangeNotifierProvider(
          create: (_) => LessonProvider(
            content: contentProvider.repository,
            progress: progressProvider,
            audioService: resolvedAudioService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FidelLessonProvider(
            content: contentProvider.repository,
            progress: progressProvider,
            audioService: resolvedAudioService,
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('de'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Finds a region's node on the world map by its `region` field (Etappe 24
/// Nachtrag) - the map nodes no longer show a visible name caption, and
/// their merged Semantics label isn't a clean single-word match either (it
/// also carries the number-flag/crown-count children's own labels, e.g.
/// "Addis\n1\n0/35"), so tests need to find "the Addis Abeba node" by
/// widget identity instead of any text.
Finder findRegionNode(JourneyRegion region) =>
    find.byWidgetPredicate((w) => w is RegionNodeMarker && w.region == region);
