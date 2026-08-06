import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/models/settings.dart';
import 'test_harness.dart';

void main() {
  testWidgets('the premium screen explains that purchases are unavailable when the store is unavailable', (tester) async {
    await pumpTestApp(
      tester,
      initialPrefs: {'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson())},
    );

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Amaseganlo Premium'), 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Amaseganlo Premium'));
    await tester.pumpAndSettle();

    // The test harness always uses UnavailablePurchaseClient (see
    // test_harness.dart) - the same state a real web build would be in,
    // since in_app_purchase has no web implementation. The message is
    // further down than the default test viewport, so scroll for it
    // directly rather than relying on scrollUntilVisible's own finder
    // tracking (it doesn't play well with textContaining here).
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.textContaining('nur über die App-Store'), findsOneWidget);
    expect(find.text('Jetzt freischalten'), findsNothing);
  });
}
