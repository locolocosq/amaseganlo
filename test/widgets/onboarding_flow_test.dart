import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

void main() {
  testWidgets(
    'a fresh install shows onboarding first, and finishing it lands on the main app',
    (tester) async {
      await pumpTestApp(
        tester,
        forceOnboardingCompleted: false,
        initialPrefs: {
          'amaseganlo.settings': jsonEncode(
            const AppSettings(localeCode: 'de').toJson(),
          ),
        },
      );

      // Step 1: welcome.
      expect(find.text('Selam! Willkommen bei Habesha Speak'), findsOneWidget);
      expect(find.byIcon(Icons.route_outlined), findsNothing);

      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();

      // Step 2: two paths.
      expect(find.text('Zwei Lernwege'), findsOneWidget);
      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();

      // Step 3: daily goal.
      expect(find.text('Wähle dein Tagesziel'), findsOneWidget);
      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();

      // Step 4: assessment - finish onboarding.
      expect(find.text('Kannst du schon etwas Amharisch?'), findsOneWidget);
      await tester.tap(find.text("Los geht's"));
      await tester.pumpAndSettle();

      // Landed on the main app shell now.
      expect(find.byIcon(Icons.route), findsOneWidget);
      expect(find.text('Selam! Willkommen bei Habesha Speak'), findsNothing);
    },
  );
}
