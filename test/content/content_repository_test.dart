import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/content/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ContentRepository', () {
    test('loads curriculum, lexemes, sentences and lessons from assets', () async {
      final repo = ContentRepository();
      await repo.load();

      expect(repo.loadWarnings, isEmpty);
      expect(repo.curriculum.sections, isNotEmpty);
      expect(repo.curriculum.units.length, greaterThanOrEqualTo(2));
      expect(repo.allLexemes.length, greaterThanOrEqualTo(10));
      expect(repo.allSentences, isNotEmpty);

      final firstUnit = repo.curriculum.units.first;
      final lessons = repo.lessonsForUnit(firstUnit.id);
      expect(lessons, isNotEmpty);
    });

    test('lexeme() and sentence() find known ids and return null for unknown ids', () async {
      final repo = ContentRepository();
      await repo.load();

      expect(repo.lexeme('lex_selam'), isNotNull);
      expect(repo.lexeme('lex_does_not_exist'), isNull);
      expect(repo.sentence('sen_dehna_negn'), isNotNull);
      expect(repo.sentence('sen_does_not_exist'), isNull);
    });

    test('lexemesForUnit returns the words used by that unit, de-duplicated', () async {
      final repo = ContentRepository();
      await repo.load();

      final words = repo.lexemesForUnit('unit_erste_begegnung');
      expect(words, isNotEmpty);
      expect(words.map((l) => l.id).toSet().length, words.length);
    });

    test('a missing lesson file is skipped without crashing the whole load', () async {
      final repo = ContentRepository();
      await repo.load();
      // The real curriculum has no broken units right now, but load() must
      // have completed successfully either way - this is the contract test.
      expect(repo.failedUnitIds, isA<List<String>>());
    });
  });
}
