import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Covers wordTyping, sentenceGapTyping, sentenceTranslate, listenTyping and
/// (later) the Fidel reading-typing types - all of them are "show a prompt,
/// type the answer".
class TypingExercise extends StatelessWidget {
  final String promptText;
  final TextEditingController controller;
  final bool answered;
  final bool isAudioPrompt;
  final VoidCallback? onPlayAudio;
  final VoidCallback onSubmit;
  final TextStyle? promptStyle;

  const TypingExercise({
    super.key,
    required this.promptText,
    required this.controller,
    required this.answered,
    this.isAudioPrompt = false,
    this.onPlayAudio,
    required this.onSubmit,
    this.promptStyle,
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
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(promptText, style: promptStyle ?? theme.textTheme.headlineSmall, textAlign: TextAlign.center),
          ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          enabled: !answered,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(
            hintText: l10n.exerciseTypeAnswerHint,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: answered ? null : onSubmit,
          child: Text(l10n.exerciseCheckAnswer),
        ),
      ],
    );
  }
}
