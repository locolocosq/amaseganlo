import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/core/journey_regions.dart';
import 'package:amaseganlo/widgets/common/journey_stop_banner.dart';

void main() {
  for (final region in JourneyRegion.values) {
    for (final showBus in [false, true]) {
      testWidgets('${region.name} paints without throwing (bus: $showBus)', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Center(
            child: SizedBox(width: 400, height: 154, child: JourneyStopBanner(region: region, current: showBus)),
          ),
        ));
        await tester.pump();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
