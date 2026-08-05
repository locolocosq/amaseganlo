import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amaseganlo/core/storage_service.dart';
import 'package:amaseganlo/l10n/app_localizations.dart';
import 'package:amaseganlo/screens/fidel/fidel_table_screen.dart';
import 'package:amaseganlo/state/content_provider.dart';
import 'package:amaseganlo/state/progress_provider.dart';

void main() {
  testWidgets('the Fidel table renders a learned sign differently from an unlearned one', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();

    final contentProvider = ContentProvider();
    await contentProvider.load();

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
}
