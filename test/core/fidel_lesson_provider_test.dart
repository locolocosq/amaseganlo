import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amaseganlo/content/content_repository.dart';
import 'package:amaseganlo/core/storage_service.dart';
import 'package:amaseganlo/state/fidel_lesson_provider.dart';
import 'package:amaseganlo/state/progress_provider.dart';

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

    provider = FidelLessonProvider(content: repo, progress: progress);
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

      provider.submitAnswer(exercise.correctAnswer);

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
      provider.submitAnswer(session.currentExercise!.correctAnswer);
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
}
