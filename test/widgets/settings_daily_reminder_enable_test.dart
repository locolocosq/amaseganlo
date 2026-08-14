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
  testWidgets('enabling the daily reminder requests permission and schedules it', (tester) async {
    final client = FakeNotificationClient();
    await pumpTestApp(tester, notificationClient: client);
    await _openSettings(tester);

    await tester.tap(find.widgetWithText(SwitchListTile, 'Daily reminder'));
    await tester.pumpAndSettle();

    expect(client.scheduleCalls, 1);
    expect(client.lastScheduledHour, 19);
    expect(client.lastScheduledMinute, 0);
    expect(find.text('Reminder time'), findsOneWidget);
  });
}
