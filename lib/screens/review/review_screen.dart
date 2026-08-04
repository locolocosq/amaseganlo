import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/common/empty_state.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.refresh_outlined,
      title: l10n.navReview,
      body: l10n.commonComingSoon,
    );
  }
}
