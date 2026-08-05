import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/models/settings.dart';
import 'package:amaseganlo/screens/path/placement_test_screen.dart';
import 'test_harness.dart';

void main() {
  testWidgets(
    'failing the very first block proposes starting at the beginning',
    (tester) async {
      await pumpTestApp(
        tester,
        initialPrefs: {
          'amaseganlo.settings': jsonEncode(
            const AppSettings(localeCode: 'de').toJson(),
          ),
        },
      );

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Einstufungstest'));
      await tester.pumpAndSettle();

      expect(find.byType(PlacementTestScreen), findsOneWidget);
      expect(
        find.textContaining('herauszufinden, wo du am besten anfängst'),
        findsOneWidget,
      );

      await tester.tap(find.text("Los geht's"));
      await tester.pumpAndSettle();

      // Skip every question of the first (A1.1) block - guaranteed <4/5 correct.
      for (var i = 0; i < 5; i++) {
        await tester.tap(find.text('Ich weiß es nicht'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Weiter'));
        await tester.pumpAndSettle();
      }

      expect(
        find.text(
          'Am besten fängst du ganz am Anfang an - das ist völlig normal!',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Übernehmen'));
      await tester.pumpAndSettle();

      expect(find.byType(PlacementTestScreen), findsNothing);
    },
  );
}
