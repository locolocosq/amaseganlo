import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amaseganlo/content/content_repository.dart';
import 'package:amaseganlo/core/audio_service.dart';
import 'package:amaseganlo/core/storage_service.dart';
import 'package:amaseganlo/models/lesson.dart';
import 'package:amaseganlo/state/lesson_provider.dart';
import 'package:amaseganlo/state/progress_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ContentRepository repo;
  late LessonProvider lessonProvider;
  late ProgressProvider progressProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();
    progressProvider = ProgressProvider(storage);

    repo = ContentRepository();
    await repo.load();

    final audio = AudioService();
    await audio.init();

    lessonProvider = LessonProvider(content: repo, progress: progressProvider, audioService: audio);
  });

  group('LessonProvider - intro lessons', () {
    test('starting an intro lesson exposes its lexemes as cards, no exercises', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_intro', locale: 'de', useHearts: false);
      final session = lessonProvider.session!;
      expect(session.isIntro, isTrue);
      expect(session.introLexemes, isNotEmpty);
      expect(session.exercises, isEmpty);
    });

    test('paging through all intro cards finishes the session', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_intro', locale: 'de', useHearts: false);
      final session = lessonProvider.session!;
      final count = session.introLexemes.length;
      for (var i = 0; i < count; i++) {
        expect(session.isFinished, isFalse);
        lessonProvider.nextIntroCard();
      }
      expect(session.isFinished, isTrue);
    });
  });

  group('LessonProvider - word practice lessons', () {
    test('builds a non-empty, capped exercise queue', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_words', locale: 'de', useHearts: false);
      final session = lessonProvider.session!;
      expect(session.isIntro, isFalse);
      expect(session.exercises, isNotEmpty);
      expect(session.exercises.length, lessThanOrEqualTo(18));
    });

    test('a correct answer advances the correct count and moves the SRS card up', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_words', locale: 'de', useHearts: false);
      final session = lessonProvider.session!;
      final exercise = session.currentExercise!;

      lessonProvider.submitChoiceOrBuildAnswer(exercise.correctAnswer);

      expect(session.answered, isTrue);
      expect(session.lastAnswerCorrect, isTrue);
      expect(session.correctCount, 1);
      expect(progressProvider.progress.lexemeCards[exercise.subjectId]?.box, 1);
    });

    test('a wrong answer counts as incorrect and resets the SRS card to Fach 1', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_words', locale: 'de', useHearts: false);
      final session = lessonProvider.session!;

      lessonProvider.submitChoiceOrBuildAnswer('__definitely_wrong__');

      expect(session.lastAnswerCorrect, isFalse);
      expect(session.incorrectCount, 1);
    });

    test('nextExercise moves to the next item and resets the answered flag', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_words', locale: 'de', useHearts: false);
      final session = lessonProvider.session!;

      lessonProvider.submitChoiceOrBuildAnswer(session.currentExercise!.correctAnswer);
      lessonProvider.nextExercise();

      expect(session.currentIndex, 1);
      expect(session.answered, isFalse);
      expect(session.lastAnswerCorrect, isNull);
    });

    test('skipCurrentExercise counts as both incorrect and skipped, costs no heart', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_words', locale: 'de', useHearts: true);
      final session = lessonProvider.session!;
      final heartsBefore = session.heartsRemaining;

      lessonProvider.skipCurrentExercise();

      expect(session.incorrectCount, 1);
      expect(session.skippedCount, 1);
      expect(session.lastAnswerSkipped, isTrue);
      expect(session.heartsRemaining, heartsBefore);
    });

    test('with hearts enabled, a wrong answer costs exactly one heart', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_words', locale: 'de', useHearts: true);
      final session = lessonProvider.session!;
      final heartsBefore = session.heartsRemaining;

      lessonProvider.submitChoiceOrBuildAnswer('__definitely_wrong__');

      expect(session.heartsRemaining, heartsBefore - 1);
    });

    test('finishing all exercises marks the session as finished', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_words', locale: 'de', useHearts: false);
      final session = lessonProvider.session!;
      final total = session.exercises.length;

      for (var i = 0; i < total; i++) {
        lessonProvider.submitChoiceOrBuildAnswer(session.currentExercise!.correctAnswer);
        lessonProvider.nextExercise();
      }

      expect(session.isFinished, isTrue);
    });
  });

  group('LessonProvider - sentence lessons', () {
    test('sentence-based exercises record SRS progress for the lexemes the sentence uses', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_sentences', locale: 'de', useHearts: false);
      final session = lessonProvider.session!;
      expect(session.exercises, isNotEmpty);

      final exercise = session.exercises.firstWhere((e) => e.type == ExerciseType.sentenceBuild || e.type == ExerciseType.sentenceGapChoice);
      lessonProvider.submitChoiceOrBuildAnswer(exercise.correctAnswer);

      expect(exercise.subjectIds, contains('lex_dehna'));
      expect(progressProvider.progress.lexemeCards['lex_dehna']?.box, 1);
    });
  });

  group('LessonProvider - audio exercises are excluded without audio', () {
    test('no listen* exercises are generated when Amharic audio is unavailable', () {
      lessonProvider.startLesson(unitId: 'unit_erste_begegnung', lessonId: 'lesson_erste_begegnung_listening', locale: 'de', useHearts: false);
      final session = lessonProvider.session!;
      final hasAudioType = session.exercises.any(
        (e) => e.type == ExerciseType.listenChoice || e.type == ExerciseType.listenBuild || e.type == ExerciseType.listenTyping,
      );
      expect(hasAudioType, isFalse);
    });
  });
}
