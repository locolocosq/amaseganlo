// Sibling of export_audio_worklist_test.dart (see that file for the general
// rationale), scoped to Tigrinya instead of Amharic - Etappe 28 Nachtrag 4:
// no mainstream TTS provider (Azure/edge-tts, Amazon Polly, Google Cloud)
// has a real Tigrinya voice, so this feeds Meta's research MMS-TTS model
// (facebook/mms-tts-tir) via tool/generate_audio_colab_ti.py instead of the
// Amharic edge-tts pipeline - a different script for a different, lower-
// resource language, not a variant of the Amharic one.
// Writes tool/audio_worklist_ti.csv with columns: id,kind,amharic (column
// name kept as "amharic" for format compatibility with the shared Colab
// upload/parsing code - it holds the Ge'ez-script text regardless of
// language).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/content/content_repository.dart';

String _csvEscape(String s) => '"${s.replaceAll('"', '""')}"';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('exports every Tigrinya lexeme/sentence id without a recording yet to tool/audio_worklist_ti.csv', () async {
    final repo = ContentRepository();
    await repo.load();

    final tigrinyaLexemeIds = <String>{};
    final tigrinyaSentenceIds = <String>{};
    for (final section in repo.curriculum.sections) {
      if (section.language != 'ti') continue;
      for (final unitId in section.unitIds) {
        for (final lesson in repo.lessonsForUnit(unitId)) {
          tigrinyaLexemeIds.addAll(lesson.lexemeIds);
          tigrinyaSentenceIds.addAll(lesson.sentenceIds);
        }
      }
    }

    final existingIds = Directory('assets/audio/words')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.mp3'))
        .map((f) {
          final name = f.uri.pathSegments.last;
          return name.substring(0, name.length - '.mp3'.length);
        })
        .toSet();

    final buffer = StringBuffer('id,kind,amharic\n');
    var written = 0;
    void writeRow(String id, String kind, String text) {
      if (existingIds.contains(id)) return;
      buffer.writeln('${_csvEscape(id)},$kind,${_csvEscape(text)}');
      written++;
    }

    for (final lex in repo.allLexemes) {
      if (!tigrinyaLexemeIds.contains(lex.id)) continue;
      writeRow(lex.id, 'word', lex.am);
    }
    for (final sentence in repo.allSentences) {
      if (!tigrinyaSentenceIds.contains(sentence.id)) continue;
      writeRow(sentence.id, 'sentence', sentence.am);
    }

    final file = File('tool/audio_worklist_ti.csv');
    await file.writeAsString(buffer.toString());

    expect(file.existsSync(), isTrue);
    // ignore: avoid_print
    print('Wrote $written Tigrinya id(s) still missing a recording to ${file.path} (${existingIds.length} already exist).');
  });
}
