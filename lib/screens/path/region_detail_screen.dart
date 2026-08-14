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
import '../../widgets/common/premium_locked_dialog.dart';
import '../../widgets/journey/bus_driver.dart';
import '../../widgets/journey/region_detail_painter.dart';
import '../../widgets/journey/station_node_marker.dart';
import '../../widgets/journey/traveling_bus.dart';

/// Ebene 2 of the journey map (Etappe 14): one region's stations ("1-1",
/// "1-2", ...) laid out along a winding path, with the same lock/current/
/// done rules as before (Abschnitt Design) - just drawn on a map instead
/// of stacked in a list. Reached by tapping a region node on
/// [WorldMapScreen]; tapping a station pushes the unchanged
/// `UnitOverviewScreen` route.
class RegionDetailScreen extends StatefulWidget {
  final String regionId;

  const RegionDetailScreen({super.key, required this.regionId});

  @override
  State<RegionDetailScreen> createState() => _RegionDetailScreenState();
}

class _RegionDetailScreenState extends State<RegionDetailScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _busController;
  late final ScrollController _scrollController;
  bool _busAnimationStarted = false;
  bool _scrolledInitially = false;

  @override
  void initState() {
    super.initState();
    _busController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _busController.dispose();
    _scrollController.dispose();
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

  void _scrollToStationOnce(double dy, double viewportHeight, double canvasHeight) {
    if (_scrolledInitially) return;
    _scrolledInitially = true;
    final maxExtent = (canvasHeight - viewportHeight).clamp(0.0, double.infinity);
    final target = (dy - viewportHeight / 2).clamp(0.0, maxExtent);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) _scrollController.jumpTo(target);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final region = journeyRegionFromRouteName(widget.regionId);
    final contentProvider = context.watch<ContentProvider>();
    final progressProvider = context.watch<ProgressProvider>();
    final settings = context.watch<SettingsProvider>().settings;
    final isPremium = context.watch<PurchaseService>().isPremium;
    final locale = settings.localeCode ?? Localizations.localeOf(context).languageCode;

    final curriculum = contentProvider.repository.curriculum;
    final section = region == null ? null : curriculum.sections.firstWhereOrNull((s) => journeyRegionFromId(s.region) == region);

    if (region == null || section == null) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
        body: EmptyState(
          icon: Icons.error_outline,
          title: l10n.errorGenericTitle,
          body: l10n.errorContentUnit,
          action: FilledButton(onPressed: () => context.go('/learn'), child: Text(l10n.journeyBackToMap)),
        ),
      );
    }

    final journey = JourneyProgress(content: contentProvider.repository, progress: progressProvider.progress, settings: settings, isPremium: isPremium);
    final unitIds = section.unitIds;

    var currentIndex = unitIds.length - 1;
    for (var i = 0; i < unitIds.length; i++) {
      if (journey.stateForUnit(unitIds[i]) == UnitState.current) {
        currentIndex = i;
        break;
      }
    }

    final regionAllDone = journey.isSectionDone(section);
    final driverMessage = regionAllDone
        ? l10n.journeyDriverRegionAllDone
        : l10n.journeyDriverRegionCurrent(section.title[locale] ?? section.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(section.title[locale] ?? section.id),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.commonBack,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: BusDriverBubble(message: driverMessage),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // +1 station: the cumulative "Freies Wiederholen" stop
                  // (Etappe 22) always sits at the end of the winding path,
                  // right after the region's own units.
                  final totalStations = unitIds.length + 1;
                  final layout = RegionMapLayout(canvasWidth: constraints.maxWidth);
                  final stations = layout.layout(totalStations);
                  final road = layout.smoothPathThrough(stations);
                  final canvasHeight = layout.canvasHeight(totalStations);
                  _scrollToStationOnce(stations[currentIndex].position.dy, constraints.maxHeight, canvasHeight);

                  // The winding path's per-station arc length isn't uniform
                  // (sine-wave horizontal offsets mean some hops are longer
                  // than others), so a naive currentIndex/(count-1) fraction
                  // of the *total* path length lands the bus further and
                  // further from the actual current station the more stations
                  // are behind it (reported: "versetzt sich immer weiter").
                  // `smoothPathThrough` builds its curve point-by-point, so
                  // the path through just the first (currentIndex + 1)
                  // stations is an exact prefix of `road` - measuring that
                  // gives the real cumulative distance to the current station.
                  double pathLength(Path p) => p.computeMetrics().fold<double>(0, (sum, m) => sum + m.length);
                  final totalLength = pathLength(road);
                  final reachedLength = pathLength(layout.smoothPathThrough(stations.sublist(0, currentIndex + 1)));
                  final targetProgress = totalLength > 0 ? reachedLength / totalLength : 0.0;
                  _startBusTravel(targetProgress);
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: canvasHeight,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(painter: RegionDetailPainter(region: region, stations: stations, road: road)),
                          ),
                          Positioned.fill(child: TravelingBus(path: road, progress: _busController, scale: 1.0)),
                          for (var i = 0; i < unitIds.length; i++)
                            _buildStationNode(context, region, section.id, unitIds[i], i, stations[i], journey, locale),
                          _buildReviewStationNode(context, region, section, stations[unitIds.length], journey, l10n),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationNode(
    BuildContext context,
    JourneyRegion region,
    String sectionId,
    String unitId,
    int indexInSection,
    StationLayoutPoint layoutPoint,
    JourneyProgress journey,
    String locale,
  ) {
    final unit = journey.content.unit(unitId);
    final state = journey.stateForUnit(unitId);
    final crowns = journey.progress.unitCrowns[unitId] ?? 0;
    final sectionNumber = journey.content.curriculum.sections.indexWhere((s) => s.id == sectionId) + 1;
    final numberLabel = '$sectionNumber-${indexInSection + 1}';

    return Positioned(
      left: layoutPoint.position.dx - 41,
      top: layoutPoint.position.dy - 25,
      child: StationNodeMarker(
        region: region,
        numberLabel: numberLabel,
        title: unit?.title[locale] ?? unitId,
        state: state,
        crowns: crowns,
        onTap: () => _onStationTap(context, unitId, state),
      ),
    );
  }

  /// The cumulative "Freies Wiederholen" stop (Etappe 22): unlocked once
  /// every unit in this region is done/skipped, and - unlike a numbered
  /// unit station - never shows as "completed", since it's meant to be
  /// replayed any number of times rather than checked off once. Its word
  /// pool grows with every region finished (see [RegionReviewScreen]),
  /// which is why it's passed every section id up to and including this
  /// one, not just this region's.
  Widget _buildReviewStationNode(
    BuildContext context,
    JourneyRegion region,
    CurriculumSection section,
    StationLayoutPoint layoutPoint,
    JourneyProgress journey,
    AppLocalizations l10n,
  ) {
    final unlocked = journey.isSectionDone(section);
    final sections = journey.content.curriculum.sections;
    final sectionIndex = sections.indexWhere((s) => s.id == section.id);
    final cumulativeSectionIds = [for (final s in sections.take(sectionIndex + 1)) s.id];

    return Positioned(
      left: layoutPoint.position.dx - 41,
      top: layoutPoint.position.dy - 25,
      child: StationNodeMarker(
        region: region,
        // "R" (not a repeat-arrow glyph) so a screen reader announcing
        // "$numberLabel $title" reads sensibly instead of a Unicode symbol
        // name.
        numberLabel: 'R',
        title: l10n.regionReviewStationTitle,
        state: unlocked ? UnitState.current : UnitState.locked,
        crowns: 0,
        onTap: () => _onReviewStationTap(context, region, unlocked, cumulativeSectionIds, l10n),
      ),
    );
  }

  void _onReviewStationTap(
    BuildContext context,
    JourneyRegion region,
    bool unlocked,
    List<String> cumulativeSectionIds,
    AppLocalizations l10n,
  ) {
    if (unlocked) {
      context.push('/learn/region/${region.name}/review', extra: cumulativeSectionIds);
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.pathLockedDialogTitle),
        content: Text(l10n.regionReviewLockedBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonClose)),
        ],
      ),
    );
  }

  void _onStationTap(BuildContext context, String unitId, UnitState state) {
    final l10n = AppLocalizations.of(context);
    if (state == UnitState.premiumLocked) {
      showPremiumLockedDialog(context);
      return;
    }
    if (state != UnitState.locked) {
      context.push('/learn/unit/$unitId');
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.pathLockedDialogTitle),
        content: Text(l10n.pathLockedDialogBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.pathLockedDialogLater)),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.push('/learn/unit/$unitId');
            },
            child: Text(l10n.pathLockedDialogStart),
          ),
        ],
      ),
    );
  }
}
