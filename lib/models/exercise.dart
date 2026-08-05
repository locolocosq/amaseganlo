import 'lesson.dart';

/// One left/right pair for a pair-matching exercise.
class MatchPair {
  final String id;
  final String left;
  final String right;

  const MatchPair({required this.id, required this.left, required this.right});
}

/// One concrete, ready-to-render exercise, built at runtime by the
/// ExerciseGenerator from a Lesson's word/sentence pool. Never persisted.
class GeneratedExercise {
  final ExerciseType type;

  /// The id of the lexeme or sentence this exercise is primarily about, so
  /// the app can look up audio, hints, and update SRS progress.
  final String subjectId;

  /// All lexeme/sentence ids involved - for pair matching and sentence
  /// exercises this can be more than one. Defaults to [subjectId].
  final List<String> allSubjectIds;

  final String promptText;
  final String correctAnswer;

  /// For choice-based exercise types: all options including the correct one,
  /// already shuffled.
  final List<String> options;

  /// For build-from-chunks exercise types: the shuffled chunks to tap,
  /// including any distractor chunks.
  final List<String> chunks;

  /// For pair-matching exercises: the correct pairs, already shuffled on
  /// each side by the widget.
  final List<MatchPair> pairs;

  final String? hint;

  /// True for "listen and ..." exercises: the widget hides the transliteration
  /// behind a play button instead of showing it directly.
  final bool isAudioPrompt;

  /// True when the expected typed answer is Amharic transliteration (so
  /// apostrophe/spelling variants are tolerated); false for typed answers in
  /// the learner's own language (so articles are optional instead).
  final bool expectsTransliteration;

  /// The UI locale to use for article-stripping when checking a typed
  /// translation. Ignored when [expectsTransliteration] is true.
  final String? answerLocale;

  const GeneratedExercise({
    required this.type,
    required this.subjectId,
    List<String>? allSubjectIds,
    required this.promptText,
    required this.correctAnswer,
    this.options = const [],
    this.chunks = const [],
    this.pairs = const [],
    this.hint,
    this.isAudioPrompt = false,
    this.expectsTransliteration = false,
    this.answerLocale,
  }) : allSubjectIds = allSubjectIds ?? const [];

  List<String> get subjectIds => allSubjectIds.isEmpty ? [subjectId] : allSubjectIds;

  bool get isChoiceBased => options.isNotEmpty;
  bool get isBuildBased => chunks.isNotEmpty;
  bool get isPairBased => pairs.isNotEmpty;
  bool get isTypingBased => options.isEmpty && chunks.isEmpty && pairs.isEmpty;
}
