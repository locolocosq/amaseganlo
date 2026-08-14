import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

void main() {
  testWidgets('Fidel stages beyond the free count are Premium-locked, not sequentially locked', (tester) async {
    await pumpTestApp(
      tester,
      initialPrefs: {'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson())},
    );

    await tester.tap(find.byIcon(Icons.abc_outlined));
    await tester.pumpAndSettle();

    // Stufe 1-3 (the alphabet basics) stay free - no lock icon on them.
    expect(find.text('Stufe 1: Die 33 Hauptbuchstaben'), findsOneWidget);
    expect(find.text('Stufe 4: Silben verbinden'), findsOneWidget);
    // Stufe 4 onward is Premium-gated - more than one stage shows the badge.
    expect(find.text('Premium erforderlich'), findsWidgets);

    await tester.tap(find.text('Stufe 4: Silben verbinden'));
    await tester.pumpAndSettle();

    // The Premium dialog, not the sequential "builds on previous" one - no
    // "trotzdem starten" escape hatch, matching the main path's paywall.
    expect(find.text('Das ist Teil von Habesha Speak Premium'), findsOneWidget);
    expect(find.text('Trotzdem starten'), findsNothing);

    await tester.tap(find.text('Lieber später'));
    await tester.pumpAndSettle();

    // Still on the stage list, not navigated into the locked stage.
    expect(find.text('Stufe 4: Silben verbinden'), findsOneWidget);
  });
}
