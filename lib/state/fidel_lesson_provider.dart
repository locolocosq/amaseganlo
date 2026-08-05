import 'package:flutter/foundation.dart';

import '../content/content_repository.dart';
import '../content/exercise_generator.dart';
import '../core/answer_checker.dart';
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
  final String? hahuDrillGroup;
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
  bool lastAnswerAlmost = false;
  bool lastAnswerSkipped = false;

  FidelLessonSession({
    required this.stageId,
    required this.lessonId,
    required this.lesson,
    required this.homophoneNotes,
    required this.hahuDrillGroup,
    required this.exercises,
    required this.startedAt,
    required this.startingHearts,
  }) : heartsRemaining = startingHearts;

  int get _drillCount => hahuDrillGroup != null ? 1 : 0;

  bool get isShowingNote => currentIndex < homophoneNotes.length;

  bool get isShowingDrill => !isShowingNote && currentIndex < homophoneNotes.length + _drillCount;

  HomophoneNote? get currentNote => isShowingNote ? homophoneNotes[currentIndex] : null;

  GeneratedExercise? get currentExercise {
    if (isShowingNote || isShowingDrill) return null;
    final i = currentIndex - homophoneNotes.length - _drillCount;
    return i >= 0 && i < exercises.length ? exercises[i] : null;
  }

  bool get isFinished => currentIndex >= homophoneNotes.length + _drillCount + exercises.length;

  bool get outOfHearts => heartsRemaining <= 0;

  double get scoreRatio => exercises.isEmpty ? 1.0 : correctCount / exercises.length;

  bool get isPerfect => incorrectCount == 0 && skippedCount == 0;

  Duration get elapsed => DateTime.now().difference(startedAt);
}

/// Drives one Fidel lesson session - the sibling of [LessonProvider] for
/// learning path B. Kept separate because it works on [FidelChar] rows and
/// Fidel-specific lesson kinds instead of lexemes/sentences.
class FidelLessonProvider extends ChangeNotifier {
  final ContentRepository content;
  final ProgressProvider progress;
  late final FidelExerciseGenerator _generator;

  FidelLessonSession? _session;

  FidelLessonProvider({required this.content, required this.progress}) {
    _generator = FidelExerciseGenerator(content);
  }

  FidelLessonSession? get session => _session;

  /// Which rows count as "learned" for Stufe 4-6's dynamic content: any
  /// character the learner has answered at least once.
  Set<String> get _learnedChars => progress.progress.fidelCards.keys.toSet();

  void startLesson({required String stageId, required String lessonId, required bool useHearts, String locale = 'en'}) {
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
        for (final g in entry.value) ...content.fidelCharsForGroup(g).where((c) => c.order == 1),
      ];
      notes.add(HomophoneNote(char: char, soundsLike: soundsLike));
    }

    final hahuGroup = lesson.kind == FidelLessonKind.rowLesson && lesson.groupIds.isNotEmpty ? lesson.groupIds.first : null;
    final exercises = _buildExercises(lesson, locale);

    _session = FidelLessonSession(
      stageId: stageId,
      lessonId: lessonId,
      lesson: lesson,
      homophoneNotes: notes,
      hahuDrillGroup: hahuGroup,
      exercises: exercises,
      startedAt: DateTime.now(),
      startingHearts: useHearts ? 5 : 999999,
    );
    notifyListeners();
  }

  List<GeneratedExercise> _buildExercises(FidelLesson lesson, String locale) {
    if (lesson.exerciseTypes.isEmpty) return const [];

    switch (lesson.kind) {
      case FidelLessonKind.charIntro:
      case FidelLessonKind.review:
      case FidelLessonKind.stageTest:
      case FidelLessonKind.rowLesson:
      case FidelLessonKind.blockTest:
        return _buildCharExercises(lesson);
      case FidelLessonKind.syllableJoin:
        return _buildSyllableExercises(lesson);
      case FidelLessonKind.wordRead:
        return _buildWordReadExercises(locale);
      case FidelLessonKind.sentenceRead:
        return _buildSentenceReadExercises(locale);
      case FidelLessonKind.numeralsPunctuation:
        return _buildExtraExercises(lesson);
      case FidelLessonKind.vowelExplainer:
      case FidelLessonKind.writingPractice:
        return const [];
    }
  }

  List<GeneratedExercise> _buildCharExercises(FidelLesson lesson) {
    final chars = <FidelChar>[
      for (final g in lesson.groupIds) ...content.fidelCharsForGroup(g).where((c) => c.order == 1),
    ];
    // Row/block lessons work across all 7 orders, not just order 1.
    final fullChars = lesson.kind == FidelLessonKind.rowLesson || lesson.kind == FidelLessonKind.blockTest
        ? [for (final g in lesson.groupIds) ...content.fidelCharsForGroup(g)]
        : chars;

    final result = <GeneratedExercise>[];
    var typeAlternator = 0;
    for (final char in fullChars) {
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

    return _sequence(result);
  }

  List<GeneratedExercise> _buildSyllableExercises(FidelLesson lesson) {
    final pool = <FidelChar>[
      for (final g in lesson.groupIds) ...content.fidelCharsForGroup(g).where((c) => c.order == 1),
    ];
    if (pool.length < 2) return const [];

    final result = <GeneratedExercise>[];
    for (var i = 0; i < 8; i++) {
      final length = 2 + (i % 2);
      if (lesson.exerciseTypes.contains(ExerciseType.fidelWordRead)) {
        result.add(_generator.generateSyllableJoinChoice(pool, length: length));
      }
      if (lesson.exerciseTypes.contains(ExerciseType.fidelWordBuild)) {
        result.add(_generator.generateSyllableJoinBuild(pool, length: length));
      }
    }
    return _sequence(result);
  }

  List<GeneratedExercise> _buildWordReadExercises(String locale) {
    final words = content.lexemesDecodableWith(_learnedChars);
    if (words.isEmpty) return const [];

    final result = <GeneratedExercise>[];
    var i = 0;
    for (final word in words.take(15)) {
      switch (i % 4) {
        case 0:
          result.add(_generator.generateWordReadChoice(word, locale));
          break;
        case 1:
          result.add(_generator.generateWordReadTyping(word));
          break;
        case 2:
          result.add(_generator.generateWordChoiceFromMeaning(word, locale));
          break;
        default:
          result.add(_generator.generateWordBuild(word));
      }
      i++;
    }
    return _sequence(result);
  }

  List<GeneratedExercise> _buildSentenceReadExercises(String locale) {
    final sentences = content.sentencesDecodableWith(_learnedChars);
    if (sentences.isEmpty) return const [];

    final result = <GeneratedExercise>[];
    var i = 0;
    for (final sentence in sentences.take(10)) {
      if (i % 2 == 0) {
        result.add(_generator.generateSentenceReadChoice(sentence, locale));
      } else {
        result.add(_generator.generateSentenceReadTranslate(sentence, locale));
      }
      i++;
    }
    return _sequence(result);
  }

  List<GeneratedExercise> _buildExtraExercises(FidelLesson lesson) {
    if (lesson.groupIds.isEmpty) return const [];
    final category = lesson.groupIds.first;
    final pool = content.fidelExtrasForCategory(category);
    if (pool.isEmpty) return const [];

    final result = <GeneratedExercise>[];
    for (var i = 0; i < pool.length; i++) {
      if (i.isEven) {
        result.add(_generator.generateExtraCharToMeaning(pool[i], pool));
      } else {
        result.add(_generator.generateExtraMeaningToChar(pool[i], pool));
      }
    }
    return _sequence(result);
  }

  List<GeneratedExercise> _sequence(List<GeneratedExercise> exercises) {
    final capped = exercises.length > 20 ? exercises.sublist(0, 20) : exercises;
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
    final ordered = _sequence(exercises);

    _session = FidelLessonSession(
      stageId: 'practice',
      lessonId: 'practice_$group',
      lesson: FidelLesson(id: 'practice_$group', stageId: 'practice', kind: FidelLessonKind.rowLesson, groupIds: [group]),
      homophoneNotes: const [],
      hahuDrillGroup: group,
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

  void advancePastDrill() {
    final s = _session;
    if (s == null || !s.isShowingDrill) return;
    s.currentIndex++;
    notifyListeners();
  }

  /// For choice- and build-based exercises the widget already knows the
  /// exact expected string; for typing exercises use [submitTypedAnswer].
  void submitChoiceOrBuildAnswer(String givenAnswer) {
    final s = _session;
    final exercise = s?.currentExercise;
    if (s == null || exercise == null || s.answered) return;

    final correct = givenAnswer.trim() == exercise.correctAnswer.trim();
    _applyResult(correct: correct, almost: false);
  }

  void submitTypedAnswer(String input, String locale) {
    final s = _session;
    final exercise = s?.currentExercise;
    if (s == null || exercise == null || s.answered) return;

    final result = AnswerChecker.check(
      input: input,
      acceptedAnswers: [exercise.correctAnswer],
      transliterationTolerance: exercise.expectsTransliteration,
      articles: exercise.expectsTransliteration ? const [] : AnswerChecker.articlesFor(locale),
    );
    _applyResult(correct: result.isCorrect, almost: result.isAlmost);
  }

  void skipCurrentExercise() {
    final s = _session;
    final exercise = s?.currentExercise;
    if (s == null || exercise == null || s.answered) return;

    s.answered = true;
    s.lastAnswerCorrect = false;
    s.lastAnswerAlmost = false;
    s.lastAnswerSkipped = true;
    s.incorrectCount++;
    s.skippedCount++;
    _recordProgress(exercise, correct: false);
    notifyListeners();
  }

  void _applyResult({required bool correct, required bool almost}) {
    final s = _session;
    final exercise = s?.currentExercise;
    if (s == null || exercise == null) return;

    s.answered = true;
    s.lastAnswerCorrect = correct;
    s.lastAnswerAlmost = almost;
    s.lastAnswerSkipped = false;

    if (correct) {
      s.correctCount++;
    } else {
      s.incorrectCount++;
      if (s.heartsRemaining < 999999) s.heartsRemaining--;
    }

    _recordProgress(exercise, correct: correct);
    notifyListeners();
  }

  void _recordProgress(GeneratedExercise exercise, {required bool correct}) {
    final id = exercise.subjectId;
    if (id.startsWith('fidel:')) {
      progress.recordFidelAnswer(id.substring('fidel:'.length), correct: correct);
    } else if (id.startsWith('fidel_extra:')) {
      progress.recordFidelAnswer(id.substring('fidel_extra:'.length), correct: correct);
    } else if (id.startsWith('fidel_word:')) {
      progress.recordLexemeAnswer(id.substring('fidel_word:'.length), correct: correct);
    } else if (id.startsWith('fidel_sentence:')) {
      for (final lexId in exercise.subjectIds) {
        progress.recordLexemeAnswer(lexId, correct: correct);
      }
    }
    // fidel_syllable: intentionally not recorded - synthetic combos, not real content.
  }

  void nextExercise() {
    final s = _session;
    if (s == null) return;
    s.currentIndex++;
    s.answered = false;
    s.lastAnswerCorrect = null;
    s.lastAnswerAlmost = false;
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
