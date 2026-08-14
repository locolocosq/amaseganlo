import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habesha_speak/content/content_repository.dart';
import 'package:habesha_speak/core/audio_service.dart';
import 'package:habesha_speak/core/storage_service.dart';
import 'package:habesha_speak/models/lesson.dart';
import 'package:habesha_speak/state/fidel_lesson_provider.dart';
import 'package:habesha_speak/state/progress_provider.dart';

import '../widgets/test_harness.dart' show FakeTtsClient, FakeAudioPlayerClient;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ContentRepository repo;
  late FidelLessonProvider provider;
  late ProgressProvider progress;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();
    progress = ProgressProvider(storage);

    repo = ContentRepository();
    await repo.load();

    provider = FidelLessonProvider(
      content: repo,
      progress: progress,
      audioService: AudioService(tts: FakeTtsClient(), player: FakeAudioPlayerClient()),
    );
  });

  group('FidelLessonProvider - charIntro lessons', () {
    test('the first lesson (ha/la/hha) surfaces exactly one homophone note (hha sounds like ha)', () {
      provider.startLesson(stageId: 'stufe1', lessonId: 'f1_l1', useHearts: false);
      final session = provider.session!;
      expect(session.homophoneNotes.length, 1);
      expect(session.homophoneNotes.first.char.group, 'hha');
      expect(session.homophoneNotes.first.soundsLike.map((c) => c.group), contains('ha'));
    });

    test('a lesson with no homophones has no notes', () {
      provider.startLesson(stageId: 'stufe1', lessonId: 'f1_l2', useHearts: false);
      expect(provider.session!.homophoneNotes, isEmpty);
    });

    test('advancePastNote moves past all notes before exercises begin', () {
      provider.startLesson(stageId: 'stufe1', lessonId: 'f1_l1', useHearts: false);
      final session = provider.session!;
      expect(session.isShowingNote, isTrue);
      provider.advancePastNote();
      expect(session.isShowingNote, isFalse);
      expect(session.currentExercise, isNotNull);
    });

    test('builds exercises for the 3 introduced characters', () {
      provider.startLesson(stageId: 'stufe1', lessonId: 'f1_l2', useHearts: false);
      final session = provider.session!;
      expect(session.exercises, isNotEmpty);
      expect(session.exercises.length, lessThanOrEqualTo(20));
    });
  });

  group('FidelLessonProvider - answering', () {
    test('a correct answer records progress on the Fidel Leitner card', () {
      provider.startLesson(stageId: 'stufe1', lessonId: 'f1_l2', useHearts: false);
      final session = provider.session!;
      final exercise = session.currentExercise!;

      provider.submitChoiceOrBuildAnswer(exercise.correctAnswer);

      expect(session.answered, isTrue);
      expect(session.lastAnswerCorrect, isTrue);
      final charId = exercise.subjectId.replaceFirst('fidel:', '');
      expect(progress.progress.fidelCards[charId]?.box, 1);
    });

    test('skipCurrentExercise counts as incorrect and skipped, costs no heart', () {
      provider.startLesson(stageId: 'stufe1', lessonId: 'f1_l2', useHearts: true);
      final session = provider.session!;
      final heartsBefore = session.heartsRemaining;

      provider.skipCurrentExercise();

      expect(session.incorrectCount, 1);
      expect(session.skippedCount, 1);
      expect(session.heartsRemaining, heartsBefore);
    });

    test('nextExercise advances and resets the answered state', () {
      provider.startLesson(stageId: 'stufe1', lessonId: 'f1_l2', useHearts: false);
      final session = provider.session!;
      provider.submitChoiceOrBuildAnswer(session.currentExercise!.correctAnswer);
      final indexBefore = session.currentIndex;
      provider.nextExercise();
      expect(session.currentIndex, indexBefore + 1);
      expect(session.answered, isFalse);
    });
  });

  group('FidelLessonProvider - review and stage test', () {
    test('a review lesson covers all characters from its constituent intro lessons', () {
      provider.startLesson(stageId: 'stufe1', lessonId: 'f1_r1', useHearts: false);
      final session = provider.session!;
      expect(session.lesson.groupIds.length, 9);
    });

    test('the stage test lesson covers all 33 groups', () {
      provider.startLesson(stageId: 'stufe1', lessonId: 'f1_test', useHearts: false);
      final session = provider.session!;
      expect(session.lesson.groupIds.length, 33);
    });
  });

  group('FidelLessonProvider - ad-hoc row practice', () {
    test('startRowPractice builds exercises only for the requested row', () {
      provider.startRowPractice('la', useHearts: false);
      final session = provider.session!;
      expect(session.exercises, isNotEmpty);
      for (final e in session.exercises) {
        final charId = e.subjectId.replaceFirst('fidel:', '');
        final char = repo.allFidelChars.firstWhere((c) => c.char == charId);
        expect(char.group, 'la');
      }
    });
  });

  group('FidelLessonProvider - startAudioDrill (Etappe 24 audio drill)', () {
    test('scoped to a group: builds fidelListenChoice exercises only for that row', () {
      provider.startAudioDrill(group: 'la', useHearts: false);
      final session = provider.session!;
      expect(session.exercises, isNotEmpty);
      expect(session.hahuDrillGroup, isNull, reason: 'the audio drill has no flashcard preamble, unlike row practice');
      for (final e in session.exercises) {
        expect(e.type, ExerciseType.fidelListenChoice);
        expect(e.isAudioPrompt, isTrue);
        final charId = e.subjectId.replaceFirst('fidel:', '');
        final char = repo.allFidelChars.firstWhere((c) => c.char == charId);
        expect(char.group, 'la');
      }
    });

    test('without a group: covers only signs already learned', () {
      provider.startLesson(stageId: 'stufe1', lessonId: 'f1_l2', useHearts: false);
      provider.advancePastNote();
      provider.submitChoiceOrBuildAnswer(provider.session!.currentExercise!.correctAnswer);
      final learnedChar = provider.session!.currentExercise!.subjectId.replaceFirst('fidel:', '');
      provider.endSession();

      provider.startAudioDrill(useHearts: false);
      final session = provider.session!;
      expect(session.exercises, isNotEmpty);
      for (final e in session.exercises) {
        expect(e.subjectId, 'fidel:$learnedChar');
      }
    });

    test('without a group and nothing learned yet: falls back to the first row instead of an empty session', () {
      provider.startAudioDrill(useHearts: false);
      final session = provider.session!;
      expect(session.exercises, isNotEmpty);
    });
  });

  group('FidelLessonProvider - playCurrentAudio (Etappe 24)', () {
    // A regression test for the same class of bug as
    // lesson_intro_autoplay_test.dart: generating 1292 audio recordings is
    // worthless if nothing ever actually calls AudioService for them. This
    // checks the provider-level wiring speaks the right text for each
    // subjectId shape the Fidel exercise generator produces.
    test('speaks the Fidel sign for a fidel: exercise', () async {
      final tts = _SpyTtsClient();
      final audio = AudioService(
        tts: tts,
        player: FakeAudioPlayerClient(),
        bundle: _EmptyAssetBundle(),
        voiceRetryDelay: Duration.zero,
      );
      await audio.init();
      final spiedProvider = FidelLessonProvider(content: repo, progress: progress, audioService: audio);

      spiedProvider.startLesson(stageId: 'stufe1', lessonId: 'f1_l2', useHearts: false);
      final expectedChar = spiedProvider.session!.currentExercise!.subjectId.replaceFirst('fidel:', '');

      await spiedProvider.playCurrentAudio();

      expect(tts.spoke, isTrue);
      expect(tts.lastSpoken, expectedChar);
    });

    test('speaks the row for an ad-hoc row-practice exercise', () async {
      final tts = _SpyTtsClient();
      final audio = AudioService(
        tts: tts,
        player: FakeAudioPlayerClient(),
        bundle: _EmptyAssetBundle(),
        voiceRetryDelay: Duration.zero,
      );
      await audio.init();
      final spiedProvider = FidelLessonProvider(content: repo, progress: progress, audioService: audio);

      spiedProvider.startRowPractice('la', useHearts: false);
      spiedProvider.advancePastDrill();
      final expectedChar = spiedProvider.session!.currentExercise!.subjectId.replaceFirst('fidel:', '');

      await spiedProvider.playCurrentAudio();

      expect(tts.spoke, isTrue);
      expect(tts.lastSpoken, expectedChar);
    });
  });
}

/// Forces AudioService's manifest lookup to fail so [_SpyTtsClient] is
/// guaranteed to be the one that ends up speaking - without this, a real
/// bundled recording for the exercised char (most now have one, Etappe 24)
/// would make the test pass or fail depending on which chars happen to
/// have audio yet, rather than on the wiring actually being exercised.
class _EmptyAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw FlutterError('no assets in this fake bundle');
  }
}

class _SpyTtsClient implements TtsClient {
  bool spoke = false;
  String? lastSpoken;

  @override
  Future<bool> isLanguageAvailable(String language) async => true;
  @override
  Future<void> setLanguage(String language) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> setSpeechRate(double rate) async {}
  @override
  Future<void> speak(String text) async {
    spoke = true;
    lastSpoken = text;
  }

  @override
  Future<void> stop() async {}
}
