import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../models/curriculum.dart';
import '../models/lesson.dart';
import '../models/lexeme.dart';
import '../models/sentence.dart';

/// Loads and holds all learning content from assets/content/. A broken or
/// missing file never crashes the app - the affected unit is skipped and a
/// human-readable warning is recorded instead (Abschnitt 6).
class ContentRepository {
  final AssetBundle _bundle;

  ContentRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  Curriculum _curriculum = const Curriculum(
    schemaVersion: 1,
    lexemeFiles: [],
    sentenceFiles: [],
    sections: [],
    units: [],
  );

  final Map<String, Lexeme> _lexemes = {};
  final Map<String, Sentence> _sentences = {};
  final Map<String, List<Lesson>> _lessonsByUnit = {};
  final Set<String> _failedUnitIds = {};
  final List<String> loadWarnings = [];

  Curriculum get curriculum => _curriculum;
  List<String> get failedUnitIds => _failedUnitIds.toList();

  Future<void> load() async {
    try {
      final raw = await _bundle.loadString('assets/content/curriculum.json');
      _curriculum = Curriculum.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      loadWarnings.add('curriculum.json konnte nicht geladen werden: $e');
      return;
    }

    for (final file in _curriculum.lexemeFiles) {
      try {
        final raw = await _bundle.loadString('assets/content/$file');
        final list = jsonDecode(raw) as List;
        for (final item in list) {
          final lex = Lexeme.fromJson(item as Map<String, dynamic>);
          _lexemes[lex.id] = lex;
        }
      } catch (e) {
        loadWarnings.add('Vokabel-Datei "$file" konnte nicht geladen werden: $e');
      }
    }

    for (final file in _curriculum.sentenceFiles) {
      try {
        final raw = await _bundle.loadString('assets/content/$file');
        final list = jsonDecode(raw) as List;
        for (final item in list) {
          final sentence = Sentence.fromJson(item as Map<String, dynamic>);
          _sentences[sentence.id] = sentence;
        }
      } catch (e) {
        loadWarnings.add('Satz-Datei "$file" konnte nicht geladen werden: $e');
      }
    }

    for (final unit in _curriculum.units) {
      try {
        final raw = await _bundle.loadString('assets/content/${unit.lessonFile}');
        final list = jsonDecode(raw) as List;
        _lessonsByUnit[unit.id] = [
          for (final item in list) Lesson.fromJson(item as Map<String, dynamic>, unitId: unit.id),
        ];
      } catch (e) {
        loadWarnings.add('Kapitel "${unit.id}" konnte nicht geladen werden und wird übersprungen: $e');
        _failedUnitIds.add(unit.id);
      }
    }
  }

  Lexeme? lexeme(String id) => _lexemes[id];
  Sentence? sentence(String id) => _sentences[id];

  List<Lexeme> get allLexemes => _lexemes.values.toList(growable: false);
  List<Sentence> get allSentences => _sentences.values.toList(growable: false);

  List<Lesson> lessonsForUnit(String unitId) => _lessonsByUnit[unitId] ?? const [];

  CurriculumUnit? unit(String id) => _curriculum.units.where((u) => u.id == id).firstOrNull;

  CurriculumSection? sectionForUnit(String unitId) {
    final u = unit(unitId);
    if (u == null) return null;
    return _curriculum.sections.where((s) => s.id == u.sectionId).firstOrNull;
  }

  /// Lexemes used anywhere in a unit's lessons, in lesson order, de-duplicated.
  List<Lexeme> lexemesForUnit(String unitId) {
    final seen = <String>{};
    final result = <Lexeme>[];
    for (final lesson in lessonsForUnit(unitId)) {
      for (final id in lesson.lexemeIds) {
        if (seen.add(id)) {
          final lex = _lexemes[id];
          if (lex != null) result.add(lex);
        }
      }
    }
    return result;
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
