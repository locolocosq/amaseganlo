/// Result of checking a typed answer against the accepted answers.
class AnswerCheckResult {
  final bool isCorrect;
  final bool isAlmost;
  final String closestAccepted;

  const AnswerCheckResult({
    required this.isCorrect,
    required this.isAlmost,
    required this.closestAccepted,
  });
}

/// Implements the "freundlich streng" answer checking from Abschnitt 9:
/// case/whitespace/punctuation are ignored, Amharic transliteration
/// apostrophe/spelling variants are tolerated, articles are optional for
/// Germanic target languages, and a single-character typo on a word of 5+
/// letters still counts as correct with a spelling hint.
class AnswerChecker {
  AnswerChecker._();

  static const Map<String, List<String>> _articlesByLocale = {
    'de': ['der', 'die', 'das', 'ein', 'eine', 'einen', 'einem', 'einer'],
    'en': ['the', 'a', 'an'],
    'sv': ['en', 'ett', 'den', 'det'],
    'nl': ['de', 'het', 'een'],
    'it': ['il', 'lo', 'la', 'i', 'gli', 'le', 'un', 'uno', 'una', "l'"],
    'es': ['el', 'la', 'los', 'las', 'un', 'una', 'unos', 'unas'],
  };

  static List<String> articlesFor(String locale) => _articlesByLocale[locale] ?? const [];

  static AnswerCheckResult checkTransliteration(String input, List<String> acceptedAnswers) {
    return check(input: input, acceptedAnswers: acceptedAnswers, transliterationTolerance: true);
  }

  static AnswerCheckResult checkTranslation(String input, List<String> acceptedAnswers, String locale) {
    return check(input: input, acceptedAnswers: acceptedAnswers, articles: articlesFor(locale));
  }

  static AnswerCheckResult check({
    required String input,
    required List<String> acceptedAnswers,
    bool transliterationTolerance = false,
    List<String> articles = const [],
  }) {
    if (acceptedAnswers.isEmpty) {
      return const AnswerCheckResult(isCorrect: false, isAlmost: false, closestAccepted: '');
    }

    final normalizedInput = _normalize(input, transliterationTolerance: transliterationTolerance, articles: articles);

    for (final accepted in acceptedAnswers) {
      final normalizedAccepted = _normalize(accepted, transliterationTolerance: transliterationTolerance, articles: articles);
      if (normalizedInput.isNotEmpty && normalizedInput == normalizedAccepted) {
        return AnswerCheckResult(isCorrect: true, isAlmost: false, closestAccepted: accepted);
      }
    }

    String? bestMatch;
    int bestDistance = 999;
    for (final accepted in acceptedAnswers) {
      final normalizedAccepted = _normalize(accepted, transliterationTolerance: transliterationTolerance, articles: articles);
      if (normalizedAccepted.length < 5) continue;
      final distance = levenshteinDistance(normalizedInput, normalizedAccepted);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestMatch = accepted;
      }
    }
    if (bestMatch != null && bestDistance == 1) {
      return AnswerCheckResult(isCorrect: true, isAlmost: true, closestAccepted: bestMatch);
    }

    return AnswerCheckResult(isCorrect: false, isAlmost: false, closestAccepted: acceptedAnswers.first);
  }

  static String _normalize(String input, {required bool transliterationTolerance, required List<String> articles}) {
    var result = input.trim().toLowerCase();
    result = result.replaceAll(RegExp(r'\s+'), ' ');
    result = result.replaceAll(RegExp(r'[.!?,;:։፡፣፤፥፧፨]+$'), '').trim();

    for (final article in articles) {
      // Italian/elided articles like "l'" attach directly to the next word
      // with no space (l'acqua, un'idea) - every other supported locale's
      // articles are always followed by a space.
      final prefix = article.endsWith("'") ? article : '$article ';
      if (result.startsWith(prefix)) {
        result = result.substring(prefix.length);
        break;
      }
    }

    if (transliterationTolerance) {
      result = _canonicalizeTransliteration(result);
    }

    return result.trim();
  }

  static String _canonicalizeTransliteration(String input) {
    var result = input.replaceAll("'", '');
    result = result.replaceAll('ph', 'f');
    result = result.replaceAll('ts', 's');
    result = result.replaceAll('q', 'k');
    return result;
  }

  static int levenshteinDistance(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    var previousRow = List<int>.generate(b.length + 1, (i) => i);
    var currentRow = List<int>.filled(b.length + 1, 0);

    for (var i = 1; i <= a.length; i++) {
      currentRow[0] = i;
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        final deletion = previousRow[j] + 1;
        final insertion = currentRow[j - 1] + 1;
        final substitution = previousRow[j - 1] + cost;
        currentRow[j] = [deletion, insertion, substitution].reduce((x, y) => x < y ? x : y);
      }
      final tmp = previousRow;
      previousRow = currentRow;
      currentRow = tmp;
    }

    return previousRow[b.length];
  }
}
