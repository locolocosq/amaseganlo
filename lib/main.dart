import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/audio_service.dart';
import 'core/storage_service.dart';
import 'state/content_provider.dart';
import 'state/lesson_provider.dart';
import 'state/progress_provider.dart';
import 'state/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  await storage.init();

  final audioService = AudioService();
  await audioService.init();

  final contentProvider = ContentProvider();
  // Fire-and-forget: the UI already stands (path/unit screens show a loading
  // state) while the curriculum loads in the background, per Abschnitt C8.
  contentProvider.load();

  final progressProvider = ProgressProvider(storage);

  runApp(
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
      ],
      child: const AmaseganloApp(),
    ),
  );
}
