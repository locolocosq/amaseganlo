import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/core/journey_regions.dart';
import 'package:amaseganlo/widgets/common/journey_stop_banner.dart';
import 'test_harness.dart';

void main() {
  testWidgets('the learning path shows the Addis Abeba stop banner as current when nothing is played yet', (tester) async {
    await pumpTestApp(tester);

    // The ListView only builds what's near the top without scrolling - that
    // is exactly the first section's banner, which is what this test cares
    // about (see ENTSCHEIDUNGEN.md on lazy ListView building in tests).
    final banner = tester.widget<JourneyStopBanner>(find.byType(JourneyStopBanner).first);
    expect(banner.region, JourneyRegion.addisAbeba);
    expect(banner.current, isTrue);
  });
}
