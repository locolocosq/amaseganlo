import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/common/empty_state.dart';

class FidelScreen extends StatelessWidget {
  const FidelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.abc_outlined,
      title: l10n.navFidel,
      body: l10n.commonComingSoon,
    );
  }
}
