import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/lexeme.dart';

/// The very first thing a learner sees about a new word (Abschnitt 6, step
/// 1): no way to get it wrong, just "Weiter".
class IntroCard extends StatelessWidget {
  final Lexeme lexeme;
  final String locale;
  final bool showFidel;
  final VoidCallback? onPlayAudio;
  final VoidCallback onContinue;

  const IntroCard({
    super.key,
    required this.lexeme,
    required this.locale,
    this.showFidel = false,
    this.onPlayAudio,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (lexeme.emoji.isNotEmpty) Text(lexeme.emoji, style: const TextStyle(fontSize: 64)),
        const SizedBox(height: 16),
        if (showFidel) ...[
          Text(lexeme.am, style: theme.textTheme.displaySmall),
          const SizedBox(height: 4),
        ],
        Text(lexeme.tr, style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          lexeme.t[locale] ?? '',
          style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),
          textAlign: TextAlign.center,
        ),
        if ((lexeme.hint[locale] ?? '').isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              lexeme.hint[locale]!,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        const SizedBox(height: 24),
        IconButton.filledTonal(
          iconSize: 28,
          tooltip: l10n.audioPlayTooltip,
          onPressed: onPlayAudio,
          icon: const Icon(Icons.volume_up),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: onContinue, child: Text(l10n.introCardContinue)),
        ),
      ],
    );
  }
}
