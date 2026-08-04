/// Result of updating the streak after the daily goal was reached on a
/// given date.
class StreakUpdate {
  final int currentStreak;
  final int longestStreak;
  final DateTime lastGoalMetDate;

  const StreakUpdate({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastGoalMetDate,
  });
}

/// Pure streak logic, deliberately Flutter-free so it can be unit tested
/// without a widget tree.
class StreakTracker {
  StreakTracker._();

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Call this whenever the daily XP goal is reached. Crossing midnight
  /// within the same continuous session does not break the streak - only a
  /// full missed calendar day does.
  static StreakUpdate goalReachedOn({
    required DateTime date,
    required DateTime? lastGoalMetDate,
    required int currentStreak,
    required int longestStreak,
  }) {
    final today = _dateOnly(date);
    final last = lastGoalMetDate != null ? _dateOnly(lastGoalMetDate) : null;

    int newStreak;
    if (last == null) {
      newStreak = 1;
    } else if (last.isAtSameMomentAs(today)) {
      newStreak = currentStreak == 0 ? 1 : currentStreak;
    } else if (today.difference(last).inDays == 1) {
      newStreak = currentStreak + 1;
    } else {
      newStreak = 1;
    }

    return StreakUpdate(
      currentStreak: newStreak,
      longestStreak: newStreak > longestStreak ? newStreak : longestStreak,
      lastGoalMetDate: today,
    );
  }

  /// Whether the streak should be considered broken as of [now], i.e. more
  /// than one full calendar day has passed since the goal was last met
  /// without it being met again.
  static bool isBroken({required DateTime? lastGoalMetDate, required DateTime now}) {
    if (lastGoalMetDate == null) return false;
    final gap = _dateOnly(now).difference(_dateOnly(lastGoalMetDate)).inDays;
    return gap > 1;
  }
}
