import 'dart:math';

import '../models/exercise.dart';
import '../models/lesson.dart';
import '../models/lexeme.dart';
import 'content_repository.dart';

/// Builds concrete exercises at runtime from a lesson's word/sentence pool.
/// Wrong-answer choices ("Ablenker") are preferably drawn from the same
/// topic and level as the correct answer, per Abschnitt 8.
class ExerciseGenerator {
  final ContentRepository repository;
  final Random random;

  ExerciseGenerator(this.repository, {Random? random}) : random = random ?? Random();

  /// Amharic -> native language, or native language -> Amharic, multiple
  /// choice with exactly 4 options.
  GeneratedExercise generateWordChoice({
    required Lexeme subject,
    required bool amToNative,
    required String locale,
  }) {
    String answerTextFor(Lexeme l) => amToNative ? (l.t[locale] ?? l.tr) : l.tr;

    final correctAnswer = answerTextFor(subject);
    final promptText = amToNative ? subject.tr : (subject.t[locale] ?? subject.tr);

    final options = _fourOptions(subject: subject, correctAnswer: correctAnswer, answerTextFor: answerTextFor);

    return GeneratedExercise(
      type: amToNative ? ExerciseType.wordChoiceAmToNative : ExerciseType.wordChoiceNativeToAm,
      subjectId: subject.id,
      promptText: promptText,
      correctAnswer: correctAnswer,
      options: options,
    );
  }

  /// The emoji is shown, the learner picks the matching word.
  GeneratedExercise generateEmojiMatch({required Lexeme subject, required String locale}) {
    final correctAnswer = subject.t[locale] ?? subject.tr;
    final options = _fourOptions(
      subject: subject,
      correctAnswer: correctAnswer,
      answerTextFor: (l) => l.t[locale] ?? l.tr,
      candidatePool: repository.allLexemes.where((l) => l.emoji.isNotEmpty).toList(),
    );

    return GeneratedExercise(
      type: ExerciseType.emojiMatch,
      subjectId: subject.id,
      promptText: subject.emoji,
      correctAnswer: correctAnswer,
      options: options,
    );
  }

  /// Typing exercise: translate the word freely (checked with AnswerChecker,
  /// not against these options).
  GeneratedExercise generateWordTyping({
    required Lexeme subject,
    required bool amToNative,
    required String locale,
  }) {
    final correctAnswer = amToNative ? (subject.t[locale] ?? subject.tr) : subject.tr;
    final promptText = amToNative ? subject.tr : (subject.t[locale] ?? subject.tr);
    return GeneratedExercise(
      type: ExerciseType.wordTyping,
      subjectId: subject.id,
      promptText: promptText,
      correctAnswer: correctAnswer,
    );
  }

  List<String> _fourOptions({
    required Lexeme subject,
    required String correctAnswer,
    required String Function(Lexeme) answerTextFor,
    List<Lexeme>? candidatePool,
  }) {
    final pool = candidatePool ?? repository.allLexemes;

    final sameTopicLevel = pool.where((l) => l.id != subject.id && l.topic == subject.topic && l.level == subject.level).toList()
      ..shuffle(random);
    final sameLevel = pool.where((l) => l.id != subject.id && l.level == subject.level).toList()..shuffle(random);
    final anyOther = pool.where((l) => l.id != subject.id).toList()..shuffle(random);

    final options = <String>{correctAnswer};
    for (final candidates in [sameTopicLevel, sameLevel, anyOther]) {
      for (final candidate in candidates) {
        if (options.length >= 4) break;
        final text = answerTextFor(candidate);
        if (text.isNotEmpty) options.add(text);
      }
      if (options.length >= 4) break;
    }

    final result = options.toList();
    result.shuffle(random);
    return result;
  }
}

/// Sequences exercises for a lesson so the same (type, subject) pair never
/// appears twice in a row (Abschnitt 8: "Nie dieselbe Aufgabe zweimal direkt
/// hintereinander").
class ExerciseSequencer {
  final Random random;
  ExerciseType? _lastType;
  String? _lastSubjectId;

  ExerciseSequencer({Random? random}) : random = random ?? Random();

  List<GeneratedExercise> order(List<GeneratedExercise> exercises) {
    final remaining = List<GeneratedExercise>.from(exercises)..shuffle(random);
    final result = <GeneratedExercise>[];

    while (remaining.isNotEmpty) {
      var index = 0;
      if (result.isNotEmpty) {
        index = remaining.indexWhere(
          (e) => !(e.type == _lastType && e.subjectId == _lastSubjectId),
        );
        if (index == -1) index = 0;
      }
      final next = remaining.removeAt(index);
      result.add(next);
      _lastType = next.type;
      _lastSubjectId = next.subjectId;
    }

    return result;
  }
}
