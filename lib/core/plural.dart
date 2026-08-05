import '../l10n/app_localizations.dart';

/// "1 Wort" vs "{n} Wörter" - kept as a plain helper instead of ARB ICU
/// plural syntax, since this Flutter SDK's l10n generator silently falls
/// back to non-pluralized string interpolation when it fails to parse a
/// `{count, plural, ...}` message (no build error, just wrong output),
/// which this project's toolchain hit even for the syntax straight out of
/// the Flutter docs. Two plain ARB keys sidestep that entirely.
String wordCountLabel(AppLocalizations l10n, int count) =>
    count == 1 ? l10n.reviewWordCountOne : l10n.reviewWordCount(count);
