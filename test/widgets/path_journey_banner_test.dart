import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/journey_regions.dart';
import 'package:habesha_speak/widgets/journey/region_node_marker.dart';
import 'test_harness.dart';

void main() {
  testWidgets('the world map shows the Addis Abeba region node as current when nothing is played yet', (tester) async {
    await pumpTestApp(tester);

    final markers = tester.widgetList<RegionNodeMarker>(find.byType(RegionNodeMarker)).toList();
    final addisAbeba = markers.firstWhere((m) => m.region == JourneyRegion.addisAbeba);
    expect(addisAbeba.state, RegionVisualState.current);
  });
}
