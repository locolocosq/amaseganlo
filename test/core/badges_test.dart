import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/badges.dart';
import 'package:habesha_speak/models/user_progress.dart';

void main() {
  group('BadgeCatalog', () {
    test('nothing is earned on a fresh save', () {
      expect(BadgeCatalog.earnedBadges(const UserProgress()), isEmpty);
    });

    test('firstLesson is earned once a lesson is completed', () {
      const progress = UserProgress(lessonProgress: {'l1': LessonProgress(completed: true)});
      expect(BadgeCatalog.isEarned(BadgeId.firstLesson, progress), isTrue);
    });

    test('streak badges use the longest streak, not the current one', () {
      const progress = UserProgress(currentStreak: 1, longestStreak: 7);
      expect(BadgeCatalog.isEarned(BadgeId.streak7, progress), isTrue);
      expect(BadgeCatalog.isEarned(BadgeId.streak30, progress), isFalse);
    });

    test('word-count badges use the number of distinct lexeme cards', () {
      final cards = {for (var i = 0; i < 100; i++) 'lex_$i': const LeitnerCardProgress()};
      final progress = UserProgress(lexemeCards: cards);
      expect(BadgeCatalog.isEarned(BadgeId.words100, progress), isTrue);
      expect(BadgeCatalog.isEarned(BadgeId.words500, progress), isFalse);
    });

    test('fidelMaster requires all 231 signs to have a card', () {
      final almost = {for (var i = 0; i < 230; i++) 'sign_$i': const LeitnerCardProgress()};
      final all = {for (var i = 0; i < 231; i++) 'sign_$i': const LeitnerCardProgress()};
      expect(BadgeCatalog.isEarned(BadgeId.fidelMaster, UserProgress(fidelCards: almost)), isFalse);
      expect(BadgeCatalog.isEarned(BadgeId.fidelMaster, UserProgress(fidelCards: all)), isTrue);
    });

    test('xp1000 and firstCrown thresholds', () {
      expect(BadgeCatalog.isEarned(BadgeId.xp1000, const UserProgress(xpTotal: 999)), isFalse);
      expect(BadgeCatalog.isEarned(BadgeId.xp1000, const UserProgress(xpTotal: 1000)), isTrue);
      expect(BadgeCatalog.isEarned(BadgeId.firstCrown, const UserProgress(unitCrowns: {'u1': 5})), isTrue);
      expect(BadgeCatalog.isEarned(BadgeId.firstCrown, const UserProgress()), isFalse);
    });

    test('earnedBadges returns exactly the ids that are earned', () {
      const progress = UserProgress(xpTotal: 1000, longestStreak: 7);
      final earned = BadgeCatalog.earnedBadges(progress);
      expect(earned, containsAll([BadgeId.xp1000, BadgeId.streak7]));
      expect(earned, isNot(contains(BadgeId.streak30)));
    });
  });
}
