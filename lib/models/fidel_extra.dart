/// A non-syllabic Fidel sign: a numeral, a punctuation mark, one of the
/// labialized forms, or another marginal special sign (Stufe 7). Simpler
/// than [FidelChar] because these don't belong to the 33x7 vowel-order
/// table.
class FidelExtra {
  final String char;
  final String tr;
  final String category; // 'numerals' | 'punctuation' | 'labialized' | 'other'
  final String? nameKey; // l10n key for punctuation display names
  final bool verified;

  /// Stable, ASCII-only id for audio lookup (Etappe 24) - explicit in the
  /// JSON (unlike [FidelChar.audioId]) since there's no `group`+`order`
  /// composite key here to derive one from safely.
  final String id;

  const FidelExtra({
    required this.char,
    required this.tr,
    required this.category,
    required this.id,
    this.nameKey,
    this.verified = true,
  });

  factory FidelExtra.fromJson(Map<String, dynamic> json, {required String category}) {
    return FidelExtra(
      char: json['char'] as String,
      tr: json['tr'] as String,
      category: category,
      id: json['id'] as String,
      nameKey: json['nameKey'] as String?,
      verified: json['verified'] as bool? ?? true,
    );
  }
}
