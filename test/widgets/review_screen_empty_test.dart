import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

void main() {
  testWidgets('with nothing learned yet, review tiles are disabled and the empty hint shows', (tester) async {
    await pumpTestApp(
      tester,
      initialPrefs: {'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson())},
    );

    await tester.tap(find.byIcon(Icons.refresh_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Heute fällig'), findsOneWidget);
    expect(find.text('Schwierige Wörter'), findsOneWidget);
    expect(find.text('Freies Üben'), findsOneWidget);
    expect(find.text('Gerade nichts zu wiederholen. Weiter so!'), findsOneWidget);

    // Tapping a disabled tile (0 due words) must not navigate anywhere.
    await tester.tap(find.text('Heute fällig'));
    await tester.pumpAndSettle();
    expect(find.text('Heute fällig'), findsOneWidget);
  });
}
