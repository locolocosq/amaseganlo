import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/models/settings.dart';
import 'package:amaseganlo/models/user_progress.dart';
import 'test_harness.dart';

void main() {
  testWidgets('dictionary lists learned words and filters by search', (tester) async {
    final seeded = UserProgress(
      lexemeCards: {
        'lex_selam': const LeitnerCardProgress(box: 1),
        'lex_awo': const LeitnerCardProgress(box: 1),
      },
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

    await tester.tap(find.text('Wörterbuch'));
    await tester.pumpAndSettle();

    expect(find.text('ሰላም'), findsOneWidget);
    expect(find.text('selam'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzz-no-match');
    await tester.pumpAndSettle();

    expect(find.text('Keine Treffer.'), findsOneWidget);
    expect(find.text('ሰላም'), findsNothing);
  });
}
