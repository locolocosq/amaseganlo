import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/models/settings.dart';
import 'test_harness.dart';

void main() {
  testWidgets('with nothing learned yet, the dictionary shows its empty state', (tester) async {
    await pumpTestApp(
      tester,
      initialPrefs: {'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson())},
    );

    await tester.tap(find.byIcon(Icons.refresh_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wörterbuch'));
    await tester.pumpAndSettle();

    expect(find.text('In diesem Thema noch keine Wörter gelernt.'), findsOneWidget);
  });
}
