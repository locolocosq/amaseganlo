import 'package:flutter/foundation.dart';

import '../content/content_repository.dart';
import '../content/exercise_generator.dart';
import '../core/answer_checker.dart';
import '../core/audio_service.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';
import '../models/lexeme.dart';
import '../models/sentence.dart';
import 'progress_provider.dart';

const Set<ExerciseType> _wordExerciseTypes = {
  ExerciseType.wordChoiceAmToNative,
  ExerciseType.wordChoiceNativeToAm,
  ExerciseType.wordTyping,
  ExerciseType.listenChoice,
  ExerciseType.listenTyping,
};

const Set<ExerciseType> _audioExerciseTypes = {
  ExerciseType.listenChoice,
  ExerciseType.listenBuild,
  ExerciseType.listenTyping,
};

/// The live state of one lesson being played: which exercises, where the
/// learner currently is, and the running tally for the completion screen.
class LessonSession {
  final String unitId;
  final String lessonId;
  final Lesson lesson;
  final bool isIntro;
  final List<Lexeme> introLexemes;
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

  LessonSession({
    required this.unitId,
    required this.lessonId,
    required this.lesson,
    required this.isIntro,
    required this.introLexemes,
    required this.exercises,
    required this.startedAt,
    required this.startingHearts,
  }) : heartsRemaining = startingHearts;

  GeneratedExercise? get currentExercise =>
      (!isIntro && currentIndex >= 0 && currentIndex < exercises.length)
      ? exercises[currentIndex]
      : null;

  bool get isFinished => isIntro
      ? currentIndex >= introLexemes.length
      : currentIndex >= exercises.length;

  bool get outOfHearts => heartsRemaining <= 0;

  double get scoreRatio =>
      exercises.isEmpty ? 1.0 : correctCount / exercises.length;

  bool get isPerfect => incorrectCount == 0 && skippedCount == 0;

  Duration get elapsed => DateTime.now().difference(startedAt);
}

/// Drives a single lesson session: builds the exercise queue, checks
/// answers, records SRS progress, and tracks hearts/skips/score.
class LessonProvider extends ChangeNotifier {
  final ContentRepository content;
  final ProgressProvider progress;
  final AudioService audioService;
  late final ExerciseGenerator _generator;

  LessonSession? _session;

  LessonProvider({
    required this.content,
    required this.progress,
    required this.audioService,
  }) {
    _generator = ExerciseGenerator(content);
  }

  LessonSession? get session => _session;

  void startLesson({
    required String unitId,
    required String lessonId,
    required String locale,
    required bool useHearts,
  }) {
    final lesson = content
        .lessonsForUnit(unitId)
        .where((l) => l.id == lessonId)
        .firstOrNull;
    if (lesson == null) {
      _session = null;
      notifyListeners();
      return;
    }

    final audioAvailable = audioService.isAmharicAvailable;

    if (lesson.kind == LessonKind.intro) {
      final lexemes = [
        for (final id in lesson.lexemeIds) content.lexeme(id),
      ].nonNulls.toList();
      _session = LessonSession(
        unitId: unitId,
        lessonId: lessonId,
        lesson: lesson,
        isIntro: true,
        introLexemes: lexemes,
        exercises: const [],
        startedAt: DateTime.now(),
        startingHearts: useHearts ? 5 : 999999,
      );
    } else {
      final exercises = _buildExercises(lesson, locale, audioAvailable);
      _session = LessonSession(
        unitId: unitId,
        lessonId: lessonId,
        lesson: lesson,
        isIntro: false,
        introLexemes: const [],
        exercises: exercises,
        startedAt: DateTime.now(),
        startingHearts: useHearts ? 5 : 999999,
      );
    }
    notifyListeners();
  }

  /// Builds and starts a session from a [Lesson] that was assembled on the
  /// fly (Wiederholung: fällige/schwierige Wörter, freies Üben) instead of
  /// being looked up from a unit's content file.
  void startAdHocSession({
    required Lesson lesson,
    required String locale,
    required bool useHearts,
  }) {
    final exercises = _buildExercises(
      lesson,
      locale,
      audioService.isAmharicAvailable,
    );
    _session = LessonSession(
      unitId: lesson.unitId,
      lessonId: lesson.id,
      lesson: lesson,
      isIntro: false,
      introLexemes: const [],
      exercises: exercises,
      startedAt: DateTime.now(),
      startingHearts: useHearts ? 5 : 999999,
    );
    notifyListeners();
  }

  /// Kapitel-Test (Teil A1): up to 20 questions drawn from every word the
  /// unit introduces, at least a quarter of them typed rather than chosen
  /// (5 of 20, scaled down for units with fewer words). No hearts - a
  /// wrong answer here only affects the pass/fail score, not the attempt
  /// itself. Passing/failing is decided by the caller from the finished
  /// session's `scoreRatio` (Abschnitt-A threshold: 85%).
  void startChapterTest({required String unitId, required String locale}) {
    final lexemes = List<Lexeme>.from(content.lexemesForUnit(unitId))
      ..shuffle(_generator.random);
    if (lexemes.isEmpty) {
      _session = null;
      notifyListeners();
      return;
    }

    final testWords = lexemes.length > 20 ? lexemes.sublist(0, 20) : lexemes;
    final typingCount = (testWords.length / 4).round().clamp(
      1,
      testWords.length,
    );

    final exercises = <GeneratedExercise>[];
    for (var i = 0; i < testWords.length; i++) {
      final lexeme = testWords[i];
      if (i < typingCount) {
        exercises.add(
          _generator.generateWordTyping(
            subject: lexeme,
            amToNative: i.isEven,
            locale: locale,
          ),
        );
      } else {
        exercises.add(
          _generator.generateWordChoice(
            subject: lexeme,
            amToNative: i.isOdd,
            locale: locale,
          ),
        );
      }
    }
    exercises.shuffle(_generator.random);

    final lesson = Lesson(
      id: 'chapter_test_$unitId',
      unitId: unitId,
      kind: LessonKind.unitTest,
      lexemeIds: [for (final l in testWords) l.id],
      exerciseTypes: const [],
    );
    _session = LessonSession(
      unitId: unitId,
      lessonId: lesson.id,
      lesson: lesson,
      isIntro: false,
      introLexemes: const [],
      exercises: exercises,
      startedAt: DateTime.now(),
      startingHearts: 999999,
    );
    notifyListeners();
  }

  List<GeneratedExercise> _buildExercises(
    Lesson lesson,
    String locale,
    bool audioAvailable,
  ) {
    final types = lesson.exerciseTypes
        .where((t) => audioAvailable || !_audioExerciseTypes.contains(t))
        .toList();
    if (types.isEmpty) return const [];

    final lexemes = [
      for (final id in lesson.lexemeIds) content.lexeme(id),
    ].nonNulls.toList();
    final sentences = [
      for (final id in lesson.sentenceIds) content.sentence(id),
    ].nonNulls.toList();

    final result = <GeneratedExercise>[];

    if (types.contains(ExerciseType.pairMatching) && lexemes.length >= 4) {
      final subset = List<Lexeme>.from(lexemes)..shuffle(_generator.random);
      result.add(
        _generator.generatePairMatching(
          subjects: subset.take(5).toList(),
          locale: locale,
        ),
      );
    }

    var typeAlternator = 0;
    final wordTypes = types
        .where((t) => _wordExerciseTypes.contains(t))
        .toList();
    for (final lexeme in lexemes) {
      if (wordTypes.isEmpty) break;
      final type = wordTypes[typeAlternator % wordTypes.length];
      typeAlternator++;
      final exercise = _generateWordExercise(type, lexeme, locale);
      if (exercise != null) result.add(exercise);
    }

    for (final sentence in sentences) {
      for (final type in types) {
        final exercise = _generateSentenceExercise(type, sentence, locale);
        if (exercise != null) result.add(exercise);
      }
    }

    final capped = result.length > 18 ? result.sublist(0, 18) : result;
    return ExerciseSequencer(random: _generator.random).order(capped);
  }

  GeneratedExercise? _generateWordExercise(
    ExerciseType type,
    Lexeme lexeme,
    String locale,
  ) {
    switch (type) {
      case ExerciseType.wordChoiceAmToNative:
        return _generator.generateWordChoice(
          subject: lexeme,
          amToNative: true,
          locale: locale,
        );
      case ExerciseType.wordChoiceNativeToAm:
        return _generator.generateWordChoice(
          subject: lexeme,
          amToNative: false,
          locale: locale,
        );
      case ExerciseType.wordTyping:
        return _generator.generateWordTyping(
          subject: lexeme,
          amToNative: true,
          locale: locale,
        );
      case ExerciseType.listenChoice:
        return _generator.generateListenChoice(subject: lexeme, locale: locale);
      case ExerciseType.listenTyping:
        return _generator.generateListenTyping(subject: lexeme);
      default:
        return null;
    }
  }

  /// Exercise types that redact or rearrange word chunks - meaningless (or
  /// actively confusing, see the bug report that prompted this: a gap-fill
  /// on a one-word sentence like "ይቅርታ።"/"yikirta." shows nothing but a
  /// blank, since there's no other chunk left once the only one is
  /// redacted) once a sentence has fewer than 2 chunks. Phrase/interjection
  /// "sentences" generated as-is from a single-chunk lexeme (Etappe 28) hit
  /// this regularly - sentenceTranslate/trueFalse below stay unaffected
  /// since they never touch individual chunks.
  static const _chunkDependentTypes = {
    ExerciseType.sentenceBuild,
    ExerciseType.sentenceGapChoice,
    ExerciseType.sentenceGapTyping,
    ExerciseType.listenBuild,
  };

  GeneratedExercise? _generateSentenceExercise(
    ExerciseType type,
    Sentence sentence,
    String locale,
  ) {
    if (_chunkDependentTypes.contains(type) && sentence.chunks.length < 2) return null;
    switch (type) {
      case ExerciseType.sentenceBuild:
        return _generator.generateSentenceBuild(
          sentence: sentence,
          locale: locale,
        );
      case ExerciseType.sentenceGapChoice:
        return _generator.generateSentenceGapChoice(
          sentence: sentence,
          locale: locale,
        );
      case ExerciseType.sentenceGapTyping:
        return _generator.generateSentenceGapTyping(sentence: sentence);
      case ExerciseType.sentenceTranslate:
        return _generator.generateSentenceTranslate(
          sentence: sentence,
          locale: locale,
        );
      case ExerciseType.trueFalse:
        return _generator.generateTrueFalse(sentence: sentence, locale: locale);
      case ExerciseType.listenBuild:
        return _generator.generateSentenceBuild(
          sentence: sentence,
          locale: locale,
          audio: true,
        );
      default:
        return null;
    }
  }

  List<String> acceptedAnswersFor(GeneratedExercise exercise, String locale) {
    if (exercise.expectsTransliteration) return [exercise.correctAnswer];
    final lexeme = content.lexeme(exercise.subjectId);
    if (lexeme != null) return lexeme.acceptedTranslations(locale);
    final sentence = content.sentence(exercise.subjectId);
    if (sentence != null) return sentence.acceptedTranslations(locale);
    return [exercise.correctAnswer];
  }

  /// For choice- and build-based exercises the widget already knows the
  /// exact expected string; for typing exercises use [submitTypedAnswer].
  void submitChoiceOrBuildAnswer(String givenAnswer) {
    final s = _session;
    final exercise = s?.currentExercise;
    if (s == null || exercise == null || s.answered) return;

    final correct =
        _normalizeForCompare(givenAnswer) ==
        _normalizeForCompare(exercise.correctAnswer);
    _applyResult(correct: correct, almost: false);
  }

  void submitTypedAnswer(String input, String locale) {
    final s = _session;
    final exercise = s?.currentExercise;
    if (s == null || exercise == null || s.answered) return;

    final result = AnswerChecker.check(
      input: input,
      acceptedAnswers: acceptedAnswersFor(exercise, locale),
      transliterationTolerance: exercise.expectsTransliteration,
      articles: exercise.expectsTransliteration
          ? const []
          : AnswerChecker.articlesFor(locale),
    );
    _applyResult(correct: result.isCorrect, almost: result.isAlmost);
  }

  /// Pair matching is scored as a whole once the round is fully solved -
  /// mismatched taps just bounce back in the widget without ending the try.
  void submitPairMatchingComplete() {
    _applyResult(correct: true, almost: false);
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
    _recordSrs(exercise, correct: false);
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

    _recordSrs(exercise, correct: correct);
    audioService.playFeedback(correct: correct);
    notifyListeners();
  }

  void _recordSrs(GeneratedExercise exercise, {required bool correct}) {
    for (final id in exercise.subjectIds) {
      if (content.lexeme(id) != null) {
        progress.recordLexemeAnswer(id, correct: correct);
      }
    }
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

  void nextIntroCard() {
    final s = _session;
    if (s == null || !s.isIntro) return;
    s.currentIndex++;
    notifyListeners();
  }

  /// Plays the current intro card's word - used by the speaker button on
  /// [IntroCard], which stays disabled (via a null callback) when no audio
  /// is available at all.
  Future<void> playIntroAudio() async {
    final s = _session;
    if (s == null || !s.isIntro || s.currentIndex >= s.introLexemes.length) {
      return;
    }
    final lexeme = s.introLexemes[s.currentIndex];
    await audioService.speakText(id: lexeme.id, amharicText: lexeme.am);
  }

  /// Plays the current exercise's underlying word/sentence - used by the
  /// speaker button shown on listen* exercises.
  Future<void> playCurrentAudio() async {
    final exercise = _session?.currentExercise;
    if (exercise == null) return;
    final amharicText =
        content.lexeme(exercise.subjectId)?.am ??
        content.sentence(exercise.subjectId)?.am ??
        '';
    if (amharicText.isEmpty) return;
    await audioService.speakText(
      id: exercise.subjectId,
      amharicText: amharicText,
    );
  }

  void endSession() {
    _session = null;
    notifyListeners();
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

String _normalizeForCompare(String v) =>
    v.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
