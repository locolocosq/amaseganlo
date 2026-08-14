import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/audio_service.dart';
import 'core/notification_service.dart';
import 'core/purchase_service.dart';
import 'core/router.dart';
import 'core/storage_service.dart';
import 'models/settings.dart';
import 'state/content_provider.dart';
import 'state/fidel_lesson_provider.dart';
import 'state/lesson_provider.dart';
import 'state/progress_provider.dart';
import 'state/settings_provider.dart';
import 'widgets/common/crash_fallback_view.dart';

Future<void> main() async {
  // Abschnitt C6: a failing widget must never leave a blank screen behind -
  // this replaces Flutter's default red/grey error box with a friendly one.
  // There is no crash-reporting server (the app is fully offline per
  // Abschnitt 1), so both this and the runZonedGuarded handler below just
  // print to the console instead of phoning home.
  ErrorWidget.builder = (details) => CrashFallbackView(details: details);

  runZonedGuarded(() => _runApp(), (error, stack) {
    FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stack));
  });
}

void _installGlobalErrorHandlers() {
  final previousOnError = PlatformDispatcher.instance.onError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stack));
    return previousOnError?.call(error, stack) ?? true;
  };
}

/// Makes the bundled NotoSansEthiopic font's OFL license show up on the
/// "Open-Source-Lizenzen" page (Abschnitt C5/Etappe 11) - `showLicensePage`
/// only surfaces pub package licenses automatically, a manually-added font
/// asset needs an explicit registration to fulfil the OFL's requirement to
/// keep the license text viewable alongside the font.
void _registerFontLicense() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/NotoSansEthiopic-OFL.txt');
    yield LicenseEntryWithLineBreaks(['NotoSansEthiopic'], license);
  });
}

Future<void> _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  _installGlobalErrorHandlers();
  _registerFontLicense();

  final storage = StorageService();
  await storage.init();

  final audioService = AudioService();
  await audioService.init();

  final contentProvider = ContentProvider();
  // Fire-and-forget: the UI already stands (path/unit screens show a loading
  // state) while the curriculum loads in the background, per Abschnitt C8.
  contentProvider.load();

  final progressProvider = ProgressProvider(storage);

  final purchaseService = PurchaseService(storage: storage);
  // Fire-and-forget, same reasoning as contentProvider.load(): querying
  // store availability can be slow (or simply unsupported, e.g. on web),
  // and nothing in the UI needs the answer before first paint - the
  // premium screen/accent-color picker just show "unavailable" until this
  // resolves.
  purchaseService.init();

  final notificationService = NotificationService();
  await notificationService.init();

  final settingsProvider = SettingsProvider(storage);
  void syncAudioSettings() {
    audioService.soundEnabled = settingsProvider.settings.soundEnabled;
    audioService.volume = settingsProvider.settings.volume;
    audioService.speechRate = settingsProvider.settings.speechRate.multiplier;
  }

  syncAudioSettings();
  settingsProvider.addListener(syncAudioSettings);

  // Re-schedules/cancels the daily reminder on every settings change (not
  // just when the toggle itself flips) so a reminder-time edit or a locale
  // switch (the notification text is per-language, see
  // notification_service.dart) takes effect immediately - fire-and-forget,
  // same reasoning as contentProvider.load()/purchaseService.init(): a
  // slow platform-channel round trip here must never block first paint.
  void syncReminderSettings() {
    notificationService.syncWithSettings(settingsProvider.settings);
  }

  syncReminderSettings();
  settingsProvider.addListener(syncReminderSettings);

  final router = buildRouter(
    onboardingCompleted: () => settingsProvider.settings.onboardingCompleted,
    refreshListenable: settingsProvider,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: contentProvider),
        ChangeNotifierProvider.value(value: progressProvider),
        Provider<AudioService>.value(value: audioService),
        Provider<NotificationService>.value(value: notificationService),
        ChangeNotifierProvider.value(value: purchaseService),
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
            audioService: audioService,
          ),
        ),
      ],
      child: HabeshaSpeakApp(router: router),
    ),
  );
}
