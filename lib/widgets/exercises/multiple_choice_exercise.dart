import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';

/// Covers wordChoiceAmToNative/NativeToAm, emojiMatch, sentenceGapChoice,
/// listenChoice, trueFalse and (later) the Fidel sound/sign choice types -
/// all of them are "show a prompt, pick one of N options".
class MultipleChoiceExercise extends StatelessWidget {
  final String promptText;
  final List<String> options;
  final String correctAnswer;
  final String? selectedOption;
  final bool answered;
  final bool isAudioPrompt;
  final VoidCallback? onPlayAudio;
  final ValueChanged<String> onSelect;
  final TextStyle? promptStyle;

  const MultipleChoiceExercise({
    super.key,
    required this.promptText,
    required this.options,
    required this.correctAnswer,
    required this.selectedOption,
    required this.answered,
    this.isAudioPrompt = false,
    this.onPlayAudio,
    required this.onSelect,
    this.promptStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isAudioPrompt)
          Center(
            child: IconButton.filled(
              iconSize: 40,
              padding: const EdgeInsets.all(20),
              tooltip: l10n.audioPlayTooltip,
              onPressed: onPlayAudio,
              icon: const Icon(Icons.volume_up),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              promptText,
              style: promptStyle ?? theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 16),
        for (final option in options) ...[
          _OptionButton(
            text: option,
            state: _stateFor(option),
            onTap: answered ? null : () => onSelect(option),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  _OptionState _stateFor(String option) {
    if (!answered) {
      return option == selectedOption ? _OptionState.selected : _OptionState.normal;
    }
    if (option == correctAnswer) return _OptionState.correct;
    if (option == selectedOption) return _OptionState.incorrect;
    return _OptionState.normal;
  }
}

enum _OptionState { normal, selected, correct, incorrect }

class _OptionButton extends StatelessWidget {
  final String text;
  final _OptionState state;
  final VoidCallback? onTap;

  const _OptionButton({required this.text, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color? borderColor;
    Color? fillColor;
    Widget? trailingIcon;

    switch (state) {
      case _OptionState.selected:
        borderColor = theme.colorScheme.primary;
        fillColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.4);
        break;
      case _OptionState.correct:
        borderColor = successColor;
        fillColor = successColor.withValues(alpha: 0.15);
        trailingIcon = const Icon(Icons.check_circle, color: successColor);
        break;
      case _OptionState.incorrect:
        borderColor = errorColor;
        fillColor = errorColor.withValues(alpha: 0.12);
        trailingIcon = const Icon(Icons.cancel, color: errorColor);
        break;
      case _OptionState.normal:
        borderColor = theme.colorScheme.outlineVariant;
        break;
    }

    return Material(
      color: fillColor ?? theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
              ?trailingIcon,
            ],
          ),
        ),
      ),
    );
  }
}
