import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

void main() {
  testWidgets('canceling the exit dialog keeps the lesson open', (tester) async {
    await pumpTestLesson(tester, unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_words');

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abbrechen'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.text('home'), findsNothing);
  });
}
