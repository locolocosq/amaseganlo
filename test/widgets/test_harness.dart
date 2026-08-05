import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amaseganlo/app.dart';
import 'package:amaseganlo/core/audio_service.dart';
import 'package:amaseganlo/core/storage_service.dart';
import 'package:amaseganlo/l10n/app_localizations.dart';
import 'package:amaseganlo/screens/lesson/lesson_screen.dart';
import 'package:amaseganlo/state/content_provider.dart';
import 'package:amaseganlo/state/fidel_lesson_provider.dart';
import 'package:amaseganlo/state/lesson_provider.dart';
import 'package:amaseganlo/state/progress_provider.dart';
import 'package:amaseganlo/state/settings_provider.dart';

/// Shared setup for widget tests. Each test that uses this should live in
/// its own file - flutter_test gives every *file* a fresh process, which
/// avoids cross-test interference between independently-pumped app trees
/// within a single file.
Future<void> pumpTestApp(WidgetTester tester, {Map<String, Object> initialPrefs = const {}}) async {
  SharedPreferences.setMockInitialValues(initialPrefs);
  final storage = StorageService();
  await storage.init();

  final audioService = AudioService();
  await audioService.init();

  final contentProvider = ContentProvider();
  await contentProvider.load();

  final progressProvider = ProgressProvider(storage);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(storage)),
        ChangeNotifierProvider.value(value: contentProvider),
        ChangeNotifierProvider.value(value: progressProvider),
        Provider<AudioService>.value(value: audioService),
        ChangeNotifierProvider(
          create: (_) => LessonProvider(content: contentProvider.repository, progress: progressProvider, audioService: audioService),
        ),
        ChangeNotifierProvider(
          create: (_) => FidelLessonProvider(content: contentProvider.repository, progress: progressProvider),
        ),
      ],
      child: const AmaseganloApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpTestLesson(WidgetTester tester, {required String unitId, required String lessonId}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = StorageService();
  await storage.init();

  final audioService = AudioService();
  await audioService.init();

  final contentProvider = ContentProvider();
  await contentProvider.load();

  final progressProvider = ProgressProvider(storage);

  final router = GoRouter(
    initialLocation: '/lesson/$unitId/$lessonId',
    routes: [
      GoRoute(path: '/learn', builder: (context, state) => const Scaffold(body: Text('home'))),
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
          create: (_) => LessonProvider(content: contentProvider.repository, progress: progressProvider, audioService: audioService),
        ),
        ChangeNotifierProvider(
          create: (_) => FidelLessonProvider(content: contentProvider.repository, progress: progressProvider),
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
