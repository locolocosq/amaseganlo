/// A short sentence built from already-introduced lexemes.
class Sentence {
  final String id;
  final String am;
  final String tr;
  final String level;
  final List<String> uses; // lexeme ids referenced in this sentence
  final Map<String, String> t;
  final Map<String, List<String>> alt;
  final List<String> chunks; // tappable word chunks, in correct order
  final bool verified;

  const Sentence({
    required this.id,
    required this.am,
    required this.tr,
    required this.level,
    required this.uses,
    required this.t,
    this.alt = const {},
    required this.chunks,
    this.verified = false,
  });

  List<String> acceptedTranslations(String locale) {
    final primary = t[locale];
    final alternates = alt[locale] ?? const [];
    return [?primary, ...alternates];
  }

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      id: json['id'] as String,
      am: json['am'] as String,
      tr: json['tr'] as String,
      level: json['level'] as String? ?? '',
      uses: List<String>.from(json['uses'] as List? ?? const []),
      t: Map<String, String>.from(json['t'] as Map? ?? const {}),
      alt: (json['alt'] as Map?)?.map(
            (k, v) => MapEntry(k as String, List<String>.from(v as List)),
          ) ??
          const {},
      chunks: List<String>.from(json['chunks'] as List? ?? const []),
      verified: json['verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'am': am,
        'tr': tr,
        'level': level,
        'uses': uses,
        't': t,
        'alt': alt,
        'chunks': chunks,
        'verified': verified,
      };
}
