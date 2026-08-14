import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.settings_outlined));
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(find.text('Daily reminder'), 400, scrollable: find.byType(Scrollable).first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('denied permission leaves the reminder off and shows an explanation', (tester) async {
    final client = FakeNotificationClient()..permissionGranted = false;
    await pumpTestApp(tester, notificationClient: client);
    await _openSettings(tester);

    await tester.tap(find.widgetWithText(SwitchListTile, 'Daily reminder'));
    await tester.pumpAndSettle();

    expect(client.scheduleCalls, 0);
    final tile = tester.widget<SwitchListTile>(find.widgetWithText(SwitchListTile, 'Daily reminder'));
    expect(tile.value, isFalse);
    expect(find.text('Notifications are blocked for Habesha Speak in your device settings'), findsOneWidget);
  });
}
