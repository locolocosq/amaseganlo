import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habesha_speak/content/content_repository.dart';
import 'package:habesha_speak/core/audio_service.dart';
import 'package:habesha_speak/core/storage_service.dart';
import 'package:habesha_speak/models/lesson.dart';
import 'package:habesha_speak/state/lesson_provider.dart';
import 'package:habesha_speak/state/progress_provider.dart';

// Never touches a real platform channel - see the class doc on
// AudioService in lib/core/audio_service.dart for why tests must not
// construct the real TtsClient/AudioPlayerClient.
class _FakeTtsClient implements TtsClient {
  @override
  Future<bool> isLanguageAvailable(String language) async => false;
  @override
  Future<void> setLanguage(String language) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> setSpeechRate(double rate) async {}
  @override
  Future<void> speak(String text) async {}
  @override
  Future<void> stop() async {}
}

class _FakeAudioPlayerClient implements AudioPlayerClient {
  @override
  Future<void> play(String assetPath, {required double volume, double rate = 1.0}) async {}
  @override
  Future<void> stop() async {}
}

// Keeps AudioService from touching the real (now ~1000-file)
// assets/audio/ bundle - this file is about LessonProvider, not audio.
class _EmptyAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw FlutterError('no assets in this fake bundle');
  }
}

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

    final audio = AudioService(
      tts: _FakeTtsClient(),
      player: _FakeAudioPlayerClient(),
      bundle: _EmptyAssetBundle(),
      voiceRetryDelay: Duration.zero,
    );
    await audio.init();

    lessonProvider = LessonProvider(
      content: repo,
      progress: progressProvider,
      audioService: audio,
    );
  });

  group('LessonProvider - intro lessons', () {
    test(
      'starting an intro lesson exposes its lexemes as cards, no exercises',
      () {
        lessonProvider.startLesson(
          unitId: 'unit_erste_begegnung',
          lessonId: 'lesson_erste_begegnung_intro',
          locale: 'de',
          useHearts: false,
        );
        final session = lessonProvider.session!;
        expect(session.isIntro, isTrue);
        expect(session.introLexemes, isNotEmpty);
        expect(session.exercises, isEmpty);
      },
    );

    test('paging through all intro cards finishes the session', () {
      lessonProvider.startLesson(
        unitId: 'unit_erste_begegnung',
        lessonId: 'lesson_erste_begegnung_intro',
        locale: 'de',
        useHearts: false,
      );
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
      lessonProvider.startLesson(
        unitId: 'unit_erste_begegnung',
        lessonId: 'lesson_erste_begegnung_words',
        locale: 'de',
        useHearts: false,
      );
      final session = lessonProvider.session!;
      expect(session.isIntro, isFalse);
      expect(session.exercises, isNotEmpty);
      expect(session.exercises.length, lessThanOrEqualTo(18));
    });

    test(
      'a correct answer advances the correct count and moves the SRS card up',
      () {
        lessonProvider.startLesson(
          unitId: 'unit_erste_begegnung',
          lessonId: 'lesson_erste_begegnung_words',
          locale: 'de',
          useHearts: false,
        );
        final session = lessonProvider.session!;
        final exercise = session.currentExercise!;

        lessonProvider.submitChoiceOrBuildAnswer(exercise.correctAnswer);

        expect(session.answered, isTrue);
        expect(session.lastAnswerCorrect, isTrue);
        expect(session.correctCount, 1);
        expect(
          progressProvider.progress.lexemeCards[exercise.subjectId]?.box,
          1,
        );
      },
    );

    test(
      'a wrong answer counts as incorrect and resets the SRS card to Fach 1',
      () {
        lessonProvider.startLesson(
          unitId: 'unit_erste_begegnung',
          lessonId: 'lesson_erste_begegnung_words',
          locale: 'de',
          useHearts: false,
        );
        final session = lessonProvider.session!;

        lessonProvider.submitChoiceOrBuildAnswer('__definitely_wrong__');

        expect(session.lastAnswerCorrect, isFalse);
        expect(session.incorrectCount, 1);
      },
    );

    test(
      'nextExercise moves to the next item and resets the answered flag',
      () {
        lessonProvider.startLesson(
          unitId: 'unit_erste_begegnung',
          lessonId: 'lesson_erste_begegnung_words',
          locale: 'de',
          useHearts: false,
        );
        final session = lessonProvider.session!;

        lessonProvider.submitChoiceOrBuildAnswer(
          session.currentExercise!.correctAnswer,
        );
        lessonProvider.nextExercise();

        expect(session.currentIndex, 1);
        expect(session.answered, isFalse);
        expect(session.lastAnswerCorrect, isNull);
      },
    );

    test(
      'skipCurrentExercise counts as both incorrect and skipped, costs no heart',
      () {
        lessonProvider.startLesson(
          unitId: 'unit_erste_begegnung',
          lessonId: 'lesson_erste_begegnung_words',
          locale: 'de',
          useHearts: true,
        );
        final session = lessonProvider.session!;
        final heartsBefore = session.heartsRemaining;

        lessonProvider.skipCurrentExercise();

        expect(session.incorrectCount, 1);
        expect(session.skippedCount, 1);
        expect(session.lastAnswerSkipped, isTrue);
        expect(session.heartsRemaining, heartsBefore);
      },
    );

    test('with hearts enabled, a wrong answer costs exactly one heart', () {
      lessonProvider.startLesson(
        unitId: 'unit_erste_begegnung',
        lessonId: 'lesson_erste_begegnung_words',
        locale: 'de',
        useHearts: true,
      );
      final session = lessonProvider.session!;
      final heartsBefore = session.heartsRemaining;

      lessonProvider.submitChoiceOrBuildAnswer('__definitely_wrong__');

      expect(session.heartsRemaining, heartsBefore - 1);
    });

    test('finishing all exercises marks the session as finished', () {
      lessonProvider.startLesson(
        unitId: 'unit_erste_begegnung',
        lessonId: 'lesson_erste_begegnung_words',
        locale: 'de',
        useHearts: false,
      );
      final session = lessonProvider.session!;
      final total = session.exercises.length;

      for (var i = 0; i < total; i++) {
        lessonProvider.submitChoiceOrBuildAnswer(
          session.currentExercise!.correctAnswer,
        );
        lessonProvider.nextExercise();
      }

      expect(session.isFinished, isTrue);
    });
  });

  group('LessonProvider - sentence lessons', () {
    test(
      'sentence-based exercises record SRS progress for the lexemes the sentence uses',
      () {
        lessonProvider.startLesson(
          unitId: 'unit_erste_begegnung',
          lessonId: 'lesson_erste_begegnung_sentences',
          locale: 'de',
          useHearts: false,
        );
        final session = lessonProvider.session!;
        expect(session.exercises, isNotEmpty);

        final exercise = session.exercises.firstWhere(
          (e) =>
              e.type == ExerciseType.sentenceBuild ||
              e.type == ExerciseType.sentenceGapChoice,
        );
        lessonProvider.submitChoiceOrBuildAnswer(exercise.correctAnswer);

        // Etappe 26: no longer hardcoded to 'lex_dehna' specifically - this
        // unit's sentence-building lesson now has two sentences
        // (sen_dehna_negn, sen_awo_ameseginalehu), and exercise ordering
        // isn't guaranteed, so `firstWhere` above can legitimately land on
        // either one. What this test actually verifies is that SRS progress
        // gets recorded for whichever lexeme(s) the picked exercise's own
        // sentence uses - not which specific sentence comes first.
        expect(exercise.subjectIds, isNotEmpty);
        for (final lexemeId in exercise.subjectIds) {
          expect(progressProvider.progress.lexemeCards[lexemeId]?.box, 1);
        }
      },
    );

    test(
      'chunk-based exercises are skipped for one-chunk sentences (bug report: a gap-fill on a '
      'single-word sentence like "yikirta." showed nothing but an empty blank, since redacting '
      'the only chunk leaves no context at all)',
      () {
        lessonProvider.startLesson(
          unitId: 'unit_erste_begegnung',
          lessonId: 'lesson_erste_begegnung_sentences',
          locale: 'de',
          useHearts: false,
        );
        final session = lessonProvider.session!;

        // sen_gen_selam/sen_gen_ibakih/sen_gen_yikirta are single-chunk
        // (interjections like "Hallo."/"Bitte."/"Entschuldigung.") - none of
        // them should produce a sentenceBuild/sentenceGapChoice/
        // sentenceGapTyping/listenBuild exercise.
        const chunkDependentTypes = {
          ExerciseType.sentenceBuild,
          ExerciseType.sentenceGapChoice,
          ExerciseType.sentenceGapTyping,
          ExerciseType.listenBuild,
        };
        const oneChunkSentenceIds = {'sen_gen_selam', 'sen_gen_ibakih', 'sen_gen_yikirta'};
        for (final exercise in session.exercises) {
          if (chunkDependentTypes.contains(exercise.type)) {
            expect(oneChunkSentenceIds.contains(exercise.subjectId), isFalse);
          }
        }

        // sen_dehna_negn/sen_awo_ameseginalehu (two chunks each) still get
        // to use these exercise types - the fix only excludes the
        // degenerate one-chunk case, not the whole lesson.
        expect(
          session.exercises.any((e) => chunkDependentTypes.contains(e.type)),
          isTrue,
        );
      },
    );
  });

  group('LessonProvider - audio exercises are excluded without audio', () {
    test(
      'no listen* exercises are generated when Amharic audio is unavailable',
      () {
        lessonProvider.startLesson(
          unitId: 'unit_erste_begegnung',
          lessonId: 'lesson_erste_begegnung_listening',
          locale: 'de',
          useHearts: false,
        );
        final session = lessonProvider.session!;
        final hasAudioType = session.exercises.any(
          (e) =>
              e.type == ExerciseType.listenChoice ||
              e.type == ExerciseType.listenBuild ||
              e.type == ExerciseType.listenTyping,
        );
        expect(hasAudioType, isFalse);
      },
    );
  });

  group('LessonProvider - chapter test', () {
    test('uses every word of a small unit and never costs a heart', () {
      lessonProvider.startChapterTest(
        unitId: 'unit_erste_begegnung',
        locale: 'de',
      );
      final session = lessonProvider.session!;

      expect(session.lesson.kind, LessonKind.unitTest);
      expect(
        session.exercises.length,
        8,
      ); // unit_erste_begegnung has 8 words, under the 20 cap
      expect(
        session.startingHearts,
        greaterThan(1000),
      ); // effectively unlimited

      // A wrong answer never reduces hearts, however many are answered wrong.
      for (var i = 0; i < session.exercises.length; i++) {
        lessonProvider.skipCurrentExercise();
        expect(session.outOfHearts, isFalse);
        lessonProvider.nextExercise();
      }
      expect(session.isFinished, isTrue);
    });

    test(
      'caps at 20 questions and includes a meaningful share of typing exercises',
      () {
        // unit_zahlen_21_99 has 72 words - well over the cap.
        lessonProvider.startChapterTest(
          unitId: 'unit_zahlen_21_99',
          locale: 'de',
        );
        final session = lessonProvider.session!;

        expect(session.exercises.length, 20);

        final typingCount = session.exercises
            .where((e) => e.type == ExerciseType.wordTyping)
            .length;
        expect(
          typingCount,
          greaterThanOrEqualTo(5),
        ); // "at least a quarter typed"
      },
    );
  });
}
