import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habesha_speak/core/audio_service.dart';
import 'package:habesha_speak/core/storage_service.dart';
import 'package:habesha_speak/l10n/app_localizations.dart';
import 'package:habesha_speak/screens/fidel/fidel_table_screen.dart';
import 'package:habesha_speak/state/content_provider.dart';
import 'package:habesha_speak/state/progress_provider.dart';

import 'test_harness.dart';

/// Forces AudioService's manifest lookup to fail, matching the identically-named
/// class in fidel_audio_drill_test.dart/lesson_intro_autoplay_test.dart - the
/// detail sheet under test only reads `isAmharicAvailable` synchronously, it
/// never needs a real manifest.
class _EmptyAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw FlutterError('no assets in this fake bundle');
  }
}

void main() {
  testWidgets('the Fidel table renders a learned sign differently from an unlearned one', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();

    final contentProvider = ContentProvider();
    await tester.runAsync(() => contentProvider.load());

    final progressProvider = ProgressProvider(storage);
    // ሀ (ha, order 1) is learned; everything else in that row is not.
    final haOrder1 = contentProvider.repository.fidelCharsForGroup('ha').first.char;
    await progressProvider.recordFidelAnswer(haOrder1, correct: true);

    final router = GoRouter(
      initialLocation: '/table',
      routes: [GoRoute(path: '/table', builder: (context, state) => const FidelTableScreen())],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: contentProvider),
          ChangeNotifierProvider.value(value: progressProvider),
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

    final texts = tester.widgetList<Text>(find.text(haOrder1)).toList();
    expect(texts, isNotEmpty);
    final learnedColor = texts.first.style?.color;

    final huChar = contentProvider.repository.fidelCharsForGroup('ha')[1].char;
    final unlearnedTexts = tester.widgetList<Text>(find.text(huChar)).toList();
    expect(unlearnedTexts, isNotEmpty);
    final unlearnedColor = unlearnedTexts.first.style?.color;

    expect(learnedColor, isNotNull);
    expect(unlearnedColor, isNotNull);
    expect(learnedColor, isNot(equals(unlearnedColor)));
  });

  testWidgets('tapping a sign opens its detail sheet without a layout overflow', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();

    final contentProvider = ContentProvider();
    await tester.runAsync(() => contentProvider.load());
    final progressProvider = ProgressProvider(storage);

    final router = GoRouter(
      initialLocation: '/table',
      routes: [GoRoute(path: '/table', builder: (context, state) => const FidelTableScreen())],
    );

    // A short screen (matches the "bottom overflowed by N pixels" report -
    // the sheet's content only just fits on a normal-height screen, so a
    // short one is what actually reproduces the bug).
    await tester.binding.setSurfaceSize(const Size(400, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final audioService = AudioService(
      tts: FakeTtsClient(),
      player: FakeAudioPlayerClient(),
      bundle: _EmptyAssetBundle(),
      voiceRetryDelay: Duration.zero,
    );
    await audioService.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: contentProvider),
          ChangeNotifierProvider.value(value: progressProvider),
          Provider<AudioService>.value(value: audioService),
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

    // Tap the first actual sign cell (an InkWell inside the table) rather
    // than matching on its text, since the row-header column can render the
    // same character as a plain, non-tappable Text.
    await tester.tap(find.descendant(of: find.byType(Table), matching: find.byType(InkWell)).first);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('the table can be panned vertically to reach rows below the fold', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();

    final contentProvider = ContentProvider();
    await tester.runAsync(() => contentProvider.load());
    final progressProvider = ProgressProvider(storage);

    final router = GoRouter(
      initialLocation: '/table',
      routes: [GoRoute(path: '/table', builder: (context, state) => const FidelTableScreen())],
    );

    // A short screen so the full table (33 rows) can't possibly fit without
    // panning - matches the report ("kann nicht runter scrollen").
    await tester.binding.setSurfaceSize(const Size(400, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: contentProvider),
          ChangeNotifierProvider.value(value: progressProvider),
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

    final viewerFinder = find.byType(InteractiveViewer);
    expect(viewerFinder, findsOneWidget);
    final controller = tester.widget<InteractiveViewer>(viewerFinder).transformationController!;
    final yBefore = controller.value.getTranslation().y;

    // Drag upward (negative dy) in many small steps - the gesture a user
    // makes to pan the content up and reveal rows further down.
    // InteractiveViewer's ScaleGestureRecognizer computes pan from
    // frame-to-frame pointer deltas, so a single large tester.drag() jump
    // (its default behavior) doesn't reliably register as a pan the way a
    // real, gradual finger drag does. Starting from the top-left corner
    // (inside the table's own 16px padding margin, clear of any cell's
    // InkWell) avoids the gesture instead being claimed as a tap.
    final gesture = await tester.startGesture(tester.getTopLeft(viewerFinder) + const Offset(5, 5));
    for (var i = 0; i < 30; i++) {
      await gesture.moveBy(const Offset(0, -100));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pumpAndSettle();

    final yAfter = controller.value.getTranslation().y;
    // A nested horizontal-only ScrollView used to swallow this drag before
    // InteractiveViewer's own pan ever saw it, leaving yAfter == yBefore -
    // exactly the "can't scroll down" symptom.
    expect(yAfter, lessThan(yBefore));
  });
}
