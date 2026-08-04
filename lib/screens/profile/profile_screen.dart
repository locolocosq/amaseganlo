import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/common/empty_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.person_outline,
      title: l10n.navProfile,
      body: l10n.commonComingSoon,
    );
  }
}
