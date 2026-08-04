import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/core/srs/streak.dart';

void main() {
  group('StreakTracker.goalReachedOn', () {
    test('first time the goal is ever reached starts a streak of 1', () {
      final result = StreakTracker.goalReachedOn(
        date: DateTime(2026, 1, 1),
        lastGoalMetDate: null,
        currentStreak: 0,
        longestStreak: 0,
      );
      expect(result.currentStreak, 1);
      expect(result.longestStreak, 1);
    });

    test('reaching the goal again on the same day does not double-count', () {
      final result = StreakTracker.goalReachedOn(
        date: DateTime(2026, 1, 1, 22),
        lastGoalMetDate: DateTime(2026, 1, 1, 9),
        currentStreak: 3,
        longestStreak: 5,
      );
      expect(result.currentStreak, 3);
    });

    test('reaching the goal on the very next calendar day extends the streak', () {
      final result = StreakTracker.goalReachedOn(
        date: DateTime(2026, 1, 2),
        lastGoalMetDate: DateTime(2026, 1, 1),
        currentStreak: 3,
        longestStreak: 5,
      );
      expect(result.currentStreak, 4);
      expect(result.longestStreak, 5);
    });

    test('crossing midnight within one continuous session still extends the streak', () {
      final lastGoalMet = DateTime(2026, 1, 1, 23, 50);
      final reachedAgain = DateTime(2026, 1, 2, 0, 10);
      final result = StreakTracker.goalReachedOn(
        date: reachedAgain,
        lastGoalMetDate: lastGoalMet,
        currentStreak: 1,
        longestStreak: 1,
      );
      expect(result.currentStreak, 2);
    });

    test('a full missed day resets the streak to 1, not to 0', () {
      final result = StreakTracker.goalReachedOn(
        date: DateTime(2026, 1, 5),
        lastGoalMetDate: DateTime(2026, 1, 1),
        currentStreak: 10,
        longestStreak: 10,
      );
      expect(result.currentStreak, 1);
      expect(result.longestStreak, 10);
    });

    test('a new streak can exceed the previous longest streak', () {
      final result = StreakTracker.goalReachedOn(
        date: DateTime(2026, 1, 2),
        lastGoalMetDate: DateTime(2026, 1, 1),
        currentStreak: 5,
        longestStreak: 5,
      );
      expect(result.longestStreak, 6);
    });
  });

  group('StreakTracker.isBroken', () {
    test('is not broken the same day or the next day', () {
      final last = DateTime(2026, 1, 1);
      expect(StreakTracker.isBroken(lastGoalMetDate: last, now: DateTime(2026, 1, 1, 23)), isFalse);
      expect(StreakTracker.isBroken(lastGoalMetDate: last, now: DateTime(2026, 1, 2)), isFalse);
    });

    test('is broken after a full missed day', () {
      final last = DateTime(2026, 1, 1);
      expect(StreakTracker.isBroken(lastGoalMetDate: last, now: DateTime(2026, 1, 3)), isTrue);
    });

    test('is never broken when the goal has never been met', () {
      expect(StreakTracker.isBroken(lastGoalMetDate: null, now: DateTime(2026, 1, 3)), isFalse);
    });
  });
}
