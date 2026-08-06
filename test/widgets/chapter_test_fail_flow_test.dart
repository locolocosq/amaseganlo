import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

void main() {
  testWidgets(
    'skipping every chapter-test question fails it and offers an immediate retry',
    (tester) async {
      await pumpTestApp(
        tester,
        initialPrefs: {
          'amaseganlo.settings': jsonEncode(
            const AppSettings(localeCode: 'de').toJson(),
          ),
        },
      );

      // The world map only shows regions - zoom into Addis Abeba (by its
      // exact section title, to avoid any ambiguity about node ordering
      // on the map) to reach its stations.
      await tester.tap(find.text('Station 1: Addis Abeba — die Hauptstadt-Ankunft'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Erste Begegnung'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Kapitel-Test'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kapitel-Test'));
      await tester.pumpAndSettle();

      // "Ich weiß es nicht" deterministically fails every question regardless
      // of exercise type - answer all 7 of unit_erste_begegnung's words.
      for (var i = 0; i < 7; i++) {
        await tester.tap(find.text('Ich weiß es nicht'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Weiter'));
        await tester.pumpAndSettle();
      }

      expect(find.text('Noch nicht bestanden'), findsOneWidget);
      expect(find.text('0 von 7 richtig'), findsOneWidget);
      expect(find.text('Nochmal'), findsOneWidget);

      // Retry starts a fresh attempt instead of staying on the result screen.
      await tester.tap(find.text('Nochmal'));
      await tester.pumpAndSettle();

      expect(find.text('Noch nicht bestanden'), findsNothing);
      expect(find.text('Ich weiß es nicht'), findsOneWidget);
    },
  );
}
