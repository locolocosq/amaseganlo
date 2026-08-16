import 'package:collection/collection.dart';

import '../content/content_repository.dart';
import '../models/curriculum.dart';
import '../models/settings.dart';
import '../models/user_progress.dart';

enum UnitState { completed, skipped, current, locked, premiumLocked }

/// How many of the very first curriculum section's units are playable
/// without Premium (Etappe 23) - the free trial. Deliberately a *count*,
/// not a hardcoded list of unit ids: whichever units the content team puts
/// first in `sec_a1_1` are the free ones, so reordering/adding content
/// there never silently changes the paywall boundary.
const int freeTrialUnitCount = 3;

/// The unit ids playable without Premium - the first [freeTrialUnitCount]
/// units of the first curriculum section *of each target language* (Etappe
/// 26: previously just "the first section", back when Amharic was the only
/// language - Eritrea's Tigrinya track gets its own free sample this way
/// too, instead of every one of its stations being Premium-locked from the
/// very first tap). For the single pre-existing 'am' language this is
/// exactly the same units as before (still `sections.first`, since 'am' is
/// still the first language encountered), so no existing behaviour changes.
/// Shared between [JourneyProgress] (map lock state) and the placement test
/// (must never auto-skip a learner *past* the paywall for free) so both
/// agree on exactly the same boundary.
List<String> freeTrialUnitIds(ContentRepository content) {
  final sections = content.curriculum.sections;
  if (sections.isEmpty) return const [];
  final seenLanguages = <String>{};
  final result = <String>[];
  for (final section in sections) {
    if (seenLanguages.add(section.language)) {
      result.addAll(section.unitIds.take(freeTrialUnitCount));
    }
  }
  return result;
}

/// How many of the Fidel path's stages (Stufe 1-8) are playable without
/// Premium (Etappe 24 Nachtrag 5, on request) - the alphabet basics
/// (letters, vowels, the Ha-Hu rows) stay free, syllable-joining onward
/// needs Premium, same split in spirit as [freeTrialUnitCount] for path A:
/// enough to get properly hooked, not the whole curriculum.
const int freeFidelStageCount = 3;

/// Whether Fidel stage [stageNumber] (1-based, matches [FidelStage.number])
/// requires Premium - shared between the stage list and the stage overview
/// screen's own defensive re-check, so both agree on exactly the same
/// boundary.
bool isFidelStagePremiumLocked(int stageNumber, bool isPremium) => !isPremium && stageNumber > freeFidelStageCount;

/// Where to send "Weiterlernen": the unit whose lesson was completed most
/// recently, if that unit still has an unfinished lesson (Abschnitt C1).
/// Returns null if nothing has been played yet, or the most recently
/// played unit is already fully done.
({String unitId, String lessonId})? findResumeTarget(
  ContentRepository content,
  UserProgress progress,
) {
  DateTime? mostRecent;
  String? unitId;
  for (final section in content.curriculum.sections) {
    for (final uId in section.unitIds) {
      for (final lesson in content.lessonsForUnit(uId)) {
        final lastPlayed = progress.lessonProgress[lesson.id]?.lastPlayed;
        if (lastPlayed != null && (mostRecent == null || lastPlayed.isAfter(mostRecent))) {
          mostRecent = lastPlayed;
          unitId = uId;
        }
      }
    }
  }
  if (unitId == null) return null;

  final lessons = content.lessonsForUnit(unitId);
  final nextLesson = lessons.firstWhereOrNull((l) => progress.lessonProgress[l.id]?.completed != true);
  if (nextLesson == null) return null;
  return (unitId: unitId, lessonId: nextLesson.id);
}

/// The single source of truth for "what state is unit/section X in" - used
/// by both journey-map levels (Etappe 14) so the world map, the region
/// detail map, and the lock dialog all agree with each other and with
/// what `UnitOverviewScreen`/lesson screens actually unlock. Computed live
/// from [ContentRepository]/[UserProgress] every time, never persisted
/// separately, so there is exactly one place this logic can drift.
class JourneyProgress {
  final ContentRepository content;
  final UserProgress progress;
  final AppSettings settings;
  final bool isPremium;

  JourneyProgress({required this.content, required this.progress, required this.settings, required this.isPremium});

  late final List<String> flatUnitIds = [for (final s in content.curriculum.sections) ...s.unitIds];

  /// Units grouped by [CurriculumSection.language] - Etappe 26. Sequential
  /// unlocking (below) is computed within one language's own list, not the
  /// single cross-language [flatUnitIds]: without this, Eritrea's first
  /// Tigrinya station would only unlock after every Amharic unit before it
  /// in [flatUnitIds] is done, since it sits after them there. Language
  /// tracks are otherwise fully independent - finishing one never affects
  /// the other's lock state.
  late final Map<String, List<String>> _unitIdsByLanguage = () {
    final map = <String, List<String>>{};
    for (final s in content.curriculum.sections) {
      map.putIfAbsent(s.language, () => []).addAll(s.unitIds);
    }
    return map;
  }();

  late final Map<String, String> _languageForUnit = {
    for (final s in content.curriculum.sections)
      for (final id in s.unitIds) id: s.language,
  };

  late final Set<String> _freeUnitIds = freeTrialUnitIds(content).toSet();

  /// Whether reaching this unit's content at all requires Premium - checked
  /// before sequential progress, so it also overrides
  /// `settings.allLessonsUnlocked` and any skip/placement-test result: none
  /// of those are allowed to substitute for actually buying it.
  bool isUnitPremiumLocked(String unitId) => !isPremium && !_freeUnitIds.contains(unitId);

  bool isUnitDone(String unitId) {
    final lessons = content.lessonsForUnit(unitId);
    if (lessons.isEmpty) return false;
    return lessons.every((l) => progress.lessonProgress[l.id]?.completed == true);
  }

  bool isUnitSkipped(String unitId) => progress.skippedUnitIds.contains(unitId);

  bool isSectionDone(CurriculumSection section) =>
      section.unitIds.isNotEmpty && section.unitIds.every((id) => isUnitDone(id) || isUnitSkipped(id));

  UnitState stateForFlatIndex(int flatIndex) => stateForUnit(flatUnitIds[flatIndex]);

  UnitState stateForUnit(String unitId) {
    if (isUnitPremiumLocked(unitId)) return UnitState.premiumLocked;
    if (isUnitDone(unitId)) return UnitState.completed;
    if (isUnitSkipped(unitId)) return UnitState.skipped;
    final language = _languageForUnit[unitId] ?? 'am';
    final unitsInLanguage = _unitIdsByLanguage[language] ?? const [];
    final indexInLanguage = unitsInLanguage.indexOf(unitId);
    if (settings.allLessonsUnlocked || indexInLanguage <= 0) {
      return UnitState.current;
    }
    final previousId = unitsInLanguage[indexInLanguage - 1];
    if (isUnitDone(previousId) || isUnitSkipped(previousId)) {
      return UnitState.current;
    }
    return UnitState.locked;
  }

  /// Every section belonging to one target language, in curriculum order -
  /// Etappe 27: the world map split into two independent, swipeable pages
  /// (Ethiopia/Amharic and Eritrea/Tigrinya), each with its own "you are
  /// here" bus position computed only from its own language's sections -
  /// finishing every Amharic region must never make Eritrea's own single
  /// section look "further along" than it really is, or vice versa.
  List<CurriculumSection> sectionsForLanguage(String language) => content.curriculum.sections.where((s) => s.language == language).toList();

  /// 0-based index (within `sectionsForLanguage(language)`, 1:1 with that
  /// language's own map-page region order) of the section that currently
  /// has the resume-worthy "you are here" unit - used to place the
  /// bus/camera on that language's own world-map page.
  int currentRegionIndexForLanguage(String language) {
    final sections = sectionsForLanguage(language);
    if (sections.isEmpty) return 0;
    final index = sections.indexWhere((s) => !isSectionDone(s));
    return index == -1 ? sections.length - 1 : index;
  }
}
