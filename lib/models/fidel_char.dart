/// One sign of the Fidel syllabary: a consonant ("base") in one of the seven
/// vowel orders.
class FidelChar {
  final String char;
  final String base; // the consonant this sign belongs to, e.g. "l"
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
    required this.order,
    required this.tr,
    required this.ipa,
    this.exampleLexemeId,
    this.regular = true,
  });

  factory FidelChar.fromJson(Map<String, dynamic> json) {
    return FidelChar(
      char: json['char'] as String,
      base: json['base'] as String,
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
        'order': order,
        'tr': tr,
        'ipa': ipa,
        'exampleLexemeId': exampleLexemeId,
        'regular': regular,
      };
}
