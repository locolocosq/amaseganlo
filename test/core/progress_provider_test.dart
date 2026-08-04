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
  });
}
