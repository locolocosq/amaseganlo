import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';

/// The bottom feedback bar shown after every answer (Abschnitt 8). Correct
/// and incorrect are always distinguished by icon and text, never by color
/// alone (Barrierefreiheit, C11).
class FeedbackBar extends StatelessWidget {
  final bool? isCorrect;
  final bool isAlmost;
  final bool isSkipped;
  final String? correctAnswerText;
  final String? hint;
  final VoidCallback onContinue;

  const FeedbackBar({
    super.key,
    required this.isCorrect,
    this.isAlmost = false,
    this.isSkipped = false,
    this.correctAnswerText,
    this.hint,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (isCorrect == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final correct = isCorrect!;
    final background = correct ? theme.colorScheme.primaryContainer : errorColor.withValues(alpha: 0.15);
    final foreground = correct ? theme.colorScheme.onPrimaryContainer : errorColor;

    final title = correct
        ? (isAlmost ? l10n.feedbackAlmostCorrect(correctAnswerText ?? '') : l10n.feedbackCorrect)
        : l10n.feedbackIncorrect;

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: background, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(correct ? Icons.check_circle : Icons.cancel, color: foreground),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium?.copyWith(color: foreground, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              if (!correct && correctAnswerText != null && correctAnswerText!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(l10n.feedbackCorrectAnswerWas(correctAnswerText!), style: theme.textTheme.bodyMedium?.copyWith(color: foreground)),
              ],
              if (hint != null && hint!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(hint!, style: theme.textTheme.bodySmall?.copyWith(color: foreground)),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: foreground, foregroundColor: theme.colorScheme.surface),
                  onPressed: onContinue,
                  child: Text(l10n.commonContinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
