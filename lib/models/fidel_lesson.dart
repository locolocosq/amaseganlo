import 'lesson.dart';

enum FidelLessonKind {
  charIntro,
  review,
  stageTest,
  vowelExplainer,
  rowLesson,
  blockTest,
  syllableJoin,
  wordRead,
  sentenceRead,
  numeralsPunctuation,
  writingPractice,
}

FidelLessonKind _kindFromName(String? name) =>
    FidelLessonKind.values.firstWhere((k) => k.name == name, orElse: () => FidelLessonKind.charIntro);

/// One lesson within a Fidel stage (Stufe 1-8). Unlike learning path A's
/// [Lesson], this references Fidel character groups instead of lexemes.
class FidelLesson {
  final String id;
  final String stageId;
  final FidelLessonKind kind;
  final List<String> groupIds;
  final List<ExerciseType> exerciseTypes;

  /// Maps a group id introduced in this lesson to the group id(s) it sounds
  /// identical to, already learned earlier (Stufe 1's homophone warning).
  final Map<String, List<String>> homophoneOf;

  const FidelLesson({
    required this.id,
    required this.stageId,
    required this.kind,
    this.groupIds = const [],
    this.exerciseTypes = const [],
    this.homophoneOf = const {},
  });

  factory FidelLesson.fromJson(Map<String, dynamic> json, {required String stageId}) {
    return FidelLesson(
      id: json['id'] as String,
      stageId: stageId,
      kind: _kindFromName(json['kind'] as String?),
      groupIds: List<String>.from(json['groupIds'] as List? ?? const []),
      exerciseTypes: [
        for (final t in (json['exerciseTypes'] as List? ?? const [])) exerciseTypeFromName(t as String),
      ],
      homophoneOf: (json['homophoneOf'] as Map?)?.map(
            (k, v) => MapEntry(k as String, List<String>.from(v as List)),
          ) ??
          const {},
    );
  }
}

/// One stage of the Fidel path (Stufe 1-8).
class FidelStage {
  final String id;
  final int number;
  final Map<String, String> title;
  final Map<String, String> description;
  final String lessonFile;
  final bool isBonus;

  const FidelStage({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.lessonFile,
    this.isBonus = false,
  });

  factory FidelStage.fromJson(Map<String, dynamic> json) {
    return FidelStage(
      id: json['id'] as String,
      number: json['number'] as int,
      title: Map<String, String>.from(json['title'] as Map? ?? const {}),
      description: Map<String, String>.from(json['description'] as Map? ?? const {}),
      lessonFile: json['lessonFile'] as String,
      isBonus: json['isBonus'] as bool? ?? false,
    );
  }
}
