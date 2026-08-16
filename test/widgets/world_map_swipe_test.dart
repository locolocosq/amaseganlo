import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/journey_regions.dart';
import 'test_harness.dart';

/// Etappe 27 (+ Nachtrag): the world map became two independent, swipeable
/// pages (Äthiopien/Amharic and Eritrea/Tigrinya) instead of one shared map
/// with Eritrea as an extra node. Eritrea's own page is itself a 4-region
/// country map (Keren/Asmara/Massawa/Dahlak) now, not a single node - this
/// test only exercises the swipe itself and checks for the first of those
/// four nodes (Keren) as the page's signature. eritrea_region_reachable_test.dart
/// covers what happens once you actually tap into one of the four regions.
void main() {
  testWidgets('swiping the world map switches between the Ethiopia and Eritrea pages, and back', (tester) async {
    await pumpTestApp(tester);

    expect(findRegionNode(JourneyRegion.addisAbeba), findsOneWidget);
    expect(findRegionNode(JourneyRegion.keren), findsNothing);

    await tester.drag(find.byType(PageView), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(findRegionNode(JourneyRegion.keren), findsOneWidget);
    expect(findRegionNode(JourneyRegion.addisAbeba), findsNothing);

    await tester.drag(find.byType(PageView), const Offset(600, 0));
    await tester.pumpAndSettle();

    expect(findRegionNode(JourneyRegion.addisAbeba), findsOneWidget);
    expect(findRegionNode(JourneyRegion.keren), findsNothing);
  });
}
