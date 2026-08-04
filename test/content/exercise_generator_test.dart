import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/content/content_repository.dart';
import 'package:amaseganlo/content/exercise_generator.dart';
import 'package:amaseganlo/models/exercise.dart';
import 'package:amaseganlo/models/lesson.dart';
import 'package:amaseganlo/models/lexeme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ContentRepository repo;

  setUpAll(() async {
    repo = ContentRepository();
    await repo.load();
  });

  group('ExerciseGenerator.generateWordChoice', () {
    test('always produces exactly 4 options with no duplicates', () {
      final generator = ExerciseGenerator(repo);
      final subject = repo.lexeme('lex_selam')!;

      for (var i = 0; i < 20; i++) {
        final exercise = generator.generateWordChoice(subject: subject, amToNative: true, locale: 'de');
        expect(exercise.options.length, 4);
        expect(exercise.options.toSet().length, 4, reason: 'options must not contain duplicates');
      }
    });

    test('the correct answer is present exactly once among the options', () {
      final generator = ExerciseGenerator(repo);
      final subject = repo.lexeme('lex_selam')!;
      final exercise = generator.generateWordChoice(subject: subject, amToNative: true, locale: 'de');

      final occurrences = exercise.options.where((o) => o == exercise.correctAnswer).length;
      expect(occurrences, 1);
    });

    test('am-to-native shows the transliteration and asks for the translation', () {
      final generator = ExerciseGenerator(repo);
      final subject = repo.lexeme('lex_selam')!;
      final exercise = generator.generateWordChoice(subject: subject, amToNative: true, locale: 'de');

      expect(exercise.promptText, subject.tr);
      expect(exercise.correctAnswer, subject.t['de']);
      expect(exercise.type, ExerciseType.wordChoiceAmToNative);
    });

    test('native-to-am shows the translation and asks for the transliteration', () {
      final generator = ExerciseGenerator(repo);
      final subject = repo.lexeme('lex_selam')!;
      final exercise = generator.generateWordChoice(subject: subject, amToNative: false, locale: 'de');

      expect(exercise.promptText, subject.t['de']);
      expect(exercise.correctAnswer, subject.tr);
      expect(exercise.type, ExerciseType.wordChoiceNativeToAm);
    });

    test('distractors prefer the same topic and level as the subject', () {
      final generator = ExerciseGenerator(repo);
      final subject = repo.lexeme('lex_selam')!;
      final exercise = generator.generateWordChoice(subject: subject, amToNative: true, locale: 'de');

      final distractorLexemes = repo.allLexemes.where(
        (l) => exercise.options.contains(l.t['de']) && l.id != subject.id,
      );
      // The greetings sample pool has 8 same-topic same-level words, more
      // than enough to fill 3 distractor slots without falling back.
      for (final l in distractorLexemes) {
        expect(l.topic, subject.topic);
        expect(l.level, subject.level);
      }
    });
  });

  group('ExerciseGenerator.generateWordTyping', () {
    test('has no options - it is checked with AnswerChecker instead', () {
      final generator = ExerciseGenerator(repo);
      final subject = repo.lexeme('lex_selam')!;
      final exercise = generator.generateWordTyping(subject: subject, amToNative: true, locale: 'de');
      expect(exercise.options, isEmpty);
      expect(exercise.isTypingBased, isTrue);
    });
  });

  group('ExerciseSequencer', () {
    test('never places the same (type, subject) exercise twice in a row', () {
      const subjectA = Lexeme(id: 'a', am: 'a', tr: 'a', pos: '', topic: 't', level: 'A1.1', t: {'de': 'a'});
      const subjectB = Lexeme(id: 'b', am: 'b', tr: 'b', pos: '', topic: 't', level: 'A1.1', t: {'de': 'b'});

      final exercises = [
        for (var i = 0; i < 6; i++)
          GeneratedExercise(
            type: ExerciseType.wordChoiceAmToNative,
            subjectId: i.isEven ? subjectA.id : subjectB.id,
            promptText: 'p$i',
            correctAnswer: 'c$i',
          ),
      ];

      final sequencer = ExerciseSequencer();
      final ordered = sequencer.order(exercises);

      expect(ordered.length, exercises.length);
      for (var i = 1; i < ordered.length; i++) {
        final sameAsBefore = ordered[i].type == ordered[i - 1].type && ordered[i].subjectId == ordered[i - 1].subjectId;
        expect(sameAsBefore, isFalse);
      }
    });
  });
}
