/// A single learnable vocabulary item ("Lexem").
class Lexeme {
  final String id;
  final String am; // Ethiopic script
  final String tr; // Latin transliteration
  final String pos; // part of speech
  final String topic;
  final String level;
  final Map<String, String> t; // translations: locale code -> text
  final Map<String, String> hint; // usage hints: locale code -> text
  final Map<String, List<String>> alt; // alternate valid translations per locale
  final String emoji;
  final bool verified;

  const Lexeme({
    required this.id,
    required this.am,
    required this.tr,
    required this.pos,
    required this.topic,
    required this.level,
    required this.t,
    this.hint = const {},
    this.alt = const {},
    this.emoji = '',
    this.verified = false,
  });

  /// All acceptable translations for a locale: the primary one plus alternates.
  List<String> acceptedTranslations(String locale) {
    final primary = t[locale];
    final alternates = alt[locale] ?? const [];
    return [?primary, ...alternates];
  }

  factory Lexeme.fromJson(Map<String, dynamic> json) {
    return Lexeme(
      id: json['id'] as String,
      am: json['am'] as String,
      tr: json['tr'] as String,
      pos: json['pos'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      level: json['level'] as String? ?? '',
      t: Map<String, String>.from(json['t'] as Map? ?? const {}),
      hint: Map<String, String>.from(json['hint'] as Map? ?? const {}),
      alt: (json['alt'] as Map?)?.map(
            (k, v) => MapEntry(k as String, List<String>.from(v as List)),
          ) ??
          const {},
      emoji: json['emoji'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'am': am,
        'tr': tr,
        'pos': pos,
        'topic': topic,
        'level': level,
        't': t,
        'hint': hint,
        'alt': alt,
        'emoji': emoji,
        'verified': verified,
      };
}
