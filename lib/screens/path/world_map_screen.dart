import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/journey_map_layout.dart';
import '../../core/journey_progress.dart';
import '../../l10n/app_localizations.dart';
import '../../models/curriculum.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/journey/bus_driver.dart';
import '../../widgets/journey/region_node_marker.dart';
import '../../widgets/journey/traveling_bus.dart';
import '../../widgets/journey/world_map_painter.dart';

/// Ebene 1 of the journey map (Etappe 14): the whole "Äthiopien-Reise" at a
/// glance, one node per region/section, connected by a road the bus drives
/// along. Tapping a region pushes the Ebene-2 region-detail screen.
/// Replaces the old flat list (`PathScreen`) as the `/learn` tab's content
/// - the underlying unlock/progress rules are untouched, see
/// [JourneyProgress].
class WorldMapScreen extends StatefulWidget {
  const WorldMapScreen({super.key});

  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> with SingleTickerProviderStateMixin {
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

  /// Runs once per screen visit: the bus visibly drives from the start of
  /// the road up to the current region. Never `repeat()`s - a looping
  /// controller here would hang `pumpAndSettle()` in widget tests forever.
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

    if (contentProvider.state == ContentLoadState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final curriculum = contentProvider.repository.curriculum;
    if (contentProvider.state == ContentLoadState.error || curriculum.sections.isEmpty) {
      return EmptyState(icon: Icons.error_outline, title: l10n.errorGenericTitle, body: l10n.errorContentUnit);
    }

    final journey = JourneyProgress(content: contentProvider.repository, progress: progressProvider.progress, settings: settings);
    final currentRegionIndex = journey.currentRegionIndex;
    final regionCount = WorldMapLayout.order.length;
    final targetProgress = regionCount > 1 ? currentRegionIndex / (regionCount - 1) : 0.0;
    _startBusTravel(targetProgress);

    final allDone = curriculum.sections.every(journey.isSectionDone);
    final currentSection = curriculum.sections[currentRegionIndex];
    final locale = settings.localeCode ?? Localizations.localeOf(context).languageCode;
    final driverMessage = allDone
        ? l10n.journeyDriverWorldMapAllDone
        : l10n.journeyDriverWorldMapCurrent(currentSection.title[locale] ?? currentSection.id);

    final resumeTarget = findResumeTarget(contentProvider.repository, progressProvider.progress);

    return Column(
      children: [
        if (resumeTarget != null)
          _ResumeCard(
            unitTitle: contentProvider.repository.unit(resumeTarget.unitId)?.title[locale] ?? resumeTarget.unitId,
            onTap: () => context.push('/lesson/${resumeTarget.unitId}/${resumeTarget.lessonId}'),
          ),
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
                  final fullRoad = Path();
                  for (final segment in WorldMapLayout.allRoads(size)) {
                    fullRoad.addPath(segment, Offset.zero);
                  }
                  return Stack(
                    children: [
                      Positioned.fill(child: CustomPaint(painter: const WorldMapPainter())),
                      Positioned.fill(child: TravelingBus(path: fullRoad, progress: _busController, scale: 1.1)),
                      for (var i = 0; i < WorldMapLayout.order.length; i++)
                        _buildRegionNode(context, size, i, journey, curriculum, locale, l10n),
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
    Size size,
    int index,
    JourneyProgress journey,
    Curriculum curriculum,
    String locale,
    AppLocalizations l10n,
  ) {
    final region = WorldMapLayout.order[index];
    final position = WorldMapLayout.positions[region]!.toOffset(size);

    // [WorldMapLayout.order] can be longer than `curriculum.sections` - a
    // place added to the map/route ahead of having real content (Etappe
    // 22: Harar) has no section to index into here. Render it as a
    // permanently locked "coming soon" placeholder instead of crashing;
    // once a real section with this region appears in curriculum.json, it
    // automatically falls into the normal branch below with no code
    // change needed here.
    if (index >= curriculum.sections.length) {
      return Positioned(
        left: position.dx - 64,
        top: position.dy - 44,
        child: RegionNodeMarker(
          region: region,
          title: l10n.journeyRegionHarar,
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

    final section = curriculum.sections[index];

    final currentRegionIndex = journey.currentRegionIndex;
    final state = index < currentRegionIndex
        ? RegionVisualState.completed
        : (index == currentRegionIndex ? RegionVisualState.current : RegionVisualState.upcoming);

    var earned = 0;
    for (final unitId in section.unitIds) {
      earned += journey.progress.unitCrowns[unitId] ?? 0;
    }
    final possible = section.unitIds.length * 5;

    return Positioned(
      left: position.dx - 64,
      top: position.dy - 44,
      child: RegionNodeMarker(
        region: region,
        title: section.title[locale] ?? section.id,
        stationNumber: index + 1,
        state: state,
        crownsEarned: earned,
        crownsPossible: possible,
        onTap: () => context.push('/learn/region/${region.name}'),
      ),
    );
  }
}

/// The "Weiterlernen" shortcut back into an in-progress lesson - unchanged
/// from the old list view, just relocated above the map (Abschnitt C1).
class _ResumeCard extends StatelessWidget {
  final String unitTitle;
  final VoidCallback onTap;

  const _ResumeCard({required this.unitTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Material(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.play_circle_fill, color: theme.colorScheme.onPrimaryContainer, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.pathResumeTitle, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                      Text(l10n.pathResumeSubtitle(unitTitle), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: theme.colorScheme.onPrimaryContainer),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
