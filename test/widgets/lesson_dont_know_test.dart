import 'package:flutter_test/flutter_test.dart';

import 'test_harness.dart';

void main() {
  testWidgets('using "Ich weiß es nicht" shows the wrong-answer feedback bar', (tester) async {
    await pumpTestLesson(tester, unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_words');

    // "Ich weiß es nicht" deterministically produces a wrong-answer feedback
    // state regardless of which exercise type happened to be generated.
    await tester.tap(find.text('Ich weiß es nicht'));
    await tester.pumpAndSettle();

    expect(find.text('Nicht ganz'), findsOneWidget);
    expect(find.text('Weiter'), findsWidgets);
  });
}
