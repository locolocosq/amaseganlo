import 'dart:math' as math;
import 'dart:ui';

import 'journey_regions.dart';

/// A point on a map expressed as a fraction (0..1) of the canvas it's drawn
/// on, so layouts stay correct at any screen size.
class MapNodePosition {
  final double x;
  final double y;
  const MapNodePosition(this.x, this.y);

  Offset toOffset(Size size) => Offset(x * size.width, y * size.height);
}

/// Layout for the Ebene-1 world map: where each region's node sits, and the
/// order the road connects them in (matches `Curriculum.sections` order -
/// the same pedagogical progression as always, just drawn as a road now).
class WorldMapLayout {
  static const List<JourneyRegion> order = [
    JourneyRegion.addisAbeba,
    JourneyRegion.oromia,
    JourneyRegion.tigray,
    JourneyRegion.sidama,
  ];

  static const Map<JourneyRegion, MapNodePosition> positions = {
    JourneyRegion.addisAbeba: MapNodePosition(0.20, 0.78),
    JourneyRegion.oromia: MapNodePosition(0.38, 0.46),
    JourneyRegion.tigray: MapNodePosition(0.64, 0.20),
    JourneyRegion.sidama: MapNodePosition(0.80, 0.66),
  };

  /// A gentle S-curve between two node positions (not a straight line) -
  /// the control point is offset perpendicular to the direct line, scaled
  /// by the distance, so the road always looks hand-drawn regardless of
  /// screen size/aspect ratio.
  static Path roadBetween(Size size, JourneyRegion from, JourneyRegion to, {double bow = 0.22}) {
    final start = positions[from]!.toOffset(size);
    final end = positions[to]!.toOffset(size);
    final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
    final delta = end - start;
    final perpendicular = Offset(-delta.dy, delta.dx);
    final control = mid + perpendicular * bow;
    return Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
  }

  static List<Path> allRoads(Size size) => [
        for (var i = 0; i < order.length - 1; i++) roadBetween(size, order[i], order[i + 1]),
      ];
}

/// One station on a region's Ebene-2 detail path.
class StationLayoutPoint {
  final int index; // 0-based position within the region
  final Offset position; // absolute logical pixels within the region canvas
  const StationLayoutPoint({required this.index, required this.position});
}

/// Procedurally lays out N stations as a winding ("Schlangen"-) path down a
/// tall, scrollable canvas - works for any station count (7 for Addis
/// Abeba, 35 for Tigray, ...) without hand-authoring a layout per region.
/// A sine wave gives the natural left-right winding look, matching the
/// style of mobile-game level-select maps.
class RegionMapLayout {
  final double canvasWidth;
  final double verticalSpacing;
  final double amplitude;

  const RegionMapLayout({
    this.canvasWidth = 380,
    this.verticalSpacing = 150,
    this.amplitude = 100,
  });

  double get topPadding => 120;
  double get bottomPadding => 140;

  double canvasHeight(int stationCount) => topPadding + bottomPadding + (stationCount - 1).clamp(0, 1 << 30) * verticalSpacing;

  List<StationLayoutPoint> layout(int stationCount) {
    final centerX = canvasWidth / 2;
    return [
      for (var i = 0; i < stationCount; i++)
        StationLayoutPoint(
          index: i,
          position: Offset(
            centerX + amplitude * math.sin(i * 0.95),
            topPadding + i * verticalSpacing,
          ),
        ),
    ];
  }

  /// A smooth path threading through every station, using quadratic
  /// bezier segments through midpoints (the standard trick for a smooth
  /// curve through an arbitrary list of points without needing full
  /// Catmull-Rom spline math).
  Path smoothPathThrough(List<StationLayoutPoint> points) {
    final path = Path();
    if (points.isEmpty) return path;
    path.moveTo(points.first.position.dx, points.first.position.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i].position;
      final next = points[i + 1].position;
      final mid = Offset((current.dx + next.dx) / 2, (current.dy + next.dy) / 2);
      path.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
      if (i == points.length - 2) {
        path.quadraticBezierTo(next.dx, next.dy, next.dx, next.dy);
      }
    }
    return path;
  }
}
