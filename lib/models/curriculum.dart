/// A themed, leveled block of units, e.g. "A1.1 - die ersten Schritte".
class CurriculumSection {
  final String id;
  final String level;
  final Map<String, String> title;
  final List<String> unitIds;

  const CurriculumSection({
    required this.id,
    required this.level,
    required this.title,
    required this.unitIds,
  });

  factory CurriculumSection.fromJson(Map<String, dynamic> json) {
    return CurriculumSection(
      id: json['id'] as String,
      level: json['level'] as String? ?? '',
      title: Map<String, String>.from(json['title'] as Map? ?? const {}),
      unitIds: List<String>.from(json['units'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
        'title': title,
        'units': unitIds,
      };
}

/// One chapter ("Kapitel") within a section, bundling 4-6 lessons.
class CurriculumUnit {
  final String id;
  final String sectionId;
  final String level;
  final Map<String, String> title;
  final String topic;
  final String lessonFile;

  const CurriculumUnit({
    required this.id,
    required this.sectionId,
    required this.level,
    required this.title,
    required this.topic,
    required this.lessonFile,
  });

  factory CurriculumUnit.fromJson(Map<String, dynamic> json) {
    return CurriculumUnit(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      level: json['level'] as String? ?? '',
      title: Map<String, String>.from(json['title'] as Map? ?? const {}),
      topic: json['topic'] as String? ?? '',
      lessonFile: json['lessonFile'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sectionId': sectionId,
        'level': level,
        'title': title,
        'topic': topic,
        'lessonFile': lessonFile,
      };
}

/// The parsed contents of curriculum.json: which lexeme/sentence pool files
/// to load, and the ordered list of sections and units.
class Curriculum {
  final int schemaVersion;
  final List<String> lexemeFiles;
  final List<String> sentenceFiles;
  final List<CurriculumSection> sections;
  final List<CurriculumUnit> units;

  const Curriculum({
    required this.schemaVersion,
    required this.lexemeFiles,
    required this.sentenceFiles,
    required this.sections,
    required this.units,
  });

  factory Curriculum.fromJson(Map<String, dynamic> json) {
    return Curriculum(
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      lexemeFiles: List<String>.from(json['lexemeFiles'] as List? ?? const []),
      sentenceFiles: List<String>.from(json['sentenceFiles'] as List? ?? const []),
      sections: [
        for (final s in (json['sections'] as List? ?? const []))
          CurriculumSection.fromJson(s as Map<String, dynamic>),
      ],
      units: [
        for (final u in (json['units'] as List? ?? const []))
          CurriculumUnit.fromJson(u as Map<String, dynamic>),
      ],
    );
  }
}
