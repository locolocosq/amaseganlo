// One-off export for handing the full Amharic word/sentence/Fidel-sign list
// to an external TTS pipeline (see ENTSCHEIDUNGEN.md) - not part of the
// regular test suite, run explicitly with
// `flutter test tool/export_audio_worklist_test.dart`.
// Writes tool/audio_worklist.csv with columns: id,kind,amharic
//
// Etappe 24: extended to also cover the Fidel table - every syllable is a
// single Ge'ez character, which (unlike a random symbol) already *is* a
// full, well-formed spoken syllable, so feeding it straight to the same
// Amharic TTS pipeline as a word works the same way. Numerals (፩,፳,...) and
// punctuation (፡,።,...) are deliberately left out here: those aren't
// syllables with a natural single-word pronunciation the way a letter or a
// vocabulary word is, and generic TTS reading a bare punctuation glyph
// aloud is unlikely to produce anything useful - revisit only if that's
// specifically wanted later.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/content/content_repository.dart';

String _csvEscape(String s) => '"${s.replaceAll('"', '""')}"';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('exports every lexeme/sentence/Fidel-sign id + Amharic text to tool/audio_worklist.csv', () async {
    final repo = ContentRepository();
    await repo.load();

    final buffer = StringBuffer('id,kind,amharic\n');
    for (final lex in repo.allLexemes) {
      buffer.writeln('${_csvEscape(lex.id)},word,${_csvEscape(lex.am)}');
    }
    for (final sentence in repo.allSentences) {
      buffer.writeln('${_csvEscape(sentence.id)},sentence,${_csvEscape(sentence.am)}');
    }
    for (final char in repo.allFidelChars) {
      buffer.writeln('${_csvEscape(char.audioId)},fidel,${_csvEscape(char.char)}');
    }
    const audibleExtraCategories = {'labialized', 'other'};
    var extraCount = 0;
    for (final category in audibleExtraCategories) {
      for (final extra in repo.fidelExtrasForCategory(category)) {
        buffer.writeln('${_csvEscape(extra.id)},fidel,${_csvEscape(extra.char)}');
        extraCount++;
      }
    }

    final file = File('tool/audio_worklist.csv');
    await file.writeAsString(buffer.toString());

    expect(file.existsSync(), isTrue);
    // ignore: avoid_print
    print(
      'Wrote ${repo.allLexemes.length} words + ${repo.allSentences.length} sentences + '
      '${repo.allFidelChars.length} Fidel signs + $extraCount Fidel extras to ${file.path}',
    );
  });
}
