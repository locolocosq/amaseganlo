// Generates assets/content/fidel_stufe3_lessons.json: one rowLesson per
// Fidel row (traditional order, matching gen_fidel.dart's table) plus a
// blockTest every 3 rows. Run with: dart run tool/gen_fidel_stufe3.dart
import 'dart:convert';
import 'dart:io';

const groups = [
  'ha', 'la', 'hha', 'ma', 'sza', 'ra', 'sa', 'sha', 'qa', 'ba', 'ta', 'cha',
  'hha2', 'na', 'gna', 'aa', 'ka', 'kha', 'wa', 'aa2', 'za', 'zha', 'ya',
  'da', 'ja', 'ga', 'tta', 'chha', 'ppa', 'tsa', 'tsa2', 'fa', 'pa',
];

void main() {
  if (groups.length != 33) {
    stderr.writeln('Expected 33 groups, got ${groups.length}');
    exit(1);
  }

  final lessons = <Map<String, dynamic>>[];
  final currentBlock = <String>[];

  for (var i = 0; i < groups.length; i++) {
    final group = groups[i];
    lessons.add({
      'id': 'f3_row_$group',
      'kind': 'rowLesson',
      'groupIds': [group],
      'exerciseTypes': ['fidelOrderRecognition', 'fidelSoundToChar', 'fidelCharToSound'],
    });
    currentBlock.add(group);

    if (currentBlock.length == 3) {
      final blockNumber = (i ~/ 3) + 1;
      lessons.add({
        'id': 'f3_block$blockNumber',
        'kind': 'blockTest',
        'groupIds': List<String>.from(currentBlock),
        'exerciseTypes': ['fidelOrderRecognition', 'fidelSoundToChar'],
      });
      currentBlock.clear();
    }
  }

  const encoder = JsonEncoder.withIndent('  ');
  File('assets/content/fidel_stufe3_lessons.json').writeAsStringSync(encoder.convert(lessons));
  stdout.writeln('Wrote ${lessons.length} Stufe-3 lessons (33 rows + 11 block tests).');
}
