import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/journey_regions.dart';
import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

void main() {
  testWidgets('tapping a chapter beyond the free trial offers Premium instead of opening it', (tester) async {
    await pumpTestApp(
      tester,
      initialPrefs: {'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson())},
    );

    await tester.tap(findRegionNode(JourneyRegion.addisAbeba));
    await tester.pumpAndSettle();

    // "Zahlen 1-20" is the 4th unit of Station 1 - past the free trial's
    // first 3 units, so it's premium-locked regardless of progress.
    await tester.scrollUntilVisible(find.text('Zahlen 1-20'), 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zahlen 1-20'));
    await tester.pumpAndSettle();

    expect(find.text('Das ist Teil von Habesha Speak Premium'), findsOneWidget);
    // No "trotzdem starten" escape hatch for a paywalled chapter.
    expect(find.text('Trotzdem starten'), findsNothing);

    await tester.tap(find.text('Premium ansehen'));
    await tester.pumpAndSettle();

    // Landed on the premium screen (its own headline, not the dialog's
    // title, which no longer exists once the dialog is dismissed).
    expect(find.text('Schalte die ganze Reise frei'), findsOneWidget);
  });
}
