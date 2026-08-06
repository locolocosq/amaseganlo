// One-off builder for assets/audio/manifest.json from the .mp3 files under
// assets/audio/words/ (see ENTSCHEIDUNGEN.md, externally generated via
// tool/generate_audio_colab.py). Not part of the regular test suite, run
// explicitly with `flutter test tool/build_audio_manifest_test.dart`
// whenever the audio set changes.
//
// Cross-checks the file set against ContentRepository so a mismatch (a
// renamed lexeme id, a leftover file for a word that no longer exists,
// or a word that's still missing its recording) is caught here instead of
// silently producing a manifest with dead entries.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/content/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('builds assets/audio/manifest.json from assets/audio/words/*.mp3', () async {
    final repo = ContentRepository();
    await repo.load();

    final expectedIds = {
      for (final lex in repo.allLexemes) lex.id,
      for (final sentence in repo.allSentences) sentence.id,
    };

    final wordsDir = Directory('assets/audio/words');
    final files = wordsDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.mp3'))
        .toList();

    final fileIds = <String>{};
    final words = <String, String>{};
    for (final file in files) {
      final name = file.uri.pathSegments.last;
      final id = name.substring(0, name.length - '.mp3'.length);
      fileIds.add(id);
      words[id] = 'audio/words/$name';
    }

    final missing = expectedIds.difference(fileIds);
    final extra = fileIds.difference(expectedIds);
    // ignore: avoid_print
    print('${words.length} Audiodateien gefunden.');
    // ignore: avoid_print
    print('${missing.length} Wörter/Sätze ohne Aufnahme: ${missing.take(20).join(', ')}'
        '${missing.length > 20 ? ', ...' : ''}');
    // ignore: avoid_print
    print('${extra.length} Aufnahmen ohne passendes Wort/Satz: ${extra.take(20).join(', ')}'
        '${extra.length > 20 ? ', ...' : ''}');

    final manifest = {
      'words': words,
      'feedback': {'correct': null, 'incorrect': null},
    };

    final encoder = JsonEncoder.withIndent('  ');
    await File('assets/audio/manifest.json').writeAsString(encoder.convert(manifest));

    expect(fileIds, isNotEmpty);
  });
}
