import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amaseganlo/app.dart';
import 'package:amaseganlo/core/audio_service.dart';
import 'package:amaseganlo/core/router.dart';
import 'package:amaseganlo/core/storage_service.dart';
import 'package:amaseganlo/l10n/app_localizations.dart';
import 'package:amaseganlo/models/settings.dart';
import 'package:amaseganlo/screens/lesson/lesson_screen.dart';
import 'package:amaseganlo/state/content_provider.dart';
import 'package:amaseganlo/state/fidel_lesson_provider.dart';
import 'package:amaseganlo/state/lesson_provider.dart';
import 'package:amaseganlo/state/progress_provider.dart';
import 'package:amaseganlo/state/settings_provider.dart';

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
  Future<void> speak(String text) async {}
  @override
  Future<void> stop() async {}
}

class FakeAudioPlayerClient implements AudioPlayerClient {
  @override
  Future<void> play(String assetPath, {required double volume}) async {}
  @override
  Future<void> stop() async {}
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

  final audioService = _fakeAudioService();
  await audioService.init();

  final contentProvider = ContentProvider();
  await contentProvider.load();

  final progressProvider = ProgressProvider(storage);
  final settingsProvider = SettingsProvider(storage);
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
        Provider<AudioService>.value(value: audioService),
        ChangeNotifierProvider(
          create: (_) => LessonProvider(
            content: contentProvider.repository,
            progress: progressProvider,
            audioService: audioService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FidelLessonProvider(
            content: contentProvider.repository,
            progress: progressProvider,
          ),
        ),
      ],
      child: AmaseganloApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpTestLesson(
  WidgetTester tester, {
  required String unitId,
  required String lessonId,
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = StorageService();
  await storage.init();

  final audioService = _fakeAudioService();
  await audioService.init();

  final contentProvider = ContentProvider();
  await contentProvider.load();

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
        Provider<AudioService>.value(value: audioService),
        ChangeNotifierProvider(
          create: (_) => LessonProvider(
            content: contentProvider.repository,
            progress: progressProvider,
            audioService: audioService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FidelLessonProvider(
            content: contentProvider.repository,
            progress: progressProvider,
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
