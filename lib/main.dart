import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/audio_service.dart';
import 'core/router.dart';
import 'core/storage_service.dart';
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

  final settingsProvider = SettingsProvider(storage);
  void syncAudioSettings() {
    audioService.soundEnabled = settingsProvider.settings.soundEnabled;
    audioService.volume = settingsProvider.settings.volume;
  }

  syncAudioSettings();
  settingsProvider.addListener(syncAudioSettings);

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
}
