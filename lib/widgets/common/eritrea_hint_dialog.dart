import 'package:flutter/material.dart';

import '../../core/journey_regions.dart';
import '../../l10n/app_localizations.dart';
import '../journey/region_node_marker.dart';

/// A one-time, dezent hint shown right after onboarding (Etappe 26) that a
/// second target language - Tigrinya, via the new Eritrea map - now exists.
/// Deliberately not a 5th onboarding page: onboarding_flow_test.dart already
/// exercises the exact 4-step handshake end-to-end, and this needs no
/// interactive setup of its own (there is no language-switch *setting* to
/// walk through - "switching" is simply swiping between the two top-level
/// map pages, Etappe 27, which the body text below says outright). Shown
/// once, gated by [AppSettings.hasSeenEritreaHint], the same persisted-flag
/// pattern already used for onboarding itself.
Future<void> showEritreaLanguageHintDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      // The same hand-drawn medallion art the Eritrea map itself uses for
      // its first stop, Asmara (RegionIconPainter), not a generic Material
      // icon - so this hint visibly previews exactly what the learner is
      // about to go find, in the app's own established illustration style.
      icon: SizedBox(
        width: 56,
        height: 56,
        child: ClipOval(
          child: CustomPaint(
            painter: RegionIconPainter(region: JourneyRegion.asmara),
            size: Size.infinite,
          ),
        ),
      ),
      title: Text(l10n.onboardingEritreaHintTitle),
      content: Text(l10n.onboardingEritreaHintBody),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.onboardingEritreaHintButton),
        ),
      ],
    ),
  );
}
