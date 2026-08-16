import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/eritrea_map_layout.dart';
import '../../core/journey_progress.dart';
import '../../core/journey_regions.dart';
import '../../core/purchase_service.dart';
import '../../l10n/app_localizations.dart';
import '../../models/curriculum.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/journey/bus_driver.dart';
import '../../widgets/journey/eritrea_country_painter.dart';
import '../../widgets/journey/region_node_marker.dart';
import '../../widgets/journey/traveling_bus.dart';

/// Eritrea's own top-level map page (Etappe 27) - a full sibling to the
/// Ethiopia page now, not a single-node preview (that was Etappe 27's first
/// draft, corrected on request): four stops (Keren, Asmara, Massawa,
/// Dahlak) on their own road, with a bus driving along it exactly the way
/// Ethiopia's page works. A separate [StatefulWidget] with its own
/// [AnimationController] rather than sharing [WorldMapScreen]'s single bus
/// controller - two independent one-shot travel animations are simpler to
/// reason about as two separate tickers than as one shared one juggling
/// two roads.
class EritreaCountryMapPage extends StatefulWidget {
  const EritreaCountryMapPage({super.key});

  @override
  State<EritreaCountryMapPage> createState() => _EritreaCountryMapPageState();
}

class _EritreaCountryMapPageState extends State<EritreaCountryMapPage> with SingleTickerProviderStateMixin {
  late final AnimationController _busController;
  bool _busAnimationStarted = false;

  @override
  void initState() {
    super.initState();
    _busController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  }

  @override
  void dispose() {
    _busController.dispose();
    super.dispose();
  }

  void _startBusTravel(double target) {
    if (_busAnimationStarted) return;
    _busAnimationStarted = true;
    if (target <= 0) {
      _busController.value = target;
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _busController.animateTo(target, duration: Duration(milliseconds: (500 + target * 1600).round()), curve: Curves.easeInOutCubic);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contentProvider = context.watch<ContentProvider>();
    final progressProvider = context.watch<ProgressProvider>();
    final settings = context.watch<SettingsProvider>().settings;
    final isPremium = context.watch<PurchaseService>().isPremium;

    if (contentProvider.state == ContentLoadState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final curriculum = contentProvider.repository.curriculum;
    if (contentProvider.state == ContentLoadState.error || curriculum.sections.isEmpty) {
      return EmptyState(icon: Icons.error_outline, title: l10n.errorGenericTitle, body: l10n.errorContentUnit);
    }

    final journey = JourneyProgress(content: contentProvider.repository, progress: progressProvider.progress, settings: settings, isPremium: isPremium);
    final locale = settings.localeCode ?? Localizations.localeOf(context).languageCode;

    final tigrinyaSections = journey.sectionsForLanguage('ti');
    if (tigrinyaSections.isEmpty) {
      return EmptyState(icon: Icons.error_outline, title: l10n.errorGenericTitle, body: l10n.errorContentUnit);
    }
    final currentRegionIndex = journey.currentRegionIndexForLanguage('ti');
    final allDone = tigrinyaSections.every(journey.isSectionDone);
    final currentSection = tigrinyaSections[currentRegionIndex];
    final driverMessage = allDone
        ? l10n.journeyDriverWorldMapAllDone
        : l10n.journeyDriverWorldMapCurrent(currentSection.title[locale] ?? currentSection.id);

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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.biggest;
                  final segments = EritreaCountryMap.allRoads(size);
                  final fullRoad = Path();
                  for (final segment in segments) {
                    fullRoad.addPath(segment, Offset.zero);
                  }

                  double pathLength(Path p) => p.computeMetrics().fold<double>(0, (sum, m) => sum + m.length);
                  final totalLength = segments.fold<double>(0, (sum, s) => sum + pathLength(s));
                  final reachedLength = segments.take(currentRegionIndex).fold<double>(0, (sum, s) => sum + pathLength(s));
                  final targetProgress = totalLength > 0 ? reachedLength / totalLength : 0.0;
                  _startBusTravel(targetProgress);

                  return Stack(
                    children: [
                      Positioned.fill(child: CustomPaint(painter: const EritreaCountryPainter())),
                      Positioned.fill(child: TravelingBus(path: fullRoad, progress: _busController, scale: 1.1)),
                      for (var i = 0; i < EritreaCountryMap.order.length; i++)
                        _buildRegionNode(context, curriculum, journey, size, i, currentRegionIndex, l10n),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegionNode(
    BuildContext context,
    Curriculum curriculum,
    JourneyProgress journey,
    Size size,
    int index,
    int currentRegionIndex,
    AppLocalizations l10n,
  ) {
    final region = EritreaCountryMap.order[index];
    final position = EritreaCountryMap.positions(size)[region]!;
    final section = curriculum.sections.firstWhereOrNull((s) => journeyRegionFromId(s.region) == region);

    if (section == null) {
      return Positioned(
        left: position.dx - 33,
        top: position.dy - 26,
        child: RegionNodeMarker(
          region: region,
          title: journeyRegionShortLabel(region, l10n),
          stationNumber: index + 1,
          state: RegionVisualState.comingSoon,
          crownsEarned: 0,
          crownsPossible: 0,
          comingSoonLabel: l10n.journeyRegionComingSoon,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.journeyRegionComingSoon), duration: const Duration(seconds: 2)),
          ),
        ),
      );
    }

    final state = index < currentRegionIndex
        ? RegionVisualState.completed
        : (index == currentRegionIndex ? RegionVisualState.current : RegionVisualState.upcoming);

    var earned = 0;
    for (final unitId in section.unitIds) {
      earned += journey.progress.unitCrowns[unitId] ?? 0;
    }
    final possible = section.unitIds.length * 5;

    return Positioned(
      left: position.dx - 33,
      top: position.dy - 26,
      child: RegionNodeMarker(
        region: region,
        title: journeyRegionShortLabel(region, l10n),
        stationNumber: index + 1,
        state: state,
        crownsEarned: earned,
        crownsPossible: possible,
        onTap: () => context.push('/learn/region/${region.name}'),
      ),
    );
  }
}
