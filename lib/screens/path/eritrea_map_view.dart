import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/journey_progress.dart';
import '../../core/journey_regions.dart';
import '../../core/purchase_service.dart';
import '../../l10n/app_localizations.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/journey/bus_driver.dart';
import '../../widgets/journey/eritrea_map_painter.dart';
import '../../widgets/journey/region_node_marker.dart';

/// Eritrea's own top-level map page (Etappe 27) - a sibling to the Ethiopia
/// world map, not a node on it: [WorldMapScreen] hosts both as pages of one
/// swipeable [PageView]. Unlike the Ethiopia page there is exactly one stop
/// here (Eritrea/Tigrinya has a single curriculum section, however many
/// stations it holds internally), so this deliberately skips the multi-node
/// road/geo-projection machinery [WorldMapLayout]/[WorldMapPainter] use -
/// one big tappable region medallion on its own coastal backdrop is the
/// whole picture. Tapping it pushes the same `/learn/region/eritrea` route
/// a world-map node would have.
class EritreaMapView extends StatelessWidget {
  const EritreaMapView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contentProvider = context.watch<ContentProvider>();
    final progressProvider = context.watch<ProgressProvider>();
    final settings = context.watch<SettingsProvider>().settings;
    final isPremium = context.watch<PurchaseService>().isPremium;

    final curriculum = contentProvider.repository.curriculum;
    final section = curriculum.sections.firstWhereOrNull((s) => journeyRegionFromId(s.region) == JourneyRegion.eritrea);

    if (section == null) {
      return EmptyState(icon: Icons.error_outline, title: l10n.errorGenericTitle, body: l10n.errorContentUnit);
    }

    final journey = JourneyProgress(content: contentProvider.repository, progress: progressProvider.progress, settings: settings, isPremium: isPremium);
    final done = journey.isSectionDone(section);
    final driverMessage = done ? l10n.journeyDriverEritreaAllDone : l10n.journeyDriverEritreaCurrent;

    var earned = 0;
    for (final unitId in section.unitIds) {
      earned += journey.progress.unitCrowns[unitId] ?? 0;
    }
    final possible = section.unitIds.length * 5;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: BusDriverBubble(message: driverMessage),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: const EritreaMapPainter())),
                  Center(
                    child: RegionNodeMarker(
                      region: JourneyRegion.eritrea,
                      title: journeyRegionShortLabel(JourneyRegion.eritrea, l10n),
                      stationNumber: 1,
                      state: done ? RegionVisualState.completed : RegionVisualState.current,
                      crownsEarned: earned,
                      crownsPossible: possible,
                      onTap: () => context.push('/learn/region/${JourneyRegion.eritrea.name}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
