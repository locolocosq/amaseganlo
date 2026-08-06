import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

void main() {
  testWidgets('tapping a region on the world map zooms into its station map', (tester) async {
    await pumpTestApp(
      tester,
      initialPrefs: {'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson())},
    );

    await tester.tap(find.text('Station 1: Addis Abeba — die Hauptstadt-Ankunft'));
    await tester.pumpAndSettle();

    // Landed on the region detail screen: its AppBar shows the section
    // title, and its own back button is present.
    expect(find.text('Station 1: Addis Abeba — die Hauptstadt-Ankunft'), findsOneWidget);
    expect(find.text('Erste Begegnung'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Back on the world map.
    expect(find.text('Erste Begegnung'), findsNothing);
  });
}
