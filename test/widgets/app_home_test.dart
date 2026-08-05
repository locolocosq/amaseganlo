import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

void main() {
  testWidgets('app starts and shows all four main areas', (tester) async {
    await pumpTestApp(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    // "Learn" is the initial tab, so it renders its filled selected icon;
    // the other three are unselected and show their outlined icons.
    expect(find.byIcon(Icons.route), findsOneWidget);
    expect(find.byIcon(Icons.abc_outlined), findsOneWidget);
    expect(find.byIcon(Icons.refresh_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });
}
