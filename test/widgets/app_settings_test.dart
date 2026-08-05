import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

void main() {
  testWidgets('settings gear opens the settings screen', (tester) async {
    await pumpTestApp(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
  });
}
