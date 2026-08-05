import 'dart:math';

import '../models/exercise.dart';
import '../models/fidel_char.dart';
import '../models/fidel_extra.dart';
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

/// Builds Fidel exercises. The one hard rule from Teil B: two signs that
/// sound identical (same [FidelChar.base], different [FidelChar.group])
/// must never both appear as choices in a sound-to-sign exercise - that
/// would be unanswerable.
class FidelExerciseGenerator {
  final ContentRepository repository;
  final Random random;

  FidelExerciseGenerator(this.repository, {Random? random}) : random = random ?? Random();

  /// Zeichen -> Laut: show the sign, choose the correct transliteration.
  GeneratedExercise generateCharToSound(FidelChar subject) {
    final pool = repository.allFidelChars.where((c) => c.char != subject.char).toList()
      ..shuffle(random);

    final sameOrder = pool.where((c) => c.order == subject.order).toList();
    final options = <String>{subject.tr};
    for (final candidates in [sameOrder, pool]) {
      for (final c in candidates) {
        if (options.length >= 4) break;
        options.add(c.tr);
      }
      if (options.length >= 4) break;
    }

    final result = options.toList()..shuffle(random);
    return GeneratedExercise(
      type: ExerciseType.fidelCharToSound,
      subjectId: 'fidel:${subject.char}',
      promptText: subject.char,
      correctAnswer: subject.tr,
      options: result,
    );
  }

  /// Laut -> Zeichen: show the transliteration, choose the correct sign.
  /// Distractors never include a homophone of the correct sign.
  GeneratedExercise generateSoundToChar(FidelChar subject) {
    final pool = repository.allFidelChars
        .where((c) => c.char != subject.char && c.base != subject.base)
        .toList()
      ..shuffle(random);

    final sameGroup = pool.where((c) => c.group == subject.group).toList();
    final options = <String>{subject.char};
    for (final candidates in [sameGroup, pool]) {
      for (final c in candidates) {
        if (options.length >= 4) break;
        options.add(c.char);
      }
      if (options.length >= 4) break;
    }

    final result = options.toList()..shuffle(random);
    return GeneratedExercise(
      type: ExerciseType.fidelSoundToChar,
      subjectId: 'fidel:${subject.char}',
      promptText: subject.tr,
      correctAnswer: subject.char,
      options: result,
    );
  }

  /// "Welches Zeichen ist lu?" - all distractors from the very same row, so
  /// the learner must actually attend to the vowel part.
  GeneratedExercise generateOrderRecognition(String group, int order) {
    final rowChars = repository.fidelCharsForGroup(group);
    final subject = rowChars.firstWhere((c) => c.order == order, orElse: () => rowChars.first);

    final others = rowChars.where((c) => c.char != subject.char).toList()..shuffle(random);
    final options = <String>{subject.char, ...others.take(3).map((c) => c.char)}.toList()..shuffle(random);

    return GeneratedExercise(
      type: ExerciseType.fidelOrderRecognition,
      subjectId: 'fidel:${subject.char}',
      promptText: subject.tr,
      correctAnswer: subject.char,
      options: options,
    );
  }

  /// Stufe 4: join 2-3 signs from [pool] into a syllable (real word or not,
  /// per Teil B) and choose the matching transliteration.
  GeneratedExercise generateSyllableJoinChoice(List<FidelChar> pool, {int length = 2}) {
    final combo = _randomCombo(pool, length);
    final correctAnswer = combo.map((c) => c.tr).join();
    final promptText = combo.map((c) => c.char).join();

    final options = <String>{correctAnswer};
    var attempts = 0;
    while (options.length < 4 && attempts < 30) {
      attempts++;
      final distractorCombo = _randomCombo(pool, length);
      options.add(distractorCombo.map((c) => c.tr).join());
    }

    return GeneratedExercise(
      type: ExerciseType.fidelWordRead,
      subjectId: 'fidel_syllable:$promptText',
      promptText: promptText,
      correctAnswer: correctAnswer,
      options: options.toList()..shuffle(random),
    );
  }

  /// Stufe 4, the reverse direction: given a transliteration, build the sign
  /// sequence by tapping the right glyphs in order.
  GeneratedExercise generateSyllableJoinBuild(List<FidelChar> pool, {int length = 2}) {
    final combo = _randomCombo(pool, length);
    final correctAnswer = combo.map((c) => c.char).join();
    final promptText = combo.map((c) => c.tr).join();

    final distractorPool = pool.where((c) => !combo.contains(c)).toList()..shuffle(random);
    final chunks = [...combo.map((c) => c.char), ...distractorPool.take(2).map((c) => c.char)]..shuffle(random);

    return GeneratedExercise(
      type: ExerciseType.fidelWordBuild,
      subjectId: 'fidel_syllable:$correctAnswer',
      promptText: promptText,
      correctAnswer: correctAnswer,
      chunks: chunks,
    );
  }

  List<FidelChar> _randomCombo(List<FidelChar> pool, int length) {
    final shuffled = List<FidelChar>.from(pool)..shuffle(random);
    return shuffled.take(length).toList();
  }

  /// Stufe 5: show a word in Fidel, choose its meaning.
  GeneratedExercise generateWordReadChoice(Lexeme subject, String locale) {
    final correctAnswer = subject.t[locale] ?? subject.tr;
    final distractorPool = repository.allLexemes.where((l) => l.id != subject.id).toList()..shuffle(random);
    final options = <String>{correctAnswer};
    for (final l in distractorPool) {
      if (options.length >= 4) break;
      final text = l.t[locale];
      if (text != null && text.isNotEmpty) options.add(text);
    }

    return GeneratedExercise(
      type: ExerciseType.fidelWordRead,
      subjectId: 'fidel_word:${subject.id}',
      promptText: subject.am,
      correctAnswer: correctAnswer,
      options: options.toList()..shuffle(random),
    );
  }

  /// Stufe 5: show a word in Fidel, type what you read (in transliteration).
  GeneratedExercise generateWordReadTyping(Lexeme subject) {
    return GeneratedExercise(
      type: ExerciseType.fidelWordRead,
      subjectId: 'fidel_word:${subject.id}',
      promptText: subject.am,
      correctAnswer: subject.tr,
      expectsTransliteration: true,
    );
  }

  /// Stufe 5: given the meaning, pick the right word written in Fidel.
  GeneratedExercise generateWordChoiceFromMeaning(Lexeme subject, String locale) {
    final correctAnswer = subject.am;
    final distractorPool = repository.allLexemes.where((l) => l.id != subject.id && l.am.isNotEmpty).toList()..shuffle(random);
    final options = <String>{correctAnswer, ...distractorPool.take(3).map((l) => l.am)};

    return GeneratedExercise(
      type: ExerciseType.fidelWordRead,
      subjectId: 'fidel_word:${subject.id}',
      promptText: subject.t[locale] ?? subject.tr,
      correctAnswer: correctAnswer,
      options: options.toList()..shuffle(random),
    );
  }

  /// Stufe 5: build the Fidel word sign by sign from its transliteration.
  GeneratedExercise generateWordBuild(Lexeme subject) {
    final signs = subject.am.runes.map(String.fromCharCode).where((c) => c.trim().isNotEmpty).toList();
    final distractorPool = repository.allFidelChars.where((c) => !signs.contains(c.char)).toList()..shuffle(random);
    final chunks = [...signs, ...distractorPool.take(2).map((c) => c.char)]..shuffle(random);

    return GeneratedExercise(
      type: ExerciseType.fidelWordBuild,
      subjectId: 'fidel_word:${subject.id}',
      promptText: subject.tr,
      correctAnswer: subject.am,
      chunks: chunks,
    );
  }

  /// Stufe 6: show a sentence in Fidel, choose its meaning.
  GeneratedExercise generateSentenceReadChoice(Sentence subject, String locale) {
    final correctAnswer = subject.t[locale] ?? subject.tr;
    final distractorPool = repository.allSentences.where((s) => s.id != subject.id).toList()..shuffle(random);
    final options = <String>{correctAnswer};
    for (final s in distractorPool) {
      if (options.length >= 4) break;
      final text = s.t[locale];
      if (text != null && text.isNotEmpty) options.add(text);
    }

    return GeneratedExercise(
      type: ExerciseType.fidelWordRead,
      subjectId: 'fidel_sentence:${subject.id}',
      allSubjectIds: subject.uses,
      promptText: subject.am,
      correctAnswer: correctAnswer,
      options: options.toList()..shuffle(random),
    );
  }

  /// Stufe 6: show a sentence in Fidel, type its translation.
  GeneratedExercise generateSentenceReadTranslate(Sentence subject, String locale) {
    return GeneratedExercise(
      type: ExerciseType.fidelWordRead,
      subjectId: 'fidel_sentence:${subject.id}',
      allSubjectIds: subject.uses,
      promptText: subject.am,
      correctAnswer: subject.t[locale] ?? subject.tr,
      answerLocale: locale,
    );
  }

  /// Stufe 7: numerals, punctuation, labialized forms - sign shown, meaning
  /// chosen from the same category.
  GeneratedExercise generateExtraCharToMeaning(FidelExtra subject, List<FidelExtra> categoryPool) {
    final distractors = categoryPool.where((e) => e.char != subject.char).toList()..shuffle(random);
    final options = <String>{subject.tr, ...distractors.take(3).map((e) => e.tr)};

    return GeneratedExercise(
      type: ExerciseType.fidelCharToSound,
      subjectId: 'fidel_extra:${subject.char}',
      promptText: subject.char,
      correctAnswer: subject.tr,
      options: options.toList()..shuffle(random),
    );
  }

  /// Stufe 7, reverse direction: meaning shown, choose the sign.
  GeneratedExercise generateExtraMeaningToChar(FidelExtra subject, List<FidelExtra> categoryPool) {
    final distractors = categoryPool.where((e) => e.char != subject.char).toList()..shuffle(random);
    final options = <String>{subject.char, ...distractors.take(3).map((e) => e.char)};

    return GeneratedExercise(
      type: ExerciseType.fidelSoundToChar,
      subjectId: 'fidel_extra:${subject.char}',
      promptText: subject.tr,
      correctAnswer: subject.char,
      options: options.toList()..shuffle(random),
    );
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
