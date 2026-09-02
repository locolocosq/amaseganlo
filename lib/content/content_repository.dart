import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../models/curriculum.dart';
import '../models/fidel_char.dart';
import '../models/fidel_extra.dart';
import '../models/fidel_lesson.dart';
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
  List<FidelChar> _fidelChars = const [];
  List<FidelStage> _fidelStages = const [];
  final Map<String, List<FidelLesson>> _fidelLessonsByStage = {};
  List<FidelExtra> _fidelExtras = const [];

  Curriculum get curriculum => _curriculum;
  List<String> get failedUnitIds => _failedUnitIds.toList();

  /// Loads every content file concurrently within each group (Etappe 29
  /// Nachtrag) rather than one `await` at a time. On native platforms
  /// `rootBundle.loadString` reads a locally bundled asset, so awaiting ~870
  /// files sequentially cost nothing noticeable - but on web each call is a
  /// real HTTP round-trip to the server, and awaiting them one by one meant
  /// the whole first load queued up ~870 round-trips back to back (tens of
  /// seconds on a cold GitHub Pages load, confirmed live). `Future.wait`
  /// lets the browser fire them all at once and pipeline them over HTTP/2
  /// instead. Groups that depend on an earlier file (unit/stage lists coming
  /// from curriculum.json/fidel_curriculum.json) still await that file
  /// first - only the independent files within a group run concurrently.
  /// Per-file error isolation (a broken file just adds a warning, Abschnitt
  /// 6) is unchanged; concurrent futures each catch their own error, so one
  /// bad file still can't fail the others.
  Future<void> load() async {
    try {
      final raw = await _bundle.loadString('assets/content/curriculum.json');
      _curriculum = Curriculum.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      loadWarnings.add('curriculum.json konnte nicht geladen werden: $e');
      return;
    }

    await Future.wait([
      _loadLexemeFiles(),
      _loadSentenceFiles(),
      _loadUnitLessonFiles(),
      _loadFidelChars(),
      _loadFidelExtras(),
    ]);

    List<FidelStage> stages;
    try {
      final raw = await _bundle.loadString('assets/content/fidel_curriculum.json');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      stages = [
        for (final s in (map['stages'] as List)) FidelStage.fromJson(s as Map<String, dynamic>),
      ];
    } catch (e) {
      loadWarnings.add('fidel_curriculum.json konnte nicht geladen werden: $e');
      return;
    }
    _fidelStages = stages;

    await Future.wait(stages.map(_loadOneFidelStage));
  }

  Future<void> _loadLexemeFiles() async {
    await Future.wait(_curriculum.lexemeFiles.map((file) async {
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
    }));
  }

  Future<void> _loadSentenceFiles() async {
    await Future.wait(_curriculum.sentenceFiles.map((file) async {
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
    }));
  }

  Future<void> _loadUnitLessonFiles() async {
    await Future.wait(_curriculum.units.map((unit) async {
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
    }));
  }

  Future<void> _loadFidelChars() async {
    try {
      final raw = await _bundle.loadString('assets/content/fidel.json');
      final list = jsonDecode(raw) as List;
      _fidelChars = [for (final item in list) FidelChar.fromJson(item as Map<String, dynamic>)];
    } catch (e) {
      loadWarnings.add('fidel.json konnte nicht geladen werden: $e');
    }
  }

  Future<void> _loadFidelExtras() async {
    try {
      final raw = await _bundle.loadString('assets/content/fidel_extras.json');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _fidelExtras = [
        for (final category in map.keys)
          for (final item in (map[category] as List))
            FidelExtra.fromJson(item as Map<String, dynamic>, category: category),
      ];
    } catch (e) {
      loadWarnings.add('fidel_extras.json konnte nicht geladen werden: $e');
    }
  }

  Future<void> _loadOneFidelStage(FidelStage stage) async {
    try {
      final raw = await _bundle.loadString('assets/content/${stage.lessonFile}');
      final list = jsonDecode(raw) as List;
      _fidelLessonsByStage[stage.id] = [
        for (final item in list) FidelLesson.fromJson(item as Map<String, dynamic>, stageId: stage.id),
      ];
    } catch (e) {
      loadWarnings.add('Fidel-Stufe "${stage.id}" konnte nicht geladen werden und wird übersprungen: $e');
    }
  }

  List<FidelExtra> fidelExtrasForCategory(String category) => _fidelExtras.where((e) => e.category == category).toList();

  List<FidelExtra> get allFidelExtras => _fidelExtras;

  static const _alwaysReadable = {' ', '፡', '።', '፣', '፤', '፥', '፧', '፨', '?'};

  bool _isDecodableWith(String text, Set<String> learnedChars) {
    for (final rune in text.runes) {
      final ch = String.fromCharCode(rune);
      if (ch.trim().isEmpty || _alwaysReadable.contains(ch)) continue;
      if (!learnedChars.contains(ch)) return false;
    }
    return true;
  }

  /// Which lexeme/sentence ids belong to an `am` (Amharic)-language section
  /// (Etappe 26) - the Fidel reading path (Stufe 5/6, "Lernweg A vocabulary")
  /// is specifically about the Amharic alphabet, so a Tigrinya word/sentence
  /// must never surface there even if its own signs happen to already be
  /// known from the (shared Ge'ez-derived) Amharic table. Computed once,
  /// lazily, the same pattern as [JourneyProgress]'s per-language unit
  /// grouping.
  late final Set<String> _amharicLexemeIds = _collectAmharicIds(lexemes: true);
  late final Set<String> _amharicSentenceIds = _collectAmharicIds(lexemes: false);

  Set<String> _collectAmharicIds({required bool lexemes}) {
    final result = <String>{};
    for (final section in _curriculum.sections) {
      if (section.language != 'am') continue;
      for (final unitId in section.unitIds) {
        for (final lesson in lessonsForUnit(unitId)) {
          result.addAll(lexemes ? lesson.lexemeIds : lesson.sentenceIds);
        }
      }
    }
    return result;
  }

  /// Stufe 5: a word may only appear here once every one of its signs is
  /// already learned in path B (Teil B checks this automatically).
  List<Lexeme> lexemesDecodableWith(Set<String> learnedChars) => allLexemes
      .where((l) => l.am.isNotEmpty && _amharicLexemeIds.contains(l.id) && _isDecodableWith(l.am, learnedChars))
      .toList();

  /// Stufe 6: same rule, for whole sentences.
  List<Sentence> sentencesDecodableWith(Set<String> learnedChars) => allSentences
      .where((s) => s.am.isNotEmpty && _amharicSentenceIds.contains(s.id) && _isDecodableWith(s.am, learnedChars))
      .toList();

  List<FidelStage> get fidelStages => _fidelStages;
  List<FidelLesson> fidelLessonsForStage(String stageId) => _fidelLessonsByStage[stageId] ?? const [];

  List<FidelChar> get allFidelChars => _fidelChars;

  FidelChar? fidelChar(String char) => _fidelChars.where((c) => c.char == char).firstOrNull;

  FidelExtra? fidelExtra(String char) => _fidelExtras.where((e) => e.char == char).firstOrNull;

  List<FidelChar> fidelCharsForGroup(String group) =>
      _fidelChars.where((c) => c.group == group).toList()..sort((a, b) => a.order.compareTo(b.order));

  List<String> get fidelGroupsInOrder {
    final seen = <String>[];
    for (final c in _fidelChars) {
      if (!seen.contains(c.group)) seen.add(c.group);
    }
    return seen;
  }

  /// "Schnell lesen": rows ordered by how often their signs actually appear
  /// in the learned vocabulary's Ethiopic text, most frequent first. With
  /// only a handful of sample words (Etappe 2/5 still growing) the order
  /// won't look meaningful yet - it becomes a real frequency order as the
  /// vocabulary grows, since it is computed from the actual content, not a
  /// fixed table.
  List<String> fidelGroupsByFrequency() {
    final combined = StringBuffer();
    for (final l in allLexemes) {
      combined.write(l.am);
    }
    for (final s in allSentences) {
      combined.write(s.am);
    }
    final text = combined.toString();

    final traditional = fidelGroupsInOrder;
    final counts = <String, int>{};
    for (final group in traditional) {
      var count = 0;
      for (final c in fidelCharsForGroup(group)) {
        count += text.split(c.char).length - 1;
      }
      counts[group] = count;
    }

    final result = List<String>.from(traditional);
    result.sort((a, b) {
      final diff = (counts[b] ?? 0).compareTo(counts[a] ?? 0);
      if (diff != 0) return diff;
      return traditional.indexOf(a).compareTo(traditional.indexOf(b));
    });
    return result;
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

  /// Sentences used anywhere in a unit's lessons, in lesson order,
  /// de-duplicated - the sentence-side equivalent of [lexemesForUnit],
  /// added for the cumulative region-review station (Etappe 22).
  List<Sentence> sentencesForUnit(String unitId) {
    final seen = <String>{};
    final result = <Sentence>[];
    for (final lesson in lessonsForUnit(unitId)) {
      for (final id in lesson.sentenceIds) {
        if (seen.add(id)) {
          final sentence = _sentences[id];
          if (sentence != null) result.add(sentence);
        }
      }
    }
    return result;
  }

  /// All lexemes taught in [sectionIds] (typically every section up to and
  /// including the current one) - the word pool for the cumulative
  /// "Freies Wiederholen" station at the end of each region (Etappe 22).
  List<Lexeme> lexemesForSections(Iterable<String> sectionIds) {
    final seen = <String>{};
    final result = <Lexeme>[];
    for (final sectionId in sectionIds) {
      final section = _curriculum.sections.where((s) => s.id == sectionId).firstOrNull;
      if (section == null) continue;
      for (final unitId in section.unitIds) {
        for (final lex in lexemesForUnit(unitId)) {
          if (seen.add(lex.id)) result.add(lex);
        }
      }
    }
    return result;
  }

  /// The sentence-side equivalent of [lexemesForSections].
  List<Sentence> sentencesForSections(Iterable<String> sectionIds) {
    final seen = <String>{};
    final result = <Sentence>[];
    for (final sectionId in sectionIds) {
      final section = _curriculum.sections.where((s) => s.id == sectionId).firstOrNull;
      if (section == null) continue;
      for (final unitId in section.unitIds) {
        for (final sentence in sentencesForUnit(unitId)) {
          if (seen.add(sentence.id)) result.add(sentence);
        }
      }
    }
    return result;
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
