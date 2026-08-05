import 'package:flutter/foundation.dart';

import '../content/content_repository.dart';
import '../content/exercise_generator.dart';
import '../models/exercise.dart';
import '../models/fidel_char.dart';
import '../models/fidel_lesson.dart';
import '../models/lesson.dart';
import 'progress_provider.dart';

/// One "this sign sounds exactly like a sign you already know" card, shown
/// before its exercises so the learner isn't blindsided (Teil B, Stufe 1).
class HomophoneNote {
  final FidelChar char;
  final List<FidelChar> soundsLike;

  const HomophoneNote({required this.char, required this.soundsLike});
}

class FidelLessonSession {
  final String stageId;
  final String lessonId;
  final FidelLesson lesson;
  final List<HomophoneNote> homophoneNotes;
  final List<GeneratedExercise> exercises;
  final DateTime startedAt;
  final int startingHearts;

  int currentIndex = 0;
  int correctCount = 0;
  int incorrectCount = 0;
  int skippedCount = 0;
  int heartsRemaining;
  bool answered = false;
  bool? lastAnswerCorrect;
  bool lastAnswerSkipped = false;

  FidelLessonSession({
    required this.stageId,
    required this.lessonId,
    required this.lesson,
    required this.homophoneNotes,
    required this.exercises,
    required this.startedAt,
    required this.startingHearts,
  }) : heartsRemaining = startingHearts;

  bool get isShowingNote => currentIndex < homophoneNotes.length;

  HomophoneNote? get currentNote => isShowingNote ? homophoneNotes[currentIndex] : null;

  GeneratedExercise? get currentExercise {
    if (isShowingNote) return null;
    final i = currentIndex - homophoneNotes.length;
    return i >= 0 && i < exercises.length ? exercises[i] : null;
  }

  bool get isFinished => currentIndex >= homophoneNotes.length + exercises.length;

  bool get outOfHearts => heartsRemaining <= 0;

  double get scoreRatio => exercises.isEmpty ? 1.0 : correctCount / exercises.length;

  bool get isPerfect => incorrectCount == 0 && skippedCount == 0;

  Duration get elapsed => DateTime.now().difference(startedAt);
}

/// Drives one Fidel lesson session - the sibling of [LessonProvider] for
/// learning path B. Kept separate because it works on [FidelChar] rows
/// instead of lexemes/sentences.
class FidelLessonProvider extends ChangeNotifier {
  final ContentRepository content;
  final ProgressProvider progress;
  late final FidelExerciseGenerator _generator;

  FidelLessonSession? _session;

  FidelLessonProvider({required this.content, required this.progress}) {
    _generator = FidelExerciseGenerator(content);
  }

  FidelLessonSession? get session => _session;

  void startLesson({required String stageId, required String lessonId, required bool useHearts}) {
    final lesson = content.fidelLessonsForStage(stageId).where((l) => l.id == lessonId).firstOrNull;
    if (lesson == null) {
      _session = null;
      notifyListeners();
      return;
    }

    final notes = <HomophoneNote>[];
    for (final entry in lesson.homophoneOf.entries) {
      final char = content.fidelCharsForGroup(entry.key).where((c) => c.order == 1).firstOrNull;
      if (char == null) continue;
      final soundsLike = [
        for (final g in entry.value)
          ...content.fidelCharsForGroup(g).where((c) => c.order == 1),
      ];
      notes.add(HomophoneNote(char: char, soundsLike: soundsLike));
    }

    final exercises = _buildExercises(lesson);

    _session = FidelLessonSession(
      stageId: stageId,
      lessonId: lessonId,
      lesson: lesson,
      homophoneNotes: notes,
      exercises: exercises,
      startedAt: DateTime.now(),
      startingHearts: useHearts ? 5 : 999999,
    );
    notifyListeners();
  }

  List<GeneratedExercise> _buildExercises(FidelLesson lesson) {
    if (lesson.exerciseTypes.isEmpty) return const [];

    final chars = <FidelChar>[
      for (final g in lesson.groupIds) ...content.fidelCharsForGroup(g).where((c) => c.order == 1),
    ];

    final result = <GeneratedExercise>[];
    var typeAlternator = 0;
    for (final char in chars) {
      final type = lesson.exerciseTypes[typeAlternator % lesson.exerciseTypes.length];
      typeAlternator++;
      switch (type) {
        case ExerciseType.fidelCharToSound:
          result.add(_generator.generateCharToSound(char));
          break;
        case ExerciseType.fidelSoundToChar:
          result.add(_generator.generateSoundToChar(char));
          break;
        case ExerciseType.fidelOrderRecognition:
          result.add(_generator.generateOrderRecognition(char.group, char.order));
          break;
        default:
          break;
      }
    }

    final capped = result.length > 20 ? result.sublist(0, 20) : result;
    return ExerciseSequencer(random: _generator.random).order(capped);
  }

  /// Ad-hoc drill for one row, launched from the Fidel table's "Diese Reihe
  /// üben" button - not tied to any stage/lesson content file.
  void startRowPractice(String group, {required bool useHearts}) {
    final chars = content.fidelCharsForGroup(group);
    final exercises = <GeneratedExercise>[];
    for (final c in chars) {
      exercises.add(_generator.generateOrderRecognition(group, c.order));
      exercises.add(_generator.generateSoundToChar(c));
    }
    final ordered = ExerciseSequencer(random: _generator.random).order(exercises);

    _session = FidelLessonSession(
      stageId: 'practice',
      lessonId: 'practice_$group',
      lesson: FidelLesson(id: 'practice_$group', stageId: 'practice', kind: FidelLessonKind.rowLesson, groupIds: [group]),
      homophoneNotes: const [],
      exercises: ordered,
      startedAt: DateTime.now(),
      startingHearts: useHearts ? 5 : 999999,
    );
    notifyListeners();
  }

  void advancePastNote() {
    final s = _session;
    if (s == null || !s.isShowingNote) return;
    s.currentIndex++;
    notifyListeners();
  }

  void submitAnswer(String givenAnswer) {
    final s = _session;
    final exercise = s?.currentExercise;
    if (s == null || exercise == null || s.answered) return;

    final correct = givenAnswer.trim() == exercise.correctAnswer.trim();
    s.answered = true;
    s.lastAnswerCorrect = correct;
    s.lastAnswerSkipped = false;

    if (correct) {
      s.correctCount++;
    } else {
      s.incorrectCount++;
      if (s.heartsRemaining < 999999) s.heartsRemaining--;
    }

    final charId = exercise.subjectId.replaceFirst('fidel:', '');
    progress.recordFidelAnswer(charId, correct: correct);

    notifyListeners();
  }

  void skipCurrentExercise() {
    final s = _session;
    final exercise = s?.currentExercise;
    if (s == null || exercise == null || s.answered) return;

    s.answered = true;
    s.lastAnswerCorrect = false;
    s.lastAnswerSkipped = true;
    s.incorrectCount++;
    s.skippedCount++;

    final charId = exercise.subjectId.replaceFirst('fidel:', '');
    progress.recordFidelAnswer(charId, correct: false);

    notifyListeners();
  }

  void nextExercise() {
    final s = _session;
    if (s == null) return;
    s.currentIndex++;
    s.answered = false;
    s.lastAnswerCorrect = null;
    s.lastAnswerSkipped = false;
    notifyListeners();
  }

  void endSession() {
    _session = null;
    notifyListeners();
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
