import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Covers sentenceBuild, listenBuild and (later) fidelWordBuild - tap word
/// chunks from a shuffled pool, in order, to assemble the answer.
class BuildChunksExercise extends StatelessWidget {
  final String promptText;
  final List<String> selectedChunks;
  final List<String> availableChunks;
  final bool answered;
  final bool isAudioPrompt;
  final VoidCallback? onPlayAudio;
  final void Function(int index) onTapAvailable;
  final void Function(int index) onTapSelected;
  final VoidCallback onSubmit;

  const BuildChunksExercise({
    super.key,
    required this.promptText,
    required this.selectedChunks,
    required this.availableChunks,
    required this.answered,
    this.isAudioPrompt = false,
    this.onPlayAudio,
    required this.onTapAvailable,
    required this.onTapSelected,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isAudioPrompt)
          Center(
            child: IconButton.filled(
              iconSize: 40,
              padding: const EdgeInsets.all(20),
              onPressed: onPlayAudio,
              icon: const Icon(Icons.volume_up),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(promptText, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
          ),
        Container(
          constraints: const BoxConstraints(minHeight: 56),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < selectedChunks.length; i++)
                _Chunk(text: selectedChunks[i], onTap: answered ? null : () => onTapSelected(i)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 0; i < availableChunks.length; i++)
              _Chunk(text: availableChunks[i], onTap: answered ? null : () => onTapAvailable(i)),
          ],
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: (answered || selectedChunks.isEmpty) ? null : onSubmit,
          child: Text(l10n.exerciseCheckAnswer),
        ),
      ],
    );
  }
}

class _Chunk extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _Chunk({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          alignment: Alignment.center,
          child: Text(text, style: theme.textTheme.bodyLarge),
        ),
      ),
    );
  }
}
