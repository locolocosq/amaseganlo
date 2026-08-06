import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'package:habesha_speak/models/user_progress.dart';
import 'test_harness.dart';

void main() {
  testWidgets('profile shows stats and highlights earned badges', (tester) async {
    final seeded = UserProgress(
      xpTotal: 1000,
      longestStreak: 7,
      lexemeCards: {'lex_selam': const LeitnerCardProgress(box: 1, correctCount: 3, incorrectCount: 1)},
    );
    await pumpTestApp(
      tester,
      initialPrefs: {
        'amaseganlo.progress': jsonEncode(seeded.toJson()),
        'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson()),
      },
    );

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('Gelernte Wörter'), findsOneWidget);
    expect(find.text('1'), findsWidgets); // 1 word learned
    // Scoped to the stats grid: the app shell's AppBar (Etappe 19) now also
    // shows total XP as a standing badge, so a plain find.text('1000') would
    // match both and be ambiguous.
    expect(
      find.descendant(of: find.byType(GridView), matching: find.text('1000')),
      findsOneWidget,
    ); // total XP

    // The badges section is further down than the default test viewport -
    // scroll it into view before asserting on it.
    await tester.scrollUntilVisible(find.text('Abzeichen'), 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();

    expect(find.text('Abzeichen'), findsOneWidget);
    // xp1000 and streak7 badges are earned - their names should render.
    expect(find.text('1000 XP'), findsOneWidget);
    expect(find.text('Eine Woche dabei'), findsOneWidget);
    // Never having earned any badge before does not apply here (2 are
    // earned), so the "no badges yet" hint must not show.
    expect(find.text('Noch keine Abzeichen - leg los!'), findsNothing);
  });
}
