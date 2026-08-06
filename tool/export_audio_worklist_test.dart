// One-off export for handing the full Amharic word/sentence list to an
// external TTS pipeline (see ENTSCHEIDUNGEN.md) - not part of the regular
// test suite, run explicitly with
// `flutter test tool/export_audio_worklist_test.dart`.
// Writes tool/audio_worklist.csv with columns: id,kind,amharic
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/content/content_repository.dart';

String _csvEscape(String s) => '"${s.replaceAll('"', '""')}"';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('exports every lexeme/sentence id + Amharic text to tool/audio_worklist.csv', () async {
    final repo = ContentRepository();
    await repo.load();

    final buffer = StringBuffer('id,kind,amharic\n');
    for (final lex in repo.allLexemes) {
      buffer.writeln('${_csvEscape(lex.id)},word,${_csvEscape(lex.am)}');
    }
    for (final sentence in repo.allSentences) {
      buffer.writeln('${_csvEscape(sentence.id)},sentence,${_csvEscape(sentence.am)}');
    }

    final file = File('tool/audio_worklist.csv');
    await file.writeAsString(buffer.toString());

    expect(file.existsSync(), isTrue);
    // ignore: avoid_print
    print('Wrote ${repo.allLexemes.length} words + ${repo.allSentences.length} sentences to ${file.path}');
  });
}
