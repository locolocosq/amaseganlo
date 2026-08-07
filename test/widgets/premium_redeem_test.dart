import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/promo_codes.dart';
import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

void main() {
  testWidgets('redeeming a valid gift code unlocks Premium in the UI', (tester) async {
    await pumpTestApp(
      tester,
      initialPrefs: {'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson())},
    );

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Habesha Speak Premium'), 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Habesha Speak Premium'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -700));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), generateRandomPromoCode());
    await tester.tap(find.text('Einlösen'));
    await tester.pumpAndSettle();

    expect(find.text('Eingelöst - danke für deine Unterstützung!'), findsOneWidget);
    // A redeemed gift code grants the same entitlement a lifetime purchase
    // would (see PurchaseService.redeemPromoCode).
    expect(find.text('Dein Plan: Lebenslang - danke für deine Unterstützung!'), findsOneWidget);
  });
}
