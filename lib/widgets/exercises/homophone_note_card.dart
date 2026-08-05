import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../state/fidel_lesson_provider.dart';

/// "Achtung: gleicher Laut" - shown right when a second (or third) sign
/// sharing a sound with an already-learned sign is introduced (Teil B,
/// Stufe 1). No wrong answer possible, just "Weiter".
class HomophoneNoteCard extends StatelessWidget {
  final HomophoneNote note;
  final VoidCallback onContinue;

  const HomophoneNoteCard({super.key, required this.note, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final soundsLikeText = note.soundsLike.map((c) => c.char).join(', ');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.info_outline, size: 40, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(note.char.char, style: theme.textTheme.displayLarge),
        const SizedBox(height: 12),
        Text(l10n.fidelHomophoneTitle, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(l10n.fidelHomophoneBody(soundsLikeText), textAlign: TextAlign.center),
        ),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity, child: FilledButton(onPressed: onContinue, child: Text(l10n.introCardContinue))),
      ],
    );
  }
}
