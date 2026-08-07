import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

/// Shown wherever tapping something premium-gated needs to redirect to a
/// purchase instead of offering to open it anyway (Etappe 23) - unlike the
/// sequential-progress "Dieses Kapitel baut auf den vorherigen auf" dialog,
/// there is deliberately no "trotzdem starten" escape hatch here: Premium
/// content only opens after actually buying it.
void showPremiumLockedDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.workspace_premium),
      title: Text(l10n.premiumLockedDialogTitle),
      content: Text(l10n.premiumLockedDialogBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.pathLockedDialogLater)),
        FilledButton(
          onPressed: () {
            Navigator.pop(ctx);
            context.push('/settings/premium');
          },
          child: Text(l10n.premiumLockedDialogAction),
        ),
      ],
    ),
  );
}
