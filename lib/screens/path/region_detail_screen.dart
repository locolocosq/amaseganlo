import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/journey_map_layout.dart';
import '../../core/journey_progress.dart';
import '../../core/journey_regions.dart';
import '../../l10n/app_localizations.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/empty_state.dart';
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

  void _startBusTravel(double target, bool reduceMotion) {
    if (_busAnimationStarted) return;
    _busAnimationStarted = true;
    if (reduceMotion || target <= 0) {
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

    final journey = JourneyProgress(content: contentProvider.repository, progress: progressProvider.progress, settings: settings);
    final unitIds = section.unitIds;

    var currentIndex = unitIds.length - 1;
    for (var i = 0; i < unitIds.length; i++) {
      if (journey.stateForUnit(unitIds[i]) == UnitState.current) {
        currentIndex = i;
        break;
      }
    }
    final targetProgress = unitIds.length > 1 ? currentIndex / (unitIds.length - 1) : 0.0;
    _startBusTravel(targetProgress, settings.reduceMotion);

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
                  final layout = RegionMapLayout(canvasWidth: constraints.maxWidth);
                  final stations = layout.layout(unitIds.length);
                  final road = layout.smoothPathThrough(stations);
                  final canvasHeight = layout.canvasHeight(unitIds.length);
                  _scrollToStationOnce(stations[currentIndex].position.dy, constraints.maxHeight, canvasHeight);
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
      left: layoutPoint.position.dx - 50,
      top: layoutPoint.position.dy - 31,
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

  void _onStationTap(BuildContext context, String unitId, UnitState state) {
    final l10n = AppLocalizations.of(context);
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
