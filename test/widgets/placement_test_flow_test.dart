import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'package:habesha_speak/screens/path/placement_test_screen.dart';
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

      // Etappe 28 Nachtrag 10: the test now asks which language to place
      // into first (previously it silently walked all sections regardless
      // of language, in file order - Ethiopia only in practice, since
      // failing a block stops the test before it could ever reach Eritrea).
      await tester.tap(find.text('Äthiopisch (Amharisch)'));
      await tester.pumpAndSettle();

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

  testWidgets(
    'choosing Eritrean/Tigrinya only tests Tigrinya sections, not Ethiopia ones',
    (tester) async {
      // Etappe 28 Nachtrag 10: this is the actual bug the language-choice
      // step fixes - previously the test walked curriculum.sections in file
      // order regardless of language. All 6 Ethiopia sections come before
      // any Eritrea one, and failing a block stops the test right there, so
      // choosing "Eritrean" used to make no difference at all: nobody could
      // ever fail their way past Ethiopia into a Tigrinya question.
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

      await tester.tap(find.text('Eritreisch (Tigrinya)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Los geht's"));
      await tester.pumpAndSettle();

      for (var i = 0; i < 5; i++) {
        await tester.tap(find.text('Ich weiß es nicht'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Weiter'));
        await tester.pumpAndSettle();
      }

      // Still proposes Keren (Eritrea's first section) as the starting
      // point, not Addis Abeba - confirming the block was actually built
      // from Tigrinya vocabulary, not Amharic.
      expect(find.textContaining('Keren'), findsOneWidget);
    },
  );
}
