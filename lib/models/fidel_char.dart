/// One sign of the Fidel syllabary: a consonant ("base") in one of the seven
/// vowel orders.
class FidelChar {
  final String char;
  final String base; // the consonant sound this sign belongs to, e.g. "l"

  /// Unique id of the traditional row this sign belongs to. Several rows can
  /// share the same [base] sound (e.g. ሀ/ሐ/ኀ are all "h") while still being
  /// distinct rows in the 33x7 table - this field keeps them apart.
  final String group;

  final int order; // 1-7, the vowel order (ordnung)
  final String tr; // transliteration, e.g. "le"
  final String ipa;
  final String? exampleLexemeId;

  /// False when this sign's shape does not follow the regular pattern for
  /// its order - the app must call this out explicitly instead of pretending
  /// every row is perfectly regular.
  final bool regular;

  const FidelChar({
    required this.char,
    required this.base,
    required this.group,
    required this.order,
    required this.tr,
    required this.ipa,
    this.exampleLexemeId,
    this.regular = true,
  });

  /// Stable, ASCII-only id for audio lookup (Etappe 24) - `group`+`order`
  /// is already a unique composite key in fidel.json, so this needs no new
  /// data field. Never derived from [char]/[tr]: those can contain
  /// characters that don't survive round-tripping through a filename or a
  /// zip file untouched.
  String get audioId => 'fidel_${group}_$order';

  factory FidelChar.fromJson(Map<String, dynamic> json) {
    return FidelChar(
      char: json['char'] as String,
      base: json['base'] as String,
      group: json['group'] as String? ?? json['base'] as String,
      order: json['order'] as int,
      tr: json['tr'] as String,
      ipa: json['ipa'] as String? ?? '',
      exampleLexemeId: json['exampleLexemeId'] as String?,
      regular: json['regular'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'char': char,
        'base': base,
        'group': group,
        'order': order,
        'tr': tr,
        'ipa': ipa,
        'exampleLexemeId': exampleLexemeId,
        'regular': regular,
      };
}
