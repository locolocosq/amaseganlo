import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/core/srs/leitner.dart';
import 'package:amaseganlo/models/user_progress.dart';

void main() {
  group('Leitner', () {
    test('a new card starts in Fach 1 (box 0) and is due immediately', () {
      final card = Leitner.newCard();
      expect(card.box, 0);
      expect(Leitner.isDue(card, DateTime.now()), isTrue);
    });

    test('a correct answer moves the card one box up', () {
      final now = DateTime(2026, 1, 1);
      final card = Leitner.answerCorrect(Leitner.newCard(), now);
      expect(card.box, 1);
      expect(card.correctCount, 1);
      expect(card.lastReviewed, now);
    });

    test('box progression never exceeds the mastered box (Fach 6)', () {
      var card = Leitner.newCard();
      final now = DateTime(2026, 1, 1);
      for (var i = 0; i < 10; i++) {
        card = Leitner.answerCorrect(card, now);
      }
      expect(card.box, Leitner.masteredBox);
    });

    test('a wrong answer resets the card to Fach 1', () {
      const advanced = LeitnerCardProgress(box: 4);
      final card = Leitner.answerIncorrect(advanced, DateTime(2026, 1, 1));
      expect(card.box, 0);
      expect(card.incorrectCount, 1);
    });

    test('interval days match the spec: 1, 3, 7, 14, 30, 90', () {
      expect(Leitner.intervalDays, [1, 3, 7, 14, 30, 90]);
    });

    test('a card is not due before its interval has passed', () {
      final reviewed = DateTime(2026, 1, 1);
      const card = LeitnerCardProgress(box: 0, lastReviewed: null);
      final justReviewed = card.copyWith(lastReviewed: reviewed);
      final checkTime = reviewed.add(const Duration(hours: 12));
      expect(Leitner.isDue(justReviewed, checkTime), isFalse);
    });

    test('a card becomes due exactly after crossing its interval', () {
      final reviewed = DateTime(2026, 1, 1);
      final card = LeitnerCardProgress(box: 0, lastReviewed: reviewed);
      final dueTime = reviewed.add(const Duration(days: 1, seconds: 1));
      expect(Leitner.isDue(card, dueTime), isTrue);
    });

    test('unit test pass sets a card to Fach 3 (box 2) but keeps it reviewable', () {
      final card = Leitner.setKnownFromUnitTest(Leitner.newCard(), DateTime(2026, 1, 1));
      expect(card.box, 2);
      expect(Leitner.isDue(card, DateTime(2026, 1, 1)), isFalse);
      expect(Leitner.isDue(card, DateTime(2026, 1, 8)), isTrue);
    });
  });
}
