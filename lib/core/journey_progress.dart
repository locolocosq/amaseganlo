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
/// units of the first curriculum section. Shared between [JourneyProgress]
/// (map lock state) and the placement test (must never auto-skip a learner
/// *past* the paywall for free) so both agree on exactly the same boundary.
List<String> freeTrialUnitIds(ContentRepository content) {
  final sections = content.curriculum.sections;
  if (sections.isEmpty) return const [];
  return sections.first.unitIds.take(freeTrialUnitCount).toList();
}

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

  /// The section the "you are here" marker should sit on: the first
  /// unfinished section, or the last one if everything is done.
  String get currentSectionId {
    final sections = content.curriculum.sections;
    return sections.firstWhereOrNull((s) => !isSectionDone(s))?.id ?? sections.last.id;
  }

  UnitState stateForFlatIndex(int flatIndex) {
    final unitId = flatUnitIds[flatIndex];
    if (isUnitPremiumLocked(unitId)) return UnitState.premiumLocked;
    if (isUnitDone(unitId)) return UnitState.completed;
    if (isUnitSkipped(unitId)) return UnitState.skipped;
    if (settings.allLessonsUnlocked || flatIndex == 0) return UnitState.current;
    final previousId = flatUnitIds[flatIndex - 1];
    if (isUnitDone(previousId) || isUnitSkipped(previousId)) return UnitState.current;
    return UnitState.locked;
  }

  UnitState stateForUnit(String unitId) => stateForFlatIndex(flatUnitIds.indexOf(unitId));

  /// 0-based index (within `curriculum.sections`, which is 1:1 with
  /// [WorldMapLayout.order]) of the region that currently has the
  /// resume-worthy "you are here" unit - used to place the bus/camera on
  /// the world map.
  int get currentRegionIndex {
    final sections = content.curriculum.sections;
    final index = sections.indexWhere((s) => !isSectionDone(s));
    return index == -1 ? sections.length - 1 : index;
  }
}
