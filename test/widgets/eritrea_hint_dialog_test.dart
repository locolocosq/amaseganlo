import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

/// Etappe 26: a one-time, dezent hint about the new Eritrea/Tigrinya region
/// shows itself right after onboarding, on first arrival at the world map,
/// then never again once dismissed.
void main() {
  testWidgets(
    'the Eritrea hint dialog shows once on first arrival at the world map, then never again',
    (tester) async {
      await pumpTestApp(
        tester,
        forceEritreaHintSeen: false,
        initialPrefs: {
          'amaseganlo.settings': jsonEncode(
            const AppSettings(localeCode: 'de').toJson(),
          ),
        },
      );

      expect(find.text('Neu: Eritrea entdecken'), findsOneWidget);

      await tester.tap(find.text('Verstanden'));
      await tester.pumpAndSettle();

      expect(find.text('Neu: Eritrea entdecken'), findsNothing);

      // Rebuilding the screen (e.g. switching tabs and back) must not
      // re-trigger it - the persisted flag, not just in-memory state, is what
      // gates it.
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.route_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Neu: Eritrea entdecken'), findsNothing);
    },
  );
}
