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

/// All 18 exercise types required by the spec. The exercise generator picks
/// among the ones a lesson allows.
enum ExerciseType {
  // word exercises
  wordChoiceAmToNative,
  wordChoiceNativeToAm,
  emojiMatch,
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
      kind: LessonKind.values.firstWhere(
        (k) => k.name == json['kind'],
        orElse: () => LessonKind.wordPractice,
      ),
      lexemeIds: List<String>.from(json['lexemeIds'] as List? ?? const []),
      sentenceIds: List<String>.from(json['sentenceIds'] as List? ?? const []),
      exerciseTypes: [
        for (final t in (json['exerciseTypes'] as List? ?? const [])) exerciseTypeFromName(t as String),
      ],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'lexemeIds': lexemeIds,
        'sentenceIds': sentenceIds,
        'exerciseTypes': [for (final e in exerciseTypes) e.name],
      };
}
