import '../../models/user_progress.dart';

/// The 6-box Leitner spaced-repetition system from Abschnitt 10. Box index
/// 0-5 corresponds to Fach 1-6.
class Leitner {
  Leitner._();

  static const int boxCount = 6;
  static const int masteredBox = 5;

  /// Days until the next review, per box (Fach 1 -> 1 day, ..., Fach 6 -> 90 days).
  static const List<int> intervalDays = [1, 3, 7, 14, 30, 90];

  /// A brand-new card that has never been reviewed is due immediately.
  static LeitnerCardProgress newCard() => const LeitnerCardProgress(box: 0);

  static DateTime nextReviewDate(LeitnerCardProgress card) {
    final last = card.lastReviewed;
    if (last == null) return DateTime.fromMillisecondsSinceEpoch(0);
    final days = intervalDays[card.box.clamp(0, boxCount - 1)];
    return last.add(Duration(days: days));
  }

  static bool isDue(LeitnerCardProgress card, DateTime now) {
    if (card.lastReviewed == null) return true;
    return !nextReviewDate(card).isAfter(now);
  }

  /// Correct answer: move one box up (capped at the mastered box).
  static LeitnerCardProgress answerCorrect(LeitnerCardProgress card, DateTime now) {
    return card.copyWith(
      box: (card.box + 1).clamp(0, boxCount - 1),
      lastReviewed: now,
      correctCount: card.correctCount + 1,
    );
  }

  /// Wrong answer: fall back to Fach 1.
  static LeitnerCardProgress answerIncorrect(LeitnerCardProgress card, DateTime now) {
    return card.copyWith(
      box: 0,
      lastReviewed: now,
      incorrectCount: card.incorrectCount + 1,
    );
  }

  /// Used when a unit test is passed: every word in the unit is treated as
  /// already known (Fach 3) but stays in the review cycle.
  static LeitnerCardProgress setKnownFromUnitTest(LeitnerCardProgress card, DateTime now) {
    return card.copyWith(box: 2, lastReviewed: now);
  }
}
