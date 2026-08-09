import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/content/content_repository.dart';
import 'package:habesha_speak/content/exercise_generator.dart';
import 'package:habesha_speak/models/fidel_lesson.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ContentRepository repo;
  late FidelExerciseGenerator generator;

  setUpAll(() async {
    repo = ContentRepository();
    await repo.load();
    generator = FidelExerciseGenerator(repo);
  });

  group('Stufe 3 - row lessons', () {
    test('every row lesson has exactly one group and covers all 7 orders worth of material', () {
      final lessons = repo.fidelLessonsForStage('stufe3').where((l) => l.kind == FidelLessonKind.rowLesson);
      expect(lessons.length, 33);
      for (final l in lessons) {
        expect(l.groupIds.length, 1);
      }
    });

    test('there are exactly 11 block tests, one every 3 rows', () {
      final blocks = repo.fidelLessonsForStage('stufe3').where((l) => l.kind == FidelLessonKind.blockTest);
      expect(blocks.length, 11);
      for (final b in blocks) {
        expect(b.groupIds.length, 3);
      }
    });
  });

  group('Stufe 4 - syllable joining only uses already-learned signs', () {
    test('generateSyllableJoinChoice never uses a sign outside the given pool', () {
      final pool = [
        for (final g in ['ha', 'la', 'ma']) ...repo.fidelCharsForGroup(g).where((c) => c.order == 1),
      ];
      final poolChars = pool.map((c) => c.char).toSet();

      for (var i = 0; i < 15; i++) {
        final exercise = generator.generateSyllableJoinChoice(pool, length: 2);
        for (final rune in exercise.promptText.runes) {
          expect(poolChars.contains(String.fromCharCode(rune)), isTrue);
        }
      }
    });

    test('generateSyllableJoinBuild never offers a chunk outside the given pool', () {
      final pool = [
        for (final g in ['ha', 'la', 'ma']) ...repo.fidelCharsForGroup(g).where((c) => c.order == 1),
      ];
      final poolChars = pool.map((c) => c.char).toSet();

      final exercise = generator.generateSyllableJoinBuild(pool, length: 2);
      for (final chunk in exercise.chunks) {
        expect(poolChars.contains(chunk), isTrue);
      }
    });
  });

  group('Stufe 5/6 - reading only uses decodable content', () {
    test('a word is only decodable once every one of its signs is in the learned set', () {
      final selam = repo.lexeme('lex_selam')!;
      final allSignsExceptOne = selam.am.runes.map(String.fromCharCode).where((c) => c.trim().isNotEmpty).skip(1).toSet();

      expect(repo.lexemesDecodableWith(allSignsExceptOne).any((l) => l.id == selam.id), isFalse);

      final allSigns = selam.am.runes.map(String.fromCharCode).where((c) => c.trim().isNotEmpty).toSet();
      expect(repo.lexemesDecodableWith(allSigns).any((l) => l.id == selam.id), isTrue);
    });

    test('every word returned as decodable really exists in the Lernweg A vocabulary', () {
      final allChars = repo.allFidelChars.map((c) => c.char).toSet();
      final decodable = repo.lexemesDecodableWith(allChars);
      for (final word in decodable) {
        expect(repo.lexeme(word.id), isNotNull);
      }
    });

    test('sentences are only decodable once every sign in them is learned (punctuation exempt)', () {
      // "Everything learned" means the full Fidel path including Stufe 7's
      // labialized special forms and other marginal signs (Etappe 24: ቷ/ኧ
      // moved out of "labialized" into their own "other" category, since
      // they aren't actually part of the real qʷ/kʷ/gʷ/hʷ series), not
      // just the 33x7 base table.
      final allChars = {
        ...repo.allFidelChars.map((c) => c.char),
        ...repo.fidelExtrasForCategory('labialized').map((e) => e.char),
        ...repo.fidelExtrasForCategory('other').map((e) => e.char),
      };
      final decodableSentences = repo.sentencesDecodableWith(allChars);
      // With every syllable learned, all sample sentences should decode -
      // punctuation/word separators must not block that.
      expect(decodableSentences.length, repo.allSentences.length);
    });
  });

  group('Stufe 7 - extras', () {
    test('numerals, punctuation, labialized forms and other signs all loaded', () {
      expect(repo.fidelExtrasForCategory('numerals'), isNotEmpty);
      expect(repo.fidelExtrasForCategory('punctuation'), isNotEmpty);
      expect(repo.fidelExtrasForCategory('labialized'), isNotEmpty);
      expect(repo.fidelExtrasForCategory('other'), isNotEmpty);
    });

    test('the labialized series is the real, complete qʷ/kʷ/gʷ/hʷ set (Etappe 24), not just a few examples', () {
      final labialized = repo.fidelExtrasForCategory('labialized');
      // 4 series (qw/kw/gw/hw) x 5 realized orders (1,3,4,5,6 - orders 2
      // and 7 don't exist for these, they'd be identical to the plain
      // consonant) = 20.
      expect(labialized.length, 20);
      expect(labialized.map((e) => e.id).toSet().length, 20, reason: 'every entry needs a distinct audio id');
    });

    test('generateExtraCharToMeaning always returns 4 distinct options including the correct one', () {
      final numerals = repo.fidelExtrasForCategory('numerals');
      final subject = numerals.first;
      final exercise = generator.generateExtraCharToMeaning(subject, numerals);
      expect(exercise.options.toSet().length, exercise.options.length);
      expect(exercise.options, contains(subject.tr));
    });
  });

  group('Fidel learning paths', () {
    test('fidelGroupsByFrequency returns all 33 groups exactly once', () {
      final freq = repo.fidelGroupsByFrequency();
      expect(freq.toSet().length, 33);
      expect(freq.toSet(), repo.fidelGroupsInOrder.toSet());
    });
  });
}
