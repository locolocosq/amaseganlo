import 'lesson.dart';

/// One concrete, ready-to-render exercise, built at runtime by the
/// ExerciseGenerator from a Lesson's word/sentence pool. Never persisted.
class GeneratedExercise {
  final ExerciseType type;

  /// The id of the lexeme or sentence this exercise is about, so the app can
  /// look up audio, hints, and update SRS progress after answering.
  final String subjectId;

  final String promptText;
  final String correctAnswer;

  /// For choice-based exercise types: all options including the correct one,
  /// already shuffled. Empty for typing/build exercise types.
  final List<String> options;

  /// For build-from-chunks exercise types: the shuffled chunks to tap,
  /// including any distractor chunks.
  final List<String> chunks;

  final String? hint;

  const GeneratedExercise({
    required this.type,
    required this.subjectId,
    required this.promptText,
    required this.correctAnswer,
    this.options = const [],
    this.chunks = const [],
    this.hint,
  });

  bool get isChoiceBased => options.isNotEmpty;
  bool get isBuildBased => chunks.isNotEmpty;
  bool get isTypingBased => options.isEmpty && chunks.isEmpty;
}
