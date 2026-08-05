import '../models/user_progress.dart';

/// The fixed catalog of achievement badges shown on the profile screen.
///
/// Badges are computed live from [UserProgress] instead of being persisted
/// via [UserProgress.badges]/`awardBadge` - every underlying stat used here
/// (xpTotal, longestStreak, lexemeCards/fidelCards counts, unitCrowns) only
/// ever grows over the life of a save file, so a live computation always
/// gives the same "earned forever" result as a persisted one-time award,
/// without needing to find and hook every place a badge could be triggered.
enum BadgeId {
  firstLesson,
  streak7,
  streak30,
  words100,
  words500,
  fidelMaster,
  xp1000,
  firstCrown,
}

class BadgeCatalog {
  BadgeCatalog._();

  static const int fidelMasterThreshold = 231; // all 33 groups x 7 orders

  static bool isEarned(BadgeId id, UserProgress progress) {
    switch (id) {
      case BadgeId.firstLesson:
        return progress.lessonProgress.values.any((l) => l.completed);
      case BadgeId.streak7:
        return progress.longestStreak >= 7;
      case BadgeId.streak30:
        return progress.longestStreak >= 30;
      case BadgeId.words100:
        return progress.lexemeCards.length >= 100;
      case BadgeId.words500:
        return progress.lexemeCards.length >= 500;
      case BadgeId.fidelMaster:
        return progress.fidelCards.length >= fidelMasterThreshold;
      case BadgeId.xp1000:
        return progress.xpTotal >= 1000;
      case BadgeId.firstCrown:
        return progress.unitCrowns.isNotEmpty;
    }
  }

  static List<BadgeId> earnedBadges(UserProgress progress) =>
      BadgeId.values.where((id) => isEarned(id, progress)).toList();
}
