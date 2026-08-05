/// A non-syllabic Fidel sign: a numeral, a punctuation mark, or one of the
/// labialized forms (Stufe 7). Simpler than [FidelChar] because these don't
/// belong to the 33x7 vowel-order table.
class FidelExtra {
  final String char;
  final String tr;
  final String category; // 'numerals' | 'punctuation' | 'labialized'
  final String? nameKey; // l10n key for punctuation display names
  final bool verified;

  const FidelExtra({
    required this.char,
    required this.tr,
    required this.category,
    this.nameKey,
    this.verified = true,
  });

  factory FidelExtra.fromJson(Map<String, dynamic> json, {required String category}) {
    return FidelExtra(
      char: json['char'] as String,
      tr: json['tr'] as String,
      category: category,
      nameKey: json['nameKey'] as String?,
      verified: json['verified'] as bool? ?? true,
    );
  }
}
