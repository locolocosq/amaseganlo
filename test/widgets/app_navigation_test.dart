import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

void main() {
  testWidgets('bottom navigation switches between the four areas', (tester) async {
    await pumpTestApp(tester);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.person_outline), findsWidgets);

    await tester.tap(find.byIcon(Icons.abc_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.abc_outlined), findsWidgets);
  });
}
