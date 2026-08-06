// Shared helpers for the tool/gen_unit_*.dart scripts: given a compact
// per-unit vocabulary/sentence table, emit the lexemes/sentences JSON files,
// the standard 6-step lesson file, and register the unit in curriculum.json.
import 'dart:convert';
import 'dart:io';

class Tr {
  final String de, en, sv, nl;
  const Tr(this.de, this.en, this.sv, this.nl);
  Map<String, String> toMap() => {'de': de, 'en': en, 'sv': sv, 'nl': nl};
}

class LexemeSpec {
  final String id, am, tr, pos, topic, level, emoji;
  final Tr t;
  final bool verified;
  const LexemeSpec({
    required this.id,
    required this.am,
    required this.tr,
    required this.pos,
    required this.topic,
    required this.level,
    required this.t,
    this.emoji = '',
    this.verified = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'am': am,
        'tr': tr,
        'pos': pos,
        'topic': topic,
        'level': level,
        't': t.toMap(),
        'hint': <String, String>{},
        'alt': <String, dynamic>{},
        'emoji': emoji,
        'verified': verified,
      };
}

class SentenceSpec {
  final String id, am, tr, level;
  final List<String> uses;
  final Tr t;
  final List<String> chunks;
  final bool verified;
  const SentenceSpec({
    required this.id,
    required this.am,
    required this.tr,
    required this.level,
    required this.uses,
    required this.t,
    required this.chunks,
    this.verified = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'am': am,
        'tr': tr,
        'level': level,
        'uses': uses,
        't': t.toMap(),
        'alt': <String, dynamic>{},
        'chunks': chunks,
        'verified': verified,
      };
}

class UnitSpec {
  final String id, sectionId, level, topic;
  final Tr title;
  final List<LexemeSpec> lexemes;
  final List<SentenceSpec> sentences;
  const UnitSpec({
    required this.id,
    required this.sectionId,
    required this.level,
    required this.topic,
    required this.title,
    required this.lexemes,
    required this.sentences,
  });
}

const _contentDir = 'assets/content';
const encoder = JsonEncoder.withIndent('  ');

void writeUnit(UnitSpec unit) {
  final lexemeFile = 'lexemes_${unit.id.replaceFirst('unit_', '')}.json';
  final sentenceFile = 'sentences_${unit.id.replaceFirst('unit_', '')}.json';
  final lessonFile = '${unit.id}_lessons.json';

  File('$_contentDir/$lexemeFile').writeAsStringSync(encoder.convert([for (final l in unit.lexemes) l.toJson()]));
  File('$_contentDir/$sentenceFile')
      .writeAsStringSync(encoder.convert([for (final s in unit.sentences) s.toJson()]));

  final lexemeIds = [for (final l in unit.lexemes) l.id];
  final sentenceIds = [for (final s in unit.sentences) s.id];
  final lessons = _standardLessons(unit.id, lexemeIds, sentenceIds);
  File('$_contentDir/$lessonFile').writeAsStringSync(encoder.convert(lessons));

  _registerInCurriculum(unit, lexemeFile, sentenceFile, lessonFile);

  stdout.writeln('${unit.id}: ${unit.lexemes.length} Vokabeln, ${unit.sentences.length} Sätze.');
}

List<Map<String, dynamic>> _standardLessons(String unitId, List<String> lexemeIds, List<String> sentenceIds) {
  return [
    {
      'id': '${unitId}_intro',
      'kind': 'intro',
      'lexemeIds': lexemeIds,
      'sentenceIds': <String>[],
      'exerciseTypes': <String>[],
    },
    {
      'id': '${unitId}_words',
      'kind': 'wordPractice',
      'lexemeIds': lexemeIds,
      'sentenceIds': <String>[],
      'exerciseTypes': ['wordChoiceAmToNative', 'wordChoiceNativeToAm', 'pairMatching'],
    },
    {
      'id': '${unitId}_sentences',
      'kind': 'sentenceBuilding',
      'lexemeIds': lexemeIds,
      'sentenceIds': sentenceIds,
      'exerciseTypes': ['sentenceBuild', 'sentenceGapChoice'],
    },
    {
      'id': '${unitId}_listening',
      'kind': 'listening',
      'lexemeIds': lexemeIds,
      'sentenceIds': sentenceIds,
      'exerciseTypes': ['listenChoice', 'listenBuild'],
    },
    {
      'id': '${unitId}_free',
      'kind': 'freeApplication',
      'lexemeIds': lexemeIds,
      'sentenceIds': sentenceIds,
      'exerciseTypes': ['wordTyping', 'sentenceTranslate'],
    },
    {
      'id': '${unitId}_review',
      'kind': 'review',
      'lexemeIds': lexemeIds,
      'sentenceIds': sentenceIds,
      'exerciseTypes': ['wordChoiceAmToNative', 'wordChoiceNativeToAm', 'wordTyping', 'trueFalse'],
    },
  ];
}

void _registerInCurriculum(UnitSpec unit, String lexemeFile, String sentenceFile, String lessonFile) {
  final file = File('$_contentDir/curriculum.json');
  final curriculum = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

  final lexemeFiles = List<String>.from(curriculum['lexemeFiles'] as List);
  if (!lexemeFiles.contains(lexemeFile)) lexemeFiles.add(lexemeFile);
  final sentenceFiles = List<String>.from(curriculum['sentenceFiles'] as List);
  if (!sentenceFiles.contains(sentenceFile)) sentenceFiles.add(sentenceFile);

  final sections = List<Map<String, dynamic>>.from((curriculum['sections'] as List).map((s) => Map<String, dynamic>.from(s as Map)));
  final units = List<Map<String, dynamic>>.from((curriculum['units'] as List).map((u) => Map<String, dynamic>.from(u as Map)));

  final sectionIndex = sections.indexWhere((s) => s['id'] == unit.sectionId);
  if (sectionIndex == -1) {
    throw StateError('Section ${unit.sectionId} does not exist yet - add it first.');
  }
  final sectionUnits = List<String>.from(sections[sectionIndex]['units'] as List);
  if (!sectionUnits.contains(unit.id)) sectionUnits.add(unit.id);
  sections[sectionIndex]['units'] = sectionUnits;

  final unitIndex = units.indexWhere((u) => u['id'] == unit.id);
  final unitEntry = {
    'id': unit.id,
    'sectionId': unit.sectionId,
    'level': unit.level,
    'title': unit.title.toMap(),
    'topic': unit.topic,
    'lessonFile': lessonFile,
  };
  if (unitIndex == -1) {
    units.add(unitEntry);
  } else {
    units[unitIndex] = unitEntry;
  }

  curriculum['lexemeFiles'] = lexemeFiles;
  curriculum['sentenceFiles'] = sentenceFiles;
  curriculum['sections'] = sections;
  curriculum['units'] = units;

  file.writeAsStringSync(encoder.convert(curriculum));
}

void ensureSection({
  required String id,
  required String level,
  required Tr title,
}) {
  final file = File('$_contentDir/curriculum.json');
  final curriculum = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final sections = List<Map<String, dynamic>>.from((curriculum['sections'] as List).map((s) => Map<String, dynamic>.from(s as Map)));
  if (sections.any((s) => s['id'] == id)) return;
  sections.add({'id': id, 'level': level, 'title': title.toMap(), 'units': <String>[]});
  curriculum['sections'] = sections;
  file.writeAsStringSync(encoder.convert(curriculum));
  stdout.writeln('Abschnitt "$id" angelegt.');
}
