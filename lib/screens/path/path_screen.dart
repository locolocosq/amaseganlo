import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/common/empty_state.dart';

class PathScreen extends StatelessWidget {
  const PathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.route_outlined,
      title: l10n.navLearn,
      body: l10n.commonComingSoon,
    );
  }
}
