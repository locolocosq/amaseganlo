import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/dev_code.dart';
import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

/// Etappe 24: the old visible "redeem a gift code" field on the Premium
/// screen is gone - Premium now unlocks only via the two store buttons, or
/// via one hidden developer code entered by tapping the version number on
/// the About screen 7 times (the same "tap the build number" pattern
/// Android's own Settings app uses), never advertised anywhere in the UI.
void main() {
  testWidgets('tapping the version number 7 times reveals a dialog where the hidden dev code unlocks Premium', (tester) async {
    // A throwaway test code/hash pair, not the real one - see dev_code.dart
    // for why the real code must never appear in a public test file.
    debugSetDevCodeHashForTesting('208bfb17d0ca0bf52b3468587f2362d5d28211ba60f8ed4bba0bd205112a5f76');
    addTearDown(() => debugSetDevCodeHashForTesting(null));

    await pumpTestApp(
      tester,
      initialPrefs: {'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson())},
    );

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Über die App'), 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Über die App'));
    await tester.pumpAndSettle();

    // Nothing on screen hints that this does anything - a stray tap or two
    // (e.g. someone just glancing at the version) must stay a no-op.
    final versionFinder = find.textContaining('Version');
    for (var i = 0; i < 6; i++) {
      await tester.tap(versionFinder);
      await tester.pump();
    }
    expect(find.text('Code eingeben'), findsNothing);

    await tester.tap(versionFinder);
    await tester.pumpAndSettle();
    expect(find.text('Code eingeben'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'test-only-code');
    await tester.tap(find.text('Einlösen'));
    await tester.pumpAndSettle();

    expect(find.text('Premium wurde freigeschaltet.'), findsOneWidget);

    // The dev code grants the exact same entitlement a lifetime purchase
    // would (PurchaseService.redeemDevCode) - confirm it actually stuck by
    // checking the Premium screen itself, not just the snackbar.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Habesha Speak Premium'));
    await tester.pumpAndSettle();

    expect(find.text('Dein Plan: Lebenslang - danke für deine Unterstützung!'), findsOneWidget);
  });
}
