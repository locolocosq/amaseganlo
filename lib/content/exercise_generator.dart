import 'dart:math';

import '../models/exercise.dart';
import '../models/lesson.dart';
import '../models/lexeme.dart';
import '../models/sentence.dart';
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
      expectsTransliteration: !amToNative,
      answerLocale: amToNative ? locale : null,
    );
  }

  /// "Listen and choose the meaning" - same shape as generateWordChoice but
  /// flagged as audio-first. Only produced when Amharic audio is available.
  GeneratedExercise generateListenChoice({required Lexeme subject, required String locale}) {
    final exercise = generateWordChoice(subject: subject, amToNative: true, locale: locale);
    return GeneratedExercise(
      type: ExerciseType.listenChoice,
      subjectId: exercise.subjectId,
      promptText: exercise.promptText,
      correctAnswer: exercise.correctAnswer,
      options: exercise.options,
      isAudioPrompt: true,
    );
  }

  /// "Listen and type what you heard" (in transliteration).
  GeneratedExercise generateListenTyping({required Lexeme subject}) {
    return GeneratedExercise(
      type: ExerciseType.listenTyping,
      subjectId: subject.id,
      promptText: subject.tr,
      correctAnswer: subject.tr,
      isAudioPrompt: true,
      expectsTransliteration: true,
    );
  }

  /// One word is missing from the sentence; pick it from 4 choices.
  GeneratedExercise generateSentenceGapChoice({required Sentence sentence, required String locale}) {
    final gapIndex = sentence.chunks.isEmpty ? 0 : random.nextInt(sentence.chunks.length);
    final missing = sentence.chunks.isEmpty ? '' : sentence.chunks[gapIndex];
    final withGap = [
      for (var i = 0; i < sentence.chunks.length; i++) if (i == gapIndex) '___' else sentence.chunks[i],
    ].join(' ');

    final distractorPool = repository.allLexemes.where((l) => l.level == sentence.level && l.tr != missing).toList()
      ..shuffle(random);
    final options = <String>{missing};
    for (final l in distractorPool) {
      if (options.length >= 4) break;
      options.add(l.tr);
    }

    final result = options.toList()..shuffle(random);

    return GeneratedExercise(
      type: ExerciseType.sentenceGapChoice,
      subjectId: sentence.id,
      allSubjectIds: sentence.uses,
      promptText: withGap,
      correctAnswer: missing,
      options: result,
    );
  }

  /// Same gap-fill idea, but typed instead of chosen.
  GeneratedExercise generateSentenceGapTyping({required Sentence sentence}) {
    final gapIndex = sentence.chunks.isEmpty ? 0 : random.nextInt(sentence.chunks.length);
    final missing = sentence.chunks.isEmpty ? '' : sentence.chunks[gapIndex];
    final withGap = [
      for (var i = 0; i < sentence.chunks.length; i++) if (i == gapIndex) '___' else sentence.chunks[i],
    ].join(' ');

    return GeneratedExercise(
      type: ExerciseType.sentenceGapTyping,
      subjectId: sentence.id,
      allSubjectIds: sentence.uses,
      promptText: withGap,
      correctAnswer: missing,
      expectsTransliteration: true,
    );
  }

  /// Build the Amharic sentence (in transliteration) from its meaning by
  /// tapping word chunks in the right order.
  GeneratedExercise generateSentenceBuild({required Sentence sentence, required String locale, bool audio = false}) {
    final correctAnswer = sentence.chunks.join(' ');
    final distractorPool = repository.allLexemes.where((l) => l.level == sentence.level && !sentence.chunks.contains(l.tr)).toList()
      ..shuffle(random);
    final extraChunks = distractorPool.take(2).map((l) => l.tr).toList();
    final chunks = [...sentence.chunks, ...extraChunks]..shuffle(random);

    return GeneratedExercise(
      type: audio ? ExerciseType.listenBuild : ExerciseType.sentenceBuild,
      subjectId: sentence.id,
      allSubjectIds: sentence.uses,
      promptText: audio ? sentence.tr : (sentence.t[locale] ?? sentence.tr),
      correctAnswer: correctAnswer,
      chunks: chunks,
      isAudioPrompt: audio,
    );
  }

  /// Translate the whole sentence freely into the learner's language.
  GeneratedExercise generateSentenceTranslate({required Sentence sentence, required String locale}) {
    final correctAnswer = sentence.t[locale] ?? sentence.tr;
    return GeneratedExercise(
      type: ExerciseType.sentenceTranslate,
      subjectId: sentence.id,
      allSubjectIds: sentence.uses,
      promptText: sentence.tr,
      correctAnswer: correctAnswer,
      answerLocale: locale,
    );
  }

  /// A statement about a sentence's meaning that is either true or false.
  GeneratedExercise generateTrueFalse({required Sentence sentence, required String locale}) {
    final correctTranslation = sentence.t[locale] ?? sentence.tr;
    var showTrue = random.nextBool();

    String shownTranslation = correctTranslation;
    if (!showTrue) {
      final otherSentences = repository.allSentences.where((s) => s.id != sentence.id && s.t[locale] != null).toList()
        ..shuffle(random);
      if (otherSentences.isNotEmpty) {
        shownTranslation = otherSentences.first.t[locale]!;
      } else {
        showTrue = true; // no distractor sentence available - fall back to a true statement
      }
    }

    return GeneratedExercise(
      type: ExerciseType.trueFalse,
      subjectId: sentence.id,
      allSubjectIds: sentence.uses,
      promptText: '${sentence.tr}\n$shownTranslation',
      correctAnswer: showTrue ? 'true' : 'false',
      options: const ['true', 'false'],
    );
  }

  /// Two columns of 5 words each to match by tapping.
  GeneratedExercise generatePairMatching({required List<Lexeme> subjects, required String locale}) {
    final pairs = [
      for (final l in subjects) MatchPair(id: l.id, left: l.tr, right: l.t[locale] ?? l.tr),
    ];
    return GeneratedExercise(
      type: ExerciseType.pairMatching,
      subjectId: subjects.isNotEmpty ? subjects.first.id : '',
      allSubjectIds: [for (final l in subjects) l.id],
      promptText: '',
      correctAnswer: '',
      pairs: pairs,
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
