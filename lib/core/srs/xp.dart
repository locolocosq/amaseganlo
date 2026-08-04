/// XP rewards from Abschnitt 11. Pure functions, no Flutter dependency.
class XpRules {
  XpRules._();

  static const int lessonBase = 10;
  static const int perfectBonus = 5;
  static const int reviewSessionBonus = 5;
  static const int unitTestBase = 10;

  static int forLesson({required bool perfect}) => lessonBase + (perfect ? perfectBonus : 0);

  static int forReviewSession() => reviewSessionBonus;

  static int forUnitTest({required bool perfect}) => unitTestBase + (perfect ? perfectBonus : 0);
}
