import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

void main() {
  testWidgets('tapping close shows the exit confirmation dialog', (tester) async {
    await pumpTestLesson(tester, unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_words');

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('Lektion wirklich beenden?'), findsOneWidget);

    await tester.tap(find.text('Abbrechen'));
    await tester.pumpAndSettle();
  });
}
