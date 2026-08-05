import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/srs/leitner.dart';
import '../core/srs/streak.dart';
import '../core/srs/xp.dart';
import '../core/storage_service.dart';
import '../models/user_progress.dart';

/// Owns the learner's persisted progress and is the only place that mutates
/// it. Every mutation saves immediately (Abschnitt C1: "Gespeichert wird
/// automatisch nach jeder einzelnen Übung").
class ProgressProvider extends ChangeNotifier {
  static const _key = 'amaseganlo.progress';

  final StorageService _storage;
  UserProgress _progress;
  bool corruptedOnLoad = false;

  ProgressProvider(this._storage) : _progress = const UserProgress() {
    _progress = _load();
  }

  UserProgress get progress => _progress;

  UserProgress _load() {
    final raw = _storage.readString(_key);
    if (raw == null) return const UserProgress();
    try {
      return UserProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      corruptedOnLoad = true;
      return const UserProgress();
    }
  }

  Future<void> _save() async {
    await _storage.writeString(_key, jsonEncode(_progress.toJson()));
  }

  Future<void> _mutate(UserProgress Function(UserProgress) updater) async {
    _progress = updater(_progress);
    notifyListeners();
    await _save();
  }

  int xpEarnedToday(DateTime now) => _progress.xpByDate[_dateKey(now)] ?? 0;

  String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Records a correct/incorrect answer for a vocabulary word and moves its
  /// Leitner card accordingly.
  Future<void> recordLexemeAnswer(String lexemeId, {required bool correct, DateTime? now}) {
    final time = now ?? DateTime.now();
    return _mutate((p) {
      final card = p.lexemeCards[lexemeId] ?? Leitner.newCard();
      final updated = correct ? Leitner.answerCorrect(card, time) : Leitner.answerIncorrect(card, time);
      return p.copyWith(lexemeCards: {...p.lexemeCards, lexemeId: updated});
    });
  }

  Future<void> recordFidelAnswer(String charId, {required bool correct, DateTime? now}) {
    final time = now ?? DateTime.now();
    return _mutate((p) {
      final card = p.fidelCards[charId] ?? Leitner.newCard();
      final updated = correct ? Leitner.answerCorrect(card, time) : Leitner.answerIncorrect(card, time);
      return p.copyWith(fidelCards: {...p.fidelCards, charId: updated});
    });
  }

  /// Adds XP, updates today's tally, and updates the streak if the daily
  /// goal is newly reached.
  Future<void> addXp(int amount, {required int dailyGoalXp, DateTime? now}) {
    final time = now ?? DateTime.now();
    return _mutate((p) {
      final dateKey = _dateKey(time);
      final todayBefore = p.xpByDate[dateKey] ?? 0;
      final todayAfter = todayBefore + amount;
      final newXpByDate = {...p.xpByDate, dateKey: todayAfter};

      var currentStreak = p.currentStreak;
      var longestStreak = p.longestStreak;
      var lastGoalMetDate = p.lastGoalMetDate;

      final goalNewlyReached = todayBefore < dailyGoalXp && todayAfter >= dailyGoalXp;
      if (goalNewlyReached) {
        final update = StreakTracker.goalReachedOn(
          date: time,
          lastGoalMetDate: p.lastGoalMetDate,
          currentStreak: p.currentStreak,
          longestStreak: p.longestStreak,
        );
        currentStreak = update.currentStreak;
        longestStreak = update.longestStreak;
        lastGoalMetDate = update.lastGoalMetDate;
      }

      return p.copyWith(
        xpTotal: p.xpTotal + amount,
        xpByDate: newXpByDate,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        lastGoalMetDate: lastGoalMetDate,
      );
    });
  }

  Future<void> completeLesson(String lessonId, {required double score, required bool perfect, required int dailyGoalXp}) async {
    await _mutate((p) {
      final existing = p.lessonProgress[lessonId] ?? const LessonProgress();
      final updated = existing.copyWith(
        completed: true,
        stars: _starsForScore(score),
        bestScore: score > existing.bestScore ? score : existing.bestScore,
        lastPlayed: DateTime.now(),
      );
      return p.copyWith(lessonProgress: {...p.lessonProgress, lessonId: updated});
    });
    await addXp(XpRules.forLesson(perfect: perfect), dailyGoalXp: dailyGoalXp);
  }

  int _starsForScore(double score) {
    if (score >= 1.0) return 3;
    if (score >= 0.85) return 2;
    if (score >= 0.6) return 1;
    return 0;
  }

  /// Chapter test passed (Teil A1): the unit is complete, gets a crown, and
  /// every one of its words is treated as known (Fach 3) but stays in review.
  Future<void> passUnitTest(String unitId, List<String> lexemeIds, {required int dailyGoalXp}) async {
    final now = DateTime.now();
    await _mutate((p) {
      final updatedCards = {...p.lexemeCards};
      for (final id in lexemeIds) {
        final card = updatedCards[id] ?? Leitner.newCard();
        updatedCards[id] = Leitner.setKnownFromUnitTest(card, now);
      }
      final crowns = {...p.unitCrowns};
      crowns[unitId] = 5;
      final skipped = {...p.skippedUnitIds}..remove(unitId);
      return p.copyWith(lexemeCards: updatedCards, unitCrowns: crowns, skippedUnitIds: skipped);
    });
    await addXp(XpRules.forUnitTest(perfect: false), dailyGoalXp: dailyGoalXp);
  }

  /// Chapter test failed: the missed words fall back to Fach 1, the unit
  /// stays open. No penalty beyond that.
  Future<void> failUnitTest(List<String> missedLexemeIds) async {
    final now = DateTime.now();
    await _mutate((p) {
      final updatedCards = {...p.lexemeCards};
      for (final id in missedLexemeIds) {
        final card = updatedCards[id] ?? Leitner.newCard();
        updatedCards[id] = Leitner.answerIncorrect(card, now);
      }
      return p.copyWith(lexemeCards: updatedCards);
    });
  }

  Future<void> markUnitSkipped(String unitId) {
    return _mutate((p) => p.copyWith(skippedUnitIds: {...p.skippedUnitIds, unitId}));
  }

  Future<void> awardBadge(String badgeId) {
    if (_progress.badges.contains(badgeId)) return Future.value();
    return _mutate((p) => p.copyWith(badges: {...p.badges, badgeId}));
  }

  Future<void> resetAll() async {
    await _mutate((_) => const UserProgress());
  }

  /// Serializes all progress for the "Fortschritt sichern" export
  /// (Abschnitt C1) - the exact same shape [_load] reads back on restore.
  String exportJson() => jsonEncode(_progress.toJson());

  /// Replaces all progress with the contents of a previously exported
  /// backup. Throws [FormatException]/[TypeError] on invalid input; the
  /// caller (a user-triggered settings action, not a silent startup path
  /// like [_load]) is expected to catch that and show an error.
  Future<void> importJson(String json) async {
    final decoded = UserProgress.fromJson(jsonDecode(json) as Map<String, dynamic>);
    await _mutate((_) => decoded);
  }

  List<String> dueLexemeIds(DateTime now) {
    return _progress.lexemeCards.entries.where((e) => Leitner.isDue(e.value, now)).map((e) => e.key).toList();
  }

  /// Words that are still stuck in the bottom two Leitner boxes and have
  /// been answered wrong at least once, worst-first - the "Schwierige
  /// Wörter" review mode from Abschnitt 9.
  List<String> difficultLexemeIds() {
    final entries = _progress.lexemeCards.entries.where((e) => e.value.incorrectCount > 0 && e.value.box <= 1).toList()
      ..sort((a, b) => b.value.incorrectCount.compareTo(a.value.incorrectCount));
    return entries.map((e) => e.key).toList();
  }

  /// Every word the learner has already been introduced to - the pool
  /// "freies Üben" draws from (optionally filtered by level in the UI).
  List<String> learnedLexemeIds() => _progress.lexemeCards.keys.toList();

  int get wordsLearned => _progress.lexemeCards.length;
  int get wordsMastered => _progress.lexemeCards.values.where((c) => c.box == Leitner.masteredBox).length;
  int get fidelCharsLearned => _progress.fidelCards.length;
  int get daysLearned => _progress.xpByDate.length;

  /// Share of correct answers across every word and Fidel sign ever
  /// answered, 0 if nothing has been answered yet.
  double get overallAccuracy {
    var correct = 0;
    var total = 0;
    for (final card in [..._progress.lexemeCards.values, ..._progress.fidelCards.values]) {
      correct += card.correctCount;
      total += card.correctCount + card.incorrectCount;
    }
    return total == 0 ? 0 : correct / total;
  }

  /// XP earned on each of the last [days] calendar days, oldest first.
  List<int> xpForLastDays(int days, DateTime now) {
    return [
      for (var i = days - 1; i >= 0; i--) xpEarnedToday(now.subtract(Duration(days: i))),
    ];
  }
}
