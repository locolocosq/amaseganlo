import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/journey_regions.dart';
import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

void main() {
  testWidgets('tapping a locked station offers to start it anyway', (tester) async {
    await pumpTestApp(
      tester,
      initialPrefs: {'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson())},
    );

    await tester.tap(findRegionNode(JourneyRegion.addisAbeba));
    await tester.pumpAndSettle();

    // "Ich und du" is the second unit - locked until the first is done, and
    // may not be within the initial scroll position (the map auto-scrolls
    // to the *current* station, not this one), so scroll it into view first.
    await tester.scrollUntilVisible(find.text('Ich und du'), 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ich und du'));
    await tester.pumpAndSettle();

    expect(find.text('Dieses Kapitel baut auf den vorherigen auf'), findsOneWidget);

    await tester.tap(find.text('Trotzdem starten'));
    await tester.pumpAndSettle();

    // Landed on the unit overview (unchanged screen), not still on the map.
    // "Ich und du" gained its own dedicated sentence-building stage
    // (previously it went straight from word practice to listening), so the
    // "Kapitel-Test" tile below the now-longer lesson list needs scrolling
    // into view first, same as eritrea_region_reachable_test.dart already
    // does for a different unit.
    await tester.scrollUntilVisible(find.text('Kapitel-Test'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('Kapitel-Test'), findsOneWidget);
  });
}
