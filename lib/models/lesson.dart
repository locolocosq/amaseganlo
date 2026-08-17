/// The six-step shape of a unit in learning path A, in fixed order.
enum LessonKind {
  intro,
  wordPractice,
  sentenceBuilding,
  listening,
  freeApplication,
  review,
  unitTest,
}

/// Exercise types the generator picks among for a given lesson. `emojiMatch`
/// (an emoji shown alone, asking for the word) was removed on request - an
/// emoji should only ever appear alongside its word, never as the sole
/// prompt of a question.
enum ExerciseType {
  // word exercises
  wordChoiceAmToNative,
  wordChoiceNativeToAm,
  pairMatching,
  wordTyping,
  // sentence exercises
  sentenceBuild,
  sentenceGapChoice,
  sentenceGapTyping,
  sentenceTranslate,
  trueFalse,
  // listening exercises
  listenChoice,
  listenBuild,
  listenTyping,
  // fidel exercises
  fidelCharToSound,
  fidelSoundToChar,
  fidelOrderRecognition,
  fidelWordRead,
  fidelWordBuild,
  // fidel audio drill (Etappe 24): hear the sign spoken, pick its shape -
  // no transliteration text shown, unlike fidelSoundToChar.
  fidelListenChoice,
}

ExerciseType exerciseTypeFromName(String name) =>
    ExerciseType.values.firstWhere((e) => e.name == name, orElse: () => ExerciseType.wordChoiceAmToNative);

/// One lesson within a unit: which words/sentences it covers and which
/// exercise types are allowed to appear. The concrete exercises (with wrong
/// answer choices etc.) are built at runtime by the ExerciseGenerator - they
/// are deliberately not stored here.
class Lesson {
  final String id;
  final String unitId;
  final LessonKind kind;
  final List<String> lexemeIds;
  final List<String> sentenceIds;
  final List<ExerciseType> exerciseTypes;

  const Lesson({
    required this.id,
    required this.unitId,
    required this.kind,
    this.lexemeIds = const [],
    this.sentenceIds = const [],
    required this.exerciseTypes,
  });

  factory Lesson.fromJson(Map<String, dynamic> json, {required String unitId}) {
    return Lesson(
      id: json['id'] as String,
      unitId: unitId,
      kind: _lessonKindFromJson(json['kind'] as String?, unitId: unitId, lessonId: json['id'] as String?),
      lexemeIds: List<String>.from(json['lexemeIds'] as List? ?? const []),
      sentenceIds: List<String>.from(json['sentenceIds'] as List? ?? const []),
      exerciseTypes: [
        for (final t in (json['exerciseTypes'] as List? ?? const [])) exerciseTypeFromName(t as String),
      ],
    );
  }

  /// A handful of older curriculum.json content files (127 units, found by
  /// full-app audit) predate `LessonKind`'s current names and still use
  /// "words"/"sentences"/"free" instead of "wordPractice"/"sentenceBuilding"/
  /// "freeApplication". Those aren't typos to migrate away - both spellings
  /// are accepted content, on purpose, so this mapping needs to keep
  /// existing indefinitely rather than being a one-time fixup. What must
  /// never happen again is silently mapping an *unrecognized* kind to
  /// wordPractice (the previous behaviour): that's exactly how 376 stages
  /// across those 127 units silently turned into extra "Wörter üben" tiles
  /// and generated word exercises from a stage's sentenceIds instead of the
  /// sentence exercises it was actually meant to have - invisible until a
  /// user happened to notice the labels. A genuinely unknown kind now
  /// throws, which ContentRepository already catches per-unit (a missing/
  /// broken lesson file is skipped, not a whole-app crash) instead of
  /// quietly corrupting that unit's lesson list.
  static const _kindAliases = {
    'words': LessonKind.wordPractice,
    'sentences': LessonKind.sentenceBuilding,
    'free': LessonKind.freeApplication,
  };

  static LessonKind _lessonKindFromJson(String? raw, {required String unitId, String? lessonId}) {
    if (raw == null) {
      throw FormatException('Lesson "$lessonId" in unit "$unitId" has no "kind" field');
    }
    for (final k in LessonKind.values) {
      if (k.name == raw) return k;
    }
    final aliased = _kindAliases[raw];
    if (aliased != null) return aliased;
    throw FormatException('Lesson "$lessonId" in unit "$unitId" has unrecognized kind "$raw"');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'lexemeIds': lexemeIds,
        'sentenceIds': sentenceIds,
        'exerciseTypes': [for (final e in exerciseTypes) e.name],
      };
}
