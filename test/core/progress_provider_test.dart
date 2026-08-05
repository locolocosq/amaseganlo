import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amaseganlo/core/storage_service.dart';
import 'package:amaseganlo/state/progress_provider.dart';

Future<ProgressProvider> _freshProvider() async {
  SharedPreferences.setMockInitialValues({});
  final storage = StorageService();
  await storage.init();
  return ProgressProvider(storage);
}

void main() {
  group('ProgressProvider', () {
    test('starts with empty progress', () async {
      final provider = await _freshProvider();
      expect(provider.progress.xpTotal, 0);
      expect(provider.wordsLearned, 0);
    });

    test('recordLexemeAnswer creates and updates a Leitner card', () async {
      final provider = await _freshProvider();
      await provider.recordLexemeAnswer('lex_selam', correct: true);
      expect(provider.progress.lexemeCards['lex_selam']?.box, 1);

      await provider.recordLexemeAnswer('lex_selam', correct: false);
      expect(provider.progress.lexemeCards['lex_selam']?.box, 0);
    });

    test('addXp accumulates total XP and daily XP', () async {
      final provider = await _freshProvider();
      final now = DateTime(2026, 1, 1);
      await provider.addXp(10, dailyGoalXp: 50, now: now);
      await provider.addXp(5, dailyGoalXp: 50, now: now);

      expect(provider.progress.xpTotal, 15);
      expect(provider.xpEarnedToday(now), 15);
    });

    test('reaching the daily goal for the first time starts a streak', () async {
      final provider = await _freshProvider();
      final now = DateTime(2026, 1, 1);
      await provider.addXp(50, dailyGoalXp: 50, now: now);

      expect(provider.progress.currentStreak, 1);
      expect(provider.progress.lastGoalMetDate, DateTime(2026, 1, 1));
    });

    test('passUnitTest sets all given words to Fach 3 and awards a crown', () async {
      final provider = await _freshProvider();
      await provider.passUnitTest('unit_erste_begegnung', ['lex_selam', 'lex_awo'], dailyGoalXp: 50);

      expect(provider.progress.lexemeCards['lex_selam']?.box, 2);
      expect(provider.progress.lexemeCards['lex_awo']?.box, 2);
      expect(provider.progress.unitCrowns['unit_erste_begegnung'], 5);
    });

    test('failUnitTest sends the missed words back to Fach 1 and unlocks nothing', () async {
      final provider = await _freshProvider();
      await provider.recordLexemeAnswer('lex_selam', correct: true);
      await provider.recordLexemeAnswer('lex_selam', correct: true);
      expect(provider.progress.lexemeCards['lex_selam']?.box, 2);

      await provider.failUnitTest(['lex_selam']);
      expect(provider.progress.lexemeCards['lex_selam']?.box, 0);
      expect(provider.progress.unitCrowns['unit_erste_begegnung'], isNull);
    });

    test('awardBadge is idempotent', () async {
      final provider = await _freshProvider();
      await provider.awardBadge('first_lesson');
      await provider.awardBadge('first_lesson');
      expect(provider.progress.badges, {'first_lesson'});
    });

    test('resetAll clears everything back to a fresh state', () async {
      final provider = await _freshProvider();
      await provider.addXp(100, dailyGoalXp: 50);
      await provider.recordLexemeAnswer('lex_selam', correct: true);

      await provider.resetAll();

      expect(provider.progress.xpTotal, 0);
      expect(provider.progress.lexemeCards, isEmpty);
    });

    test('progress persists across provider instances using the same storage', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = StorageService();
      await storage.init();

      final provider1 = ProgressProvider(storage);
      await provider1.addXp(42, dailyGoalXp: 50);

      final provider2 = ProgressProvider(storage);
      expect(provider2.progress.xpTotal, 42);
    });

    test('difficultLexemeIds only returns words stuck low that have been missed at least once, worst first', () async {
      final provider = await _freshProvider();
      // Brand new, never answered wrong - low box but not "difficult".
      await provider.recordLexemeAnswer('lex_new', correct: true);
      // Missed once, still low.
      await provider.recordLexemeAnswer('lex_shaky', correct: false);
      // Missed repeatedly, still low - should rank first.
      await provider.recordLexemeAnswer('lex_worst', correct: false);
      await provider.recordLexemeAnswer('lex_worst', correct: true);
      await provider.recordLexemeAnswer('lex_worst', correct: false);
      await provider.recordLexemeAnswer('lex_worst', correct: false);
      // Wrong before but climbed out of the bottom boxes - should not appear.
      await provider.recordLexemeAnswer('lex_recovered', correct: false);
      for (var i = 0; i < 6; i++) {
        await provider.recordLexemeAnswer('lex_recovered', correct: true);
      }

      final difficult = provider.difficultLexemeIds();
      expect(difficult.first, 'lex_worst');
      expect(difficult, contains('lex_shaky'));
      expect(difficult, isNot(contains('lex_new')));
      expect(difficult, isNot(contains('lex_recovered')));
    });

    test('learnedLexemeIds returns every word with a card, regardless of box', () async {
      final provider = await _freshProvider();
      await provider.recordLexemeAnswer('lex_a', correct: true);
      await provider.recordLexemeAnswer('lex_b', correct: false);

      expect(provider.learnedLexemeIds().toSet(), {'lex_a', 'lex_b'});
    });

    test('overallAccuracy is 0 with nothing answered and reflects the correct/wrong ratio otherwise', () async {
      final provider = await _freshProvider();
      expect(provider.overallAccuracy, 0);

      await provider.recordLexemeAnswer('lex_a', correct: true);
      await provider.recordLexemeAnswer('lex_a', correct: true);
      await provider.recordLexemeAnswer('lex_a', correct: false);

      expect(provider.overallAccuracy, closeTo(2 / 3, 0.0001));
    });

    test('exportJson/importJson round-trip restores an equivalent progress state', () async {
      final provider = await _freshProvider();
      await provider.addXp(30, dailyGoalXp: 50, now: DateTime(2026, 1, 1));
      await provider.recordLexemeAnswer('lex_selam', correct: true);
      final exported = provider.exportJson();

      final other = await _freshProvider();
      await other.addXp(5, dailyGoalXp: 50);
      await other.importJson(exported);

      expect(other.progress.xpTotal, 30);
      expect(other.progress.lexemeCards['lex_selam']?.box, 1);
    });

    test('importJson rejects invalid JSON without touching existing progress', () async {
      final provider = await _freshProvider();
      await provider.addXp(10, dailyGoalXp: 50);

      await expectLater(provider.importJson('not valid json'), throwsA(anything));
      expect(provider.progress.xpTotal, 10);
    });

    test('xpForLastDays returns each day\'s XP oldest first, 0 for days with no activity', () async {
      final provider = await _freshProvider();
      final today = DateTime(2026, 1, 10);
      await provider.addXp(20, dailyGoalXp: 50, now: today.subtract(const Duration(days: 2)));
      await provider.addXp(15, dailyGoalXp: 50, now: today);

      final last3 = provider.xpForLastDays(3, today);
      expect(last3, [20, 0, 15]);
    });
  });
}
