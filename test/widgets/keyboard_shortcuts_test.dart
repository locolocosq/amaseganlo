import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/models/settings.dart';
import 'package:amaseganlo/models/user_progress.dart';
import 'test_harness.dart';

void main() {
  testWidgets('Escape skips the current exercise and Enter continues, like the on-screen buttons', (tester) async {
    final seeded = UserProgress(
      lexemeCards: {'lex_selam': const LeitnerCardProgress(box: 0)},
    );
    await pumpTestApp(
      tester,
      initialPrefs: {
        'amaseganlo.progress': jsonEncode(seeded.toJson()),
        'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson()),
      },
    );

    await tester.tap(find.byIcon(Icons.refresh_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Heute fällig'));
    await tester.pumpAndSettle();

    // Escape is the keyboard equivalent of "Ich weiß es nicht".
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Nicht ganz'), findsOneWidget);

    // Enter is the keyboard equivalent of tapping "Weiter" once answered -
    // this session only has 1 word, so it finishes the review session.
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Wiederholung abgeschlossen!'), findsOneWidget);
  });
}
