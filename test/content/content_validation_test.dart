// Validates the raw JSON content files directly (not through
// ContentRepository) so that problems like duplicate ids - which a Map
// would silently swallow - are actually caught. This only runs on the Dart
// VM via `flutter test`, so dart:io is fine here even though app code never
// uses it (the app must run on web too).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _locales = ['de', 'en', 'sv', 'nl'];
const _contentDir = 'assets/content';

Map<String, dynamic> _readJsonObject(String path) => jsonDecode(File('$_contentDir/$path').readAsStringSync()) as Map<String, dynamic>;

List<dynamic> _readJsonArray(String path) => jsonDecode(File('$_contentDir/$path').readAsStringSync()) as List<dynamic>;

void main() {
  late Map<String, dynamic> curriculum;
  late List<dynamic> sections;
  late List<dynamic> units;
  late Map<String, Map<String, dynamic>> lexemesById;
  late Map<String, Map<String, dynamic>> sentencesById;
  late Map<String, List<dynamic>> lessonsByUnitId;

  setUpAll(() {
    curriculum = _readJsonObject('curriculum.json');
    sections = curriculum['sections'] as List<dynamic>;
    units = curriculum['units'] as List<dynamic>;

    lexemesById = {};
    for (final file in (curriculum['lexemeFiles'] as List<dynamic>)) {
      for (final item in _readJsonArray(file as String)) {
        final map = item as Map<String, dynamic>;
        lexemesById[map['id'] as String] = map;
      }
    }

    sentencesById = {};
    for (final file in (curriculum['sentenceFiles'] as List<dynamic>)) {
      for (final item in _readJsonArray(file as String)) {
        final map = item as Map<String, dynamic>;
        sentencesById[map['id'] as String] = map;
      }
    }

    lessonsByUnitId = {};
    for (final unit in units) {
      final unitMap = unit as Map<String, dynamic>;
      lessonsByUnitId[unitMap['id'] as String] = _readJsonArray(unitMap['lessonFile'] as String);
    }
  });

  test('no duplicate lexeme ids across all lexeme files', () {
    final seen = <String>{};
    final duplicates = <String>[];
    for (final file in (curriculum['lexemeFiles'] as List<dynamic>)) {
      for (final item in _readJsonArray(file as String)) {
        final id = (item as Map<String, dynamic>)['id'] as String;
        if (!seen.add(id)) duplicates.add(id);
      }
    }
    expect(duplicates, isEmpty, reason: 'Duplicate lexeme ids: $duplicates');
  });

  test('no duplicate sentence ids across all sentence files', () {
    final seen = <String>{};
    final duplicates = <String>[];
    for (final file in (curriculum['sentenceFiles'] as List<dynamic>)) {
      for (final item in _readJsonArray(file as String)) {
        final id = (item as Map<String, dynamic>)['id'] as String;
        if (!seen.add(id)) duplicates.add(id);
      }
    }
    expect(duplicates, isEmpty, reason: 'Duplicate sentence ids: $duplicates');
  });

  test('no duplicate unit ids and no duplicate section ids', () {
    final unitIds = units.map((u) => (u as Map<String, dynamic>)['id'] as String).toList();
    expect(unitIds.toSet().length, unitIds.length, reason: 'Duplicate unit ids found');

    final sectionIds = sections.map((s) => (s as Map<String, dynamic>)['id'] as String).toList();
    expect(sectionIds.toSet().length, sectionIds.length, reason: 'Duplicate section ids found');
  });

  test('every lexeme has a non-empty translation for all 4 languages', () {
    final problems = <String>[];
    lexemesById.forEach((id, map) {
      final t = map['t'] as Map<String, dynamic>? ?? {};
      for (final locale in _locales) {
        final value = t[locale];
        if (value == null || (value as String).trim().isEmpty) {
          problems.add('$id fehlt Übersetzung für "$locale"');
        }
      }
    });
    expect(problems, isEmpty, reason: problems.join('; '));
  });

  test('every sentence has a non-empty translation for all 4 languages', () {
    final problems = <String>[];
    sentencesById.forEach((id, map) {
      final t = map['t'] as Map<String, dynamic>? ?? {};
      for (final locale in _locales) {
        final value = t[locale];
        if (value == null || (value as String).trim().isEmpty) {
          problems.add('$id fehlt Übersetzung für "$locale"');
        }
      }
    });
    expect(problems, isEmpty, reason: problems.join('; '));
  });

  test('every lexeme has non-empty id, am and tr fields', () {
    final problems = <String>[];
    lexemesById.forEach((id, map) {
      if ((map['am'] as String? ?? '').trim().isEmpty) problems.add('$id fehlt "am"');
      if ((map['tr'] as String? ?? '').trim().isEmpty) problems.add('$id fehlt "tr"');
    });
    expect(problems, isEmpty, reason: problems.join('; '));
  });

  test('every lesson references only lexeme ids that actually exist', () {
    final problems = <String>[];
    lessonsByUnitId.forEach((unitId, lessons) {
      for (final lesson in lessons) {
        final lessonMap = lesson as Map<String, dynamic>;
        for (final lexId in (lessonMap['lexemeIds'] as List<dynamic>? ?? const [])) {
          if (!lexemesById.containsKey(lexId)) {
            problems.add('Kapitel $unitId, Lektion ${lessonMap['id']}: unbekannte Vokabel-id "$lexId"');
          }
        }
        for (final senId in (lessonMap['sentenceIds'] as List<dynamic>? ?? const [])) {
          if (!sentencesById.containsKey(senId)) {
            problems.add('Kapitel $unitId, Lektion ${lessonMap['id']}: unbekannte Satz-id "$senId"');
          }
        }
      }
    });
    expect(problems, isEmpty, reason: problems.join('; '));
  });

  test('every sentence only uses lexemes introduced at the latest in its own unit', () {
    final problems = <String>[];
    final introducedSoFar = <String>{};

    for (final section in sections) {
      final sectionMap = section as Map<String, dynamic>;
      for (final unitId in (sectionMap['units'] as List<dynamic>)) {
        final lessons = lessonsByUnitId[unitId as String] ?? const [];

        for (final lesson in lessons) {
          final lessonMap = lesson as Map<String, dynamic>;
          for (final lexId in (lessonMap['lexemeIds'] as List<dynamic>? ?? const [])) {
            introducedSoFar.add(lexId as String);
          }
        }

        for (final lesson in lessons) {
          final lessonMap = lesson as Map<String, dynamic>;
          for (final senId in (lessonMap['sentenceIds'] as List<dynamic>? ?? const [])) {
            final sentence = sentencesById[senId as String];
            if (sentence == null) continue;
            for (final usedLexId in (sentence['uses'] as List<dynamic>? ?? const [])) {
              if (!introducedSoFar.contains(usedLexId)) {
                problems.add('Satz $senId (Kapitel $unitId) benutzt "$usedLexId", das erst später eingeführt wird');
              }
            }
          }
        }
      }
    }

    expect(problems, isEmpty, reason: problems.join('; '));
  });

  test('every sentence referenced by a sentenceBuilding-kind lesson stage has at least 2 chunks', () {
    // Etappe 28 Nachtrag 7 (bug report via screenshot): a one-chunk
    // "sentence" (e.g. a bare interjection like "yikirta."/"Entschuldigung.")
    // makes the drag-word-order/gap-fill exercises degenerate - redacting
    // the sentence's only word leaves nothing but an empty blank, no
    // context to guess from. lesson_provider.dart's _chunkDependentTypes
    // guard already keeps that from reaching the learner even if this ever
    // regresses, but the content itself should never put a sentence this
    // short in that stage to begin with.
    final problems = <String>[];
    for (final unit in units) {
      final unitMap = unit as Map<String, dynamic>;
      final lessons = lessonsByUnitId[unitMap['id'] as String] ?? const [];
      for (final lesson in lessons) {
        final lessonMap = lesson as Map<String, dynamic>;
        if (lessonMap['kind'] != 'sentenceBuilding' && lessonMap['kind'] != 'sentences') continue;
        for (final senId in (lessonMap['sentenceIds'] as List<dynamic>? ?? const [])) {
          final sentence = sentencesById[senId as String];
          final chunks = sentence?['chunks'] as List<dynamic>? ?? const [];
          if (chunks.length < 2) {
            problems.add('Satz $senId (Kapitel ${unitMap['id']}) hat nur ${chunks.length} Chunk(s)');
          }
        }
      }
    }
    expect(problems, isEmpty, reason: problems.join('; '));
  });

  test('every unit id used in a section actually exists in the units list', () {
    final unitIds = units.map((u) => (u as Map<String, dynamic>)['id'] as String).toSet();
    final problems = <String>[];
    for (final section in sections) {
      final sectionMap = section as Map<String, dynamic>;
      for (final unitId in (sectionMap['units'] as List<dynamic>)) {
        if (!unitIds.contains(unitId)) {
          problems.add('Abschnitt ${sectionMap['id']} verweist auf unbekanntes Kapitel "$unitId"');
        }
      }
    }
    expect(problems, isEmpty, reason: problems.join('; '));
  });

  test('there are at least 1000 unique vocabulary entries', () {
    expect(lexemesById.length, greaterThanOrEqualTo(1000),
        reason: 'Nur ${lexemesById.length} eindeutige Vokabeln, mindestens 1000 gefordert.');
  });
}
