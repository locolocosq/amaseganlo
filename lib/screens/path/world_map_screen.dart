import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/journey_map_layout.dart';
import '../../core/journey_progress.dart';
import '../../core/journey_regions.dart';
import '../../core/purchase_service.dart';
import '../../l10n/app_localizations.dart';
import '../../models/curriculum.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/eritrea_hint_dialog.dart';
import '../../widgets/journey/bus_driver.dart';
import '../../widgets/journey/region_node_marker.dart';
import '../../widgets/journey/traveling_bus.dart';
import '../../widgets/journey/world_map_painter.dart';
import 'eritrea_map_view.dart';

/// Ebene 1 of the journey map (Etappe 14), now two independent, swipeable
/// pages (Etappe 27): "Äthiopien" (the original 6-region map, unchanged
/// content/unlock logic) and "Eritrea" (its own single-stop page,
/// [EritreaMapView]) - a horizontal [PageView] instead of one combined map,
/// so a second target language gets its own map rather than one more node
/// squeezed onto the first. Tapping a region still pushes the Ebene-2
/// region-detail screen exactly as before; the underlying unlock/progress
/// rules are untouched, see [JourneyProgress].
class WorldMapScreen extends StatefulWidget {
  const WorldMapScreen({super.key});

  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _busController;
  late final PageController _pageController;
  bool _busAnimationStarted = false;
  bool _eritreaHintTriggered = false;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _busController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _pageController = PageController();
  }

  @override
  void dispose() {
    _busController.dispose();
    _pageController.dispose();
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

  /// Shows the one-time "you can also learn Tigrinya now" dialog (Etappe
  /// 26, updated in Etappe 27 to explain the swipe between the two map
  /// pages instead of a tap on a shared map) the first time this screen
  /// builds with the hint not yet seen - guarded the same way
  /// [_startBusTravel] guards its own one-shot animation, so a rebuild
  /// (e.g. progress changing) never re-triggers it mid-session even before
  /// the persisted flag round-trips through storage.
  void _maybeShowEritreaHint(bool alreadySeen) {
    if (alreadySeen || _eritreaHintTriggered) return;
    _eritreaHintTriggered = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await showEritreaLanguageHintDialog(context);
      if (!mounted) return;
      context.read<SettingsProvider>().setHasSeenEritreaHint(true);
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
    final resumeTarget = findResumeTarget(contentProvider.repository, progressProvider.progress);
    final locale = settings.localeCode ?? Localizations.localeOf(context).languageCode;

    _maybeShowEritreaHint(settings.hasSeenEritreaHint);

    return Column(
      children: [
        if (resumeTarget != null)
          _ResumeCard(
            unitTitle: contentProvider.repository.unit(resumeTarget.unitId)?.title[locale] ?? resumeTarget.unitId,
            onTap: () => context.push('/lesson/${resumeTarget.unitId}/${resumeTarget.lessonId}'),
          ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _page = page),
            children: [
              _EthiopiaMapPage(
                journey: journey,
                curriculum: curriculum,
                locale: locale,
                busController: _busController,
                onBusTarget: _startBusTravel,
              ),
              const EritreaMapView(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _PageIndicatorDots(count: 2, current: _page),
        ),
      ],
    );
  }
}

/// Two small dots below the [PageView] hinting there is a second page to
/// swipe to (Etappe 27) - a light, wordless affordance that complements
/// (not replaces) the one-time onboarding hint dialog, which explains the
/// gesture in words the first time.
class _PageIndicatorDots extends StatelessWidget {
  final int count;
  final int current;
  const _PageIndicatorDots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == current ? 18 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == current ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}

/// The Ethiopia map page's body - the original single-map content from
/// before Etappe 27, unchanged in logic, just extracted so [WorldMapScreen]
/// can host it as one page of its [PageView].
class _EthiopiaMapPage extends StatelessWidget {
  final JourneyProgress journey;
  final Curriculum curriculum;
  final String locale;
  final AnimationController busController;
  final ValueChanged<double> onBusTarget;

  const _EthiopiaMapPage({
    required this.journey,
    required this.curriculum,
    required this.locale,
    required this.busController,
    required this.onBusTarget,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final amharicSections = journey.sectionsForLanguage('am');
    final currentRegionIndex = journey.currentRegionIndexForLanguage('am');
    final allDone = amharicSections.every(journey.isSectionDone);
    final currentSection = amharicSections[currentRegionIndex];
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
                  final segments = WorldMapLayout.allRoads(size);
                  final fullRoad = Path();
                  for (final segment in segments) {
                    fullRoad.addPath(segment, Offset.zero);
                  }

                  // Segments have real, unequal lengths (regions sit at very
                  // different geographic distances from each other), so a
                  // naive currentRegionIndex/(count-1) fraction of the
                  // *total* road length lands the bus further and further
                  // from the actual current region the more regions are
                  // behind it (reported: "versetzt sich immer weiter").
                  // Summing only the segments already passed gives the real
                  // cumulative distance to the current region instead.
                  double pathLength(Path p) => p.computeMetrics().fold<double>(0, (sum, m) => sum + m.length);
                  final totalLength = segments.fold<double>(0, (sum, s) => sum + pathLength(s));
                  final reachedLength = segments.take(currentRegionIndex).fold<double>(0, (sum, s) => sum + pathLength(s));
                  final targetProgress = totalLength > 0 ? reachedLength / totalLength : 0.0;
                  onBusTarget(targetProgress);

                  return Stack(
                    children: [
                      Positioned.fill(child: CustomPaint(painter: const WorldMapPainter())),
                      Positioned.fill(child: TravelingBus(path: fullRoad, progress: busController, scale: 1.1)),
                      for (var i = 0; i < WorldMapLayout.order.length; i++)
                        _buildRegionNode(context, size, i, currentRegionIndex, l10n),
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
    int currentRegionIndex,
    AppLocalizations l10n,
  ) {
    final region = WorldMapLayout.order[index];
    final position = WorldMapLayout.positions(size)[region]!;

    // A place added to the map/route ahead of having real content has no
    // matching section yet - render it as a permanently locked "coming
    // soon" placeholder instead of crashing; once a real section for this
    // region appears in curriculum.json, it automatically falls into the
    // normal branch below with no code change needed here. Looked up by
    // region (not position/index) so this stays correct regardless of how
    // curriculum.json orders its sections relative to WorldMapLayout.order.
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
