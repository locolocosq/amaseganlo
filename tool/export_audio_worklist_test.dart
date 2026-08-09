// One-off export for handing the Amharic word/sentence/Fidel-sign list that
// still needs a recording to an external TTS pipeline (see
// ENTSCHEIDUNGEN.md) - not part of the regular test suite, run explicitly
// with `flutter test tool/export_audio_worklist_test.dart`.
// Writes tool/audio_worklist.csv with columns: id,kind,amharic
//
// Etappe 24 Nachtrag: only writes ids that don't already have a file under
// assets/audio/words/ - the very first version of this script always wrote
// every id, which meant the Colab step re-synthesized all ~1057
// already-recorded words/sentences right alongside the actually-new Fidel
// signs, for no benefit (nothing about an existing recording needed to
// change) and a lot of wasted TTS time. Re-running this script later,
// after new content is added, now naturally picks up only what's actually
// missing - never needs to be told explicitly what's "new".
//
// Also covers the Fidel table: every syllable is a single Ge'ez character,
// which (unlike a random symbol) already *is* a full, well-formed spoken
// syllable, so feeding it straight to the same Amharic TTS pipeline as a
// word works the same way. Numerals (፩,፳,...) and punctuation (፡,።,...)
// are deliberately left out here: those aren't syllables with a natural
// single-word pronunciation the way a letter or a vocabulary word is, and
// generic TTS reading a bare punctuation glyph aloud is unlikely to
// produce anything useful - revisit only if that's specifically wanted
// later.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/content/content_repository.dart';

String _csvEscape(String s) => '"${s.replaceAll('"', '""')}"';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('exports every lexeme/sentence/Fidel-sign id without a recording yet to tool/audio_worklist.csv', () async {
    final repo = ContentRepository();
    await repo.load();

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
    void writeRow(String id, String kind, String amharic) {
      if (existingIds.contains(id)) return;
      buffer.writeln('${_csvEscape(id)},$kind,${_csvEscape(amharic)}');
      written++;
    }

    for (final lex in repo.allLexemes) {
      writeRow(lex.id, 'word', lex.am);
    }
    for (final sentence in repo.allSentences) {
      writeRow(sentence.id, 'sentence', sentence.am);
    }
    for (final char in repo.allFidelChars) {
      writeRow(char.audioId, 'fidel', char.char);
    }
    const audibleExtraCategories = {'labialized', 'other'};
    for (final category in audibleExtraCategories) {
      for (final extra in repo.fidelExtrasForCategory(category)) {
        writeRow(extra.id, 'fidel', extra.char);
      }
    }

    final file = File('tool/audio_worklist.csv');
    await file.writeAsString(buffer.toString());

    expect(file.existsSync(), isTrue);
    // ignore: avoid_print
    print('Wrote $written id(s) still missing a recording to ${file.path} (${existingIds.length} already exist).');
  });
}
