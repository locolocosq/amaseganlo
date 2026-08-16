import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/journey_regions.dart';
import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

/// Etappe 26/27: the new Eritrea/Tigrinya map must be reachable (by
/// swiping over from the Ethiopia map, Etappe 27) and its first station
/// playable from a completely fresh install - independent of how far the
/// learner has gotten in the (unrelated) Amharic curriculum. This is the
/// point of JourneyProgress's per-language unlock tracks: with the single
/// old cross-language flatUnitIds list, Eritrea's first station would have
/// stayed locked until every Amharic unit before it was done.
void main() {
  testWidgets(
    'the Eritrea region node is reachable and its first station is not sequentially locked behind Amharic',
    (tester) async {
      await pumpTestApp(
        tester,
        initialPrefs: {
          'amaseganlo.settings': jsonEncode(
            const AppSettings(localeCode: 'de').toJson(),
          ),
        },
      );

      // Eritrea lives on its own map page now (Etappe 27) - swipe the world
      // map's PageView left to get there before its node exists in the tree.
      expect(findRegionNode(JourneyRegion.eritrea), findsNothing);
      await tester.drag(find.byType(PageView), const Offset(-600, 0));
      await tester.pumpAndSettle();

      expect(findRegionNode(JourneyRegion.eritrea), findsOneWidget);
      await tester.tap(findRegionNode(JourneyRegion.eritrea));
      await tester.pumpAndSettle();

      expect(find.text('Eritrea — Tigrinya entdecken'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Begrüßung & Pronomen'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Begrüßung & Pronomen'), findsOneWidget);

      await tester.tap(find.text('Begrüßung & Pronomen'));
      await tester.pumpAndSettle();

      // Landed straight on the unit overview (unchanged screen), not still on
      // the map - no "Dieses Kapitel baut auf den vorherigen auf" locked
      // dialog in the way, even though not a single Amharic unit has been
      // touched. The "Kapitel-Test" tile sits below the lesson list, past
      // this short screen's fold, so it needs scrolling into view first
      // (the same reason dev_code_unlock_test.dart scrolls for the settings
      // screen's own last entry).
      expect(
        find.text('Dieses Kapitel baut auf den vorherigen auf'),
        findsNothing,
      );
      await tester.scrollUntilVisible(
        find.text('Kapitel-Test'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Kapitel-Test'), findsOneWidget);
    },
  );
}
