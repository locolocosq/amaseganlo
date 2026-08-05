import 'package:flutter/material.dart';

import '../../models/fidel_char.dart';

/// Shows all 7 signs of one Fidel row side by side. Since the actual glyphs
/// aren't decomposed into strokes, the "changed part" is highlighted in the
/// transliteration label (consonant in the normal text color, the vowel
/// letter in the accent color) rather than inside the Ethiopic glyph itself.
class FidelOrderRow extends StatelessWidget {
  final List<FidelChar> chars;
  final void Function(FidelChar)? onTap;
  final double charFontSize;

  const FidelOrderRow({super.key, required this.chars, this.onTap, this.charFontSize = 40});

  @override
  Widget build(BuildContext context) {
    final sorted = List<FidelChar>.from(chars)..sort((a, b) => a.order.compareTo(b.order));
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [for (final c in sorted) _FidelTile(char: c, onTap: onTap, fontSize: charFontSize)],
    );
  }
}

class _FidelTile extends StatelessWidget {
  final FidelChar char;
  final void Function(FidelChar)? onTap;
  final double fontSize;

  const _FidelTile({required this.char, required this.onTap, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final consonantPart = char.tr.length > 1 && char.order != 6 ? char.tr.substring(0, char.tr.length - 1) : char.tr;
    final vowelPart = char.order == 6 ? '' : char.tr.substring(consonantPart.length);

    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap == null ? null : () => onTap!(char),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(char.char, style: TextStyle(fontSize: fontSize)),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  children: [
                    TextSpan(text: consonantPart),
                    TextSpan(text: vowelPart, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
