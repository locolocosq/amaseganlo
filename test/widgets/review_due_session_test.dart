import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'package:habesha_speak/models/user_progress.dart';
import 'test_harness.dart';

void main() {
  testWidgets('starting a due-words review session and finishing it awards XP and shows completion', (tester) async {
    final seeded = UserProgress(
      lexemeCards: {'lex_selam': const LeitnerCardProgress(box: 0)},
    );
    await pumpTestApp(
      tester,
      initialPrefs: {
        'amaseganlo.progress': jsonEncode(seeded.toJson()),
        // pumpTestApp otherwise falls back to the test environment's default
        // locale (English), but this test's expectations are in German.
        'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson()),
      },
    );

    await tester.tap(find.byIcon(Icons.refresh_outlined));
    await tester.pumpAndSettle();

    expect(find.text('1 Wort'), findsWidgets);

    await tester.tap(find.text('Heute fällig'));
    await tester.pumpAndSettle();

    // "Ich weiß es nicht" deterministically produces a wrong-answer feedback
    // state regardless of which exercise type was generated for the word.
    await tester.tap(find.text('Ich weiß es nicht'));
    await tester.pumpAndSettle();
    expect(find.text('Nicht ganz'), findsOneWidget);

    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();

    expect(find.text('Wiederholung abgeschlossen!'), findsOneWidget);
    expect(find.text('+5 XP'), findsOneWidget);
  });
}
