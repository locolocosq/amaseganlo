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
  testWidgets('disabling the reminder cancels it', (tester) async {
    final client = FakeNotificationClient();
    await pumpTestApp(tester, notificationClient: client);
    await _openSettings(tester);

    await tester.tap(find.widgetWithText(SwitchListTile, 'Daily reminder'));
    await tester.pumpAndSettle();
    expect(client.scheduleCalls, 1);

    await tester.tap(find.widgetWithText(SwitchListTile, 'Daily reminder'));
    await tester.pumpAndSettle();

    expect(client.cancelCalls, 1);
    expect(find.text('Reminder time'), findsNothing);
  });
}
