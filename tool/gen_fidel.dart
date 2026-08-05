// Generates assets/content/fidel.json from a compact 33x7 table instead of
// hand-writing 231 JSON objects - the table below is the only place the
// actual glyphs are typed, everything else (transliteration, ipa, ids) is
// derived mechanically from it. Run with: dart run tool/gen_fidel.dart
//
// WICHTIG (siehe PRUEFLISTE.md): Diese Tafel wurde nach bestem Wissen
// zusammengestellt, aber die Zeichen für die selteneren Reihen (ኀ, ኸ, ዠ, ጰ)
// und die beiden "a"-Reihen sollten von einer Muttersprachlerin/einem
// Muttersprachler gegengelesen werden, bevor man sich vollständig darauf
// verlässt.
import 'dart:convert';
import 'dart:io';

class FidelRow {
  final String group; // unique row id
  final String base; // phonetic consonant used for transliteration/ipa
  final String glyphs; // exactly 7 characters, order 1..7
  final bool regular;
  final String consonantIpa;

  const FidelRow(this.group, this.base, this.glyphs, this.consonantIpa, {this.regular = true});
}

// Order 1..7 vowel suffixes for the learner-facing transliteration, exactly
// as given in Abschnitt 4 of the Auftrag (order 1 and 5 both spell "e" -
// that is intentional, not a typo, per the spec's own l-row example).
const vowelSuffix = ['e', 'u', 'i', 'a', 'e', '', 'o'];
const vowelIpa = ['ə', 'u', 'i', 'a', 'e', '', 'o'];

final rows = <FidelRow>[
  const FidelRow('ha', 'h', 'ሀሁሂሃሄህሆ', 'h'),
  const FidelRow('la', 'l', 'ለሉሊላሌልሎ', 'l'),
  const FidelRow('hha', 'h', 'ሐሑሒሓሔሕሖ', 'h'),
  const FidelRow('ma', 'm', 'መሙሚማሜምሞ', 'm'),
  const FidelRow('sza', 's', 'ሠሡሢሣሤሥሦ', 's'),
  const FidelRow('ra', 'r', 'ረሩሪራሬርሮ', 'r'),
  const FidelRow('sa', 's', 'ሰሱሲሳሴስሶ', 's'),
  const FidelRow('sha', 'sh', 'ሸሹሺሻሼሽሾ', 'ʃ'),
  const FidelRow('qa', "k'", 'ቀቁቂቃቄቅቆ', "kʼ"),
  const FidelRow('ba', 'b', 'በቡቢባቤብቦ', 'b'),
  const FidelRow('ta', 't', 'ተቱቲታቴትቶ', 't'),
  const FidelRow('cha', 'ch', 'ቸቹቺቻቼችቾ', 'tʃ'),
  const FidelRow('hha2', 'h', 'ኀኁኂኃኄኅኆ', 'h', regular: false),
  const FidelRow('na', 'n', 'ነኑኒናኔንኖ', 'n'),
  const FidelRow('gna', 'gn', 'ኘኙኚኛኜኝኞ', 'ɲ'),
  const FidelRow('aa', 'a', 'አኡኢኣኤእኦ', 'ʔ', regular: false),
  const FidelRow('ka', 'k', 'ከኩኪካኬክኮ', 'k'),
  const FidelRow('kha', 'kh', 'ኸኹኺኻኼኽኾ', 'x', regular: false),
  const FidelRow('wa', 'w', 'ወዉዊዋዌውዎ', 'w'),
  const FidelRow('aa2', 'a', 'ዐዑዒዓዔዕዖ', 'ʔ', regular: false),
  const FidelRow('za', 'z', 'ዘዙዚዛዜዝዞ', 'z'),
  const FidelRow('zha', 'zh', 'ዠዡዢዣዤዥዦ', 'ʒ', regular: false),
  const FidelRow('ya', 'y', 'የዩዪያዬይዮ', 'j'),
  const FidelRow('da', 'd', 'ደዱዲዳዴድዶ', 'd'),
  const FidelRow('ja', 'j', 'ጀጁጂጃጄጅጆ', 'dʒ'),
  const FidelRow('ga', 'g', 'ገጉጊጋጌግጎ', 'g'),
  const FidelRow('tta', "t'", 'ጠጡጢጣጤጥጦ', "tʼ"),
  const FidelRow('chha', "ch'", 'ጨጩጪጫጬጭጮ', "tʃʼ"),
  const FidelRow('ppa', "p'", 'ጰጱጲጳጴጵጶ', "pʼ", regular: false),
  const FidelRow('tsa', "s'", 'ጸጹጺጻጼጽጾ', "sʼ"),
  const FidelRow('tsa2', "s'", 'ፀፁፂፃፄፅፆ', "sʼ"),
  const FidelRow('fa', 'f', 'ፈፉፊፋፌፍፎ', 'f'),
  const FidelRow('pa', 'p', 'ፐፑፒፓፔፕፖ', 'p'),
];

String trFor(String base, int orderIndex) {
  final suffix = vowelSuffix[orderIndex];
  if (base.endsWith("'")) {
    // ejective consonants keep the apostrophe attached to the consonant
    return suffix.isEmpty ? base : '$base$suffix';
  }
  return '$base$suffix';
}

void main() {
  if (rows.length != 33) {
    stderr.writeln('Expected 33 rows, got ${rows.length}');
    exit(1);
  }

  final entries = <Map<String, dynamic>>[];
  for (final row in rows) {
    final chars = row.glyphs.runes.map(String.fromCharCode).toList();
    if (chars.length != 7) {
      stderr.writeln('Row ${row.group} does not have exactly 7 glyphs: ${row.glyphs}');
      exit(1);
    }
    for (var i = 0; i < 7; i++) {
      entries.add({
        'char': chars[i],
        'base': row.base,
        'group': row.group,
        'order': i + 1,
        'tr': trFor(row.base, i),
        'ipa': '${row.consonantIpa}${vowelIpa[i]}',
        'exampleLexemeId': null,
        'regular': row.regular,
      });
    }
  }

  if (entries.length != 231) {
    stderr.writeln('Expected 231 entries, got ${entries.length}');
    exit(1);
  }

  final uniqueChars = entries.map((e) => e['char']).toSet();
  if (uniqueChars.length != 231) {
    stderr.writeln('Duplicate glyphs found! Only ${uniqueChars.length} unique chars.');
    exit(1);
  }

  const encoder = JsonEncoder.withIndent('  ');
  File('assets/content/fidel.json').writeAsStringSync(encoder.convert(entries));
  stdout.writeln('Wrote 231 Fidel characters to assets/content/fidel.json');
}
