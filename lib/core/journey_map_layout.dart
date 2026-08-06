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

/// A very rough real-world longitude/latitude, used only to place a place's
/// map marker at roughly the right spot relative to the others - never for
/// actual cartography or distance math (Etappe 22).
class GeoPoint {
  final double lon;
  final double lat;
  const GeoPoint(this.lon, this.lat);
}

/// Converts the approximate [GeoPoint]s below into fractional map
/// coordinates, and draws the matching stylized Ethiopia outline - both
/// calibrated against the same fixed lon/lat box, so a place's marker
/// always lands inside its own silhouette. Adding a new place later is
/// exactly one new [GeoPoint] entry here (plus a [WorldMapLayout.order]
/// slot) - nothing about this projection needs to change.
class EthiopiaMap {
  static const double _minLon = 33.0;
  static const double _maxLon = 48.0;
  static const double _minLat = 3.3;
  static const double _maxLat = 15.0;

  // Inset from the canvas edge so markers/outline never touch the border.
  static const double _pad = 0.08;

  // Real Ethiopian geography clusters Addis Ababa/Oromia/Sidama close
  // enough together that their map nodes would overlap - these lon/lat
  // values are pushed further apart than reality in exactly that cluster,
  // using the explicit "nicht exakt maßstabsgetreu, aber grob richtig
  // zueinander" (Etappe 22 brief) license: every place keeps its correct
  // rough compass direction from the others, just exaggerated in distance
  // enough to stay tappable as separate nodes on a small phone screen.
  static const Map<JourneyRegion, GeoPoint> geoPositions = {
    JourneyRegion.addisAbeba: GeoPoint(38.75, 9.0), // capital, centre
    JourneyRegion.tigray: GeoPoint(38.7, 14.5), // Aksum/Mekelle area, far north
    JourneyRegion.oromia: GeoPoint(33.5, 5.5), // Jimma area, south-west
    JourneyRegion.sidama: GeoPoint(39.5, 3.6), // Hawassa/Sidama area, far south
    JourneyRegion.harar: GeoPoint(46.5, 9.5), // Harar, far east
  };

  static MapNodePosition _project(GeoPoint geo) {
    final fx = ((geo.lon - _minLon) / (_maxLon - _minLon)).clamp(0.0, 1.0);
    final fy = (1 - (geo.lat - _minLat) / (_maxLat - _minLat)).clamp(0.0, 1.0);
    return MapNodePosition(_pad + fx * (1 - 2 * _pad), _pad + fy * (1 - 2 * _pad));
  }

  static final Map<JourneyRegion, MapNodePosition> positions = {
    for (final entry in geoPositions.entries) entry.key: _project(entry.value),
  };

  /// A simplified silhouette of Ethiopia (Etappe 22) - NOT accurate
  /// cartography, just enough of the country's recognizable "leaning
  /// figure with an eastward point" shape to read as Ethiopia at a glance,
  /// kept subtle so it never competes with the route/markers drawn on top.
  /// Vertices are approximate (lon, lat) pairs projected through the same
  /// [_project] used for markers, then smoothed the same way
  /// [RegionMapLayout.smoothPathThrough] smooths station paths.
  static Path outline(Size size) {
    const vertices = [
      GeoPoint(34.4, 14.2), // NW, Sudan border
      GeoPoint(36.5, 14.9), // N
      GeoPoint(38.5, 14.4), // N, near Eritrea
      GeoPoint(40.0, 14.7), // NE point (Afar)
      GeoPoint(41.8, 13.0), // notch down toward Djibouti
      GeoPoint(43.0, 11.0), // E
      GeoPoint(47.5, 8.2), // far E point (Somali region)
      GeoPoint(45.5, 6.0), // SE
      GeoPoint(42.5, 4.2), // S, near Somalia/Kenya
      GeoPoint(40.0, 3.9), // S
      GeoPoint(36.5, 4.5), // S, near Kenya
      GeoPoint(34.2, 6.8), // SW
      GeoPoint(33.0, 10.5), // W, Sudan border
      GeoPoint(34.4, 14.2), // back to start
    ];
    final points = [for (final v in vertices) _project(v).toOffset(size)];
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final mid = Offset((current.dx + next.dx) / 2, (current.dy + next.dy) / 2);
      path.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
    }
    path.close();
    return path;
  }
}

/// Layout for the Ebene-1 world map: where each region's node sits, and the
/// order the road connects them in. Etappe 22: reordered so the road sweeps
/// roughly N → SW → S → E instead of crossing itself, and Harar was added
/// as a fifth, currently content-less stop at the end - see
/// ENTSCHEIDUNGEN.md. [order] no longer has to equal `Curriculum.sections`
/// in length; [WorldMapScreen] renders any extra entries (like Harar) as a
/// locked "coming soon" placeholder instead of indexing into sections.
class WorldMapLayout {
  static const List<JourneyRegion> order = [
    JourneyRegion.addisAbeba,
    JourneyRegion.tigray,
    JourneyRegion.oromia,
    JourneyRegion.sidama,
    JourneyRegion.harar,
  ];

  static Map<JourneyRegion, MapNodePosition> get positions => EthiopiaMap.positions;

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
