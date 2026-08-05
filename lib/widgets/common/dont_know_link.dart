import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// The unobtrusive "Ich weiß es nicht" text link required in every exercise
/// (Teil A4). Tapping it must never cost a heart - it is an honest way out,
/// not a trap.
class DontKnowLink extends StatelessWidget {
  final VoidCallback onPressed;

  const DontKnowLink({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant),
        child: Text(l10n.commonDontKnow),
      ),
    );
  }
}
