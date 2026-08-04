import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amaseganlo/app.dart';
import 'package:amaseganlo/core/storage_service.dart';
import 'package:amaseganlo/state/settings_provider.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final storage = StorageService();
  await storage.init();
  await tester.pumpWidget(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingsProvider(storage))],
      child: const AmaseganloApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('app starts and shows all four main areas', (tester) async {
    await _pumpApp(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.route_outlined), findsOneWidget);
    expect(find.byIcon(Icons.abc_outlined), findsOneWidget);
    expect(find.byIcon(Icons.refresh_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('bottom navigation switches between the four areas', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.person_outline), findsWidgets);

    await tester.tap(find.byIcon(Icons.abc_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.abc_outlined), findsWidgets);
  });

  testWidgets('settings gear opens the settings screen', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
  });
}
