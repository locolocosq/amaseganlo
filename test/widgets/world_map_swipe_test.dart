import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/journey_regions.dart';
import 'test_harness.dart';

/// Etappe 27: the world map became two independent, swipeable pages
/// (Äthiopien/Amharic and Eritrea/Tigrinya) instead of one shared map with
/// Eritrea as an extra node. This test exercises the swipe itself, in both
/// directions - eritrea_region_reachable_test.dart covers what happens once
/// you actually tap into the Eritrea page.
void main() {
  testWidgets('swiping the world map switches between the Ethiopia and Eritrea pages, and back', (tester) async {
    await pumpTestApp(tester);

    expect(findRegionNode(JourneyRegion.addisAbeba), findsOneWidget);
    expect(findRegionNode(JourneyRegion.eritrea), findsNothing);

    await tester.drag(find.byType(PageView), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(findRegionNode(JourneyRegion.eritrea), findsOneWidget);
    expect(findRegionNode(JourneyRegion.addisAbeba), findsNothing);

    await tester.drag(find.byType(PageView), const Offset(600, 0));
    await tester.pumpAndSettle();

    expect(findRegionNode(JourneyRegion.addisAbeba), findsOneWidget);
    expect(findRegionNode(JourneyRegion.eritrea), findsNothing);
  });
}
