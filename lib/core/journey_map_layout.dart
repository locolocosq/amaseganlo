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

/// A stylized neighbouring-country landmass drawn behind Ethiopia's own
/// silhouette (Etappe 22 Nachtrag 2), so the outline reads as "a country
/// bordered by other countries" instead of floating alone on an empty
/// backdrop - without this context there was nothing for the eye to
/// recognize Ethiopia's shape *against*. Every shape is drawn generously
/// oversized on the side facing away from Ethiopia; the edge facing
/// Ethiopia deliberately overlaps *underneath* Ethiopia's own opaque
/// terrain fill (drawn on top, see [WorldMapPainter]), so small imprecision
/// there never shows as a gap.
class NeighborLand {
  final Color color;
  final List<GeoPoint> vertices;
  const NeighborLand(this.color, this.vertices);
}

/// Converts the approximate [GeoPoint]s below into fractional map
/// coordinates, and draws the matching stylized Ethiopia outline - both
/// calibrated against the same fixed lon/lat box, so a place's marker
/// always lands inside its own silhouette. Adding a new place later is
/// exactly one new [GeoPoint] entry here (plus a [WorldMapLayout.order]
/// slot) - nothing about this projection needs to change.
class EthiopiaMap {
  // Wide enough to comfortably contain both every GeoPoint below AND every
  // vertex of outline() with margin to spare - a vertex/marker landing
  // right at (or beyond) this box's edge would clamp flat against the
  // canvas border instead of showing its real position.
  static const double _minLon = 31.0;
  static const double _maxLon = 50.0;
  static const double _minLat = 2.3;
  static const double _maxLat = 16.0;

  // Inset from the canvas edge so markers/outline never touch the border.
  static const double _pad = 0.08;

  // Real Ethiopian geography clusters Addis Ababa/Oromia/Sidama close
  // enough together that their map nodes would overlap - these lon/lat
  // values are pushed further apart than reality in exactly that cluster,
  // using the explicit "nicht exakt maßstabsgetreu, aber grob richtig
  // zueinander" (Etappe 22 brief) license: every place keeps its correct
  // rough compass direction from the others, just exaggerated in distance
  // enough to stay tappable as separate nodes on a small phone screen.
  // Etappe 22 Nachtrag 2: re-checked against a real administrative map the
  // user provided - Oromia/Sidama were sitting well outside their real
  // zones (near the South-Ethiopia/Kenya border), and Harar was pushed
  // implausibly far east. Now anchored on each region's actual main city
  // (Jimma, Hawassa, Harar), only Harar nudged a little further east than
  // real life so it stays a separate tappable node from Addis.
  // Oromia/Sidama/Harar's exact lon/lat below are pulled further apart than
  // their real positions (Jimma, Hawassa, Harar city) - measured against the
  // actual rendered map canvas (test run: 576x341, ~25.5px/degree lon,
  // ~20.9px/degree lat), every pair below clears the marker's 96x138px tap
  // box on at least one axis. A more realistic-but-tighter clustering here
  // is exactly what caused the "tap lands on the wrong region" bug fixed
  // earlier in Etappe 22 - direction from Addis is kept correct, distance
  // is not.
  static const Map<JourneyRegion, GeoPoint> geoPositions = {
    JourneyRegion.addisAbeba: GeoPoint(38.75, 9.0), // capital, centre
    JourneyRegion.tigray: GeoPoint(38.7, 14.0), // Aksum/Mekelle area, far north
    JourneyRegion.oromia: GeoPoint(33.5, 7.5), // Jimma area, green south-western highlands
    JourneyRegion.sidama: GeoPoint(43.5, 4.0), // south, pulled south-east for tap clearance
    JourneyRegion.harar: GeoPoint(44.0, 11.5), // Harar, east
  };

  static MapNodePosition _project(GeoPoint geo) {
    final fx = ((geo.lon - _minLon) / (_maxLon - _minLon)).clamp(0.0, 1.0);
    final fy = (1 - (geo.lat - _minLat) / (_maxLat - _minLat)).clamp(0.0, 1.0);
    return MapNodePosition(_pad + fx * (1 - 2 * _pad), _pad + fy * (1 - 2 * _pad));
  }

  static final Map<JourneyRegion, MapNodePosition> positions = {
    for (final entry in geoPositions.entries) entry.key: _project(entry.value),
  };

  /// A simplified silhouette of Ethiopia (Etappe 22, redrawn Nachtrag 2
  /// against a real reference map the user sent) - not survey-accurate,
  /// but deliberately tracing the handful of features that actually make
  /// the shape *read* as Ethiopia: the small jagged northern edge, the
  /// narrow notch pointing at Djibouti, the long near-straight diagonal
  /// Somalia border (the single most distinctive edge of the country), the
  /// wavy Kenya border, and the rounded south-west corner opening onto the
  /// wavier Sudan/South-Sudan border. Vertices are approximate (lon, lat)
  /// pairs projected through the same [_project] used for markers, then
  /// smoothed the same way [RegionMapLayout.smoothPathThrough] smooths
  /// station paths.
  static const List<GeoPoint> _outlineVertices = [
    GeoPoint(36.5, 14.7), // NW, Sudan/Eritrea/Ethiopia corner
    GeoPoint(38.0, 14.9), // N, small jag up
    GeoPoint(39.3, 14.3), // N, dip near the Eritrea/Tigray border
    GeoPoint(40.2, 14.6), // N, jag up again
    GeoPoint(41.3, 13.9), // NE, turning toward the Afar wedge
    GeoPoint(42.0, 12.5), // NE, narrowing
    GeoPoint(42.7, 11.3), // the notch tip pointing at Djibouti
    GeoPoint(43.3, 10.5), // sharp turn - start of the long straight SE edge
    GeoPoint(45.5, 8.3), // the long straight Somalia border, continuing
    GeoPoint(47.5, 6.2), // the long straight Somalia border, continuing
    GeoPoint(47.9, 5.0), // easternmost/south-easternmost point
    GeoPoint(46.0, 4.0), // turning SW along the Kenya/Somalia border
    GeoPoint(43.0, 3.6), // continuing SW
    GeoPoint(40.0, 4.2), // wavy southern (Kenya) edge
    GeoPoint(37.5, 3.6), // wavy southern edge continues
    GeoPoint(35.7, 4.5), // SW corner starting to round
    GeoPoint(34.0, 6.0), // rounding the SW (Gambela) corner
    GeoPoint(33.0, 8.0), // W, Gambela bulge
    GeoPoint(33.3, 11.0), // W, Sudan border, gentle wave
    GeoPoint(34.5, 13.5), // W, Sudan border, gentle wave
    GeoPoint(36.5, 14.7), // back to start
  ];

  /// Rough, deliberately oversized neighbouring-territory shapes (Etappe 22
  /// Nachtrag 2) - see [NeighborLand]. Each traces loosely along the
  /// matching stretch of [_outlineVertices] on the inward-facing edge (so
  /// Ethiopia's own opaque fill, drawn on top, covers the seam) and then
  /// sweeps well past the projection box on every other edge, so it always
  /// reaches the canvas border regardless of aspect ratio. Colours are a
  /// tight family of near-neutral warm greys (never green) - on the
  /// reference map the user sent, neighbouring countries are plain
  /// background next to Ethiopia's own coloured, detailed terrain, and
  /// that contrast is the point: Ethiopia should visually lead.
  static const List<NeighborLand> neighborLands = [
    // Eritrea, north.
    NeighborLand(Color(0xFFE2DDD0), [
      GeoPoint(34.0, 20.0),
      GeoPoint(45.0, 20.0),
      GeoPoint(43.5, 12.0),
      GeoPoint(41.3, 13.4),
      GeoPoint(40.2, 15.1),
      GeoPoint(39.3, 14.8),
      GeoPoint(38.0, 15.4),
      GeoPoint(36.5, 15.2),
      GeoPoint(34.0, 15.0),
      GeoPoint(34.0, 20.0),
    ]),
    // Sudan and South Sudan, west (kept as one shape - the distinction
    // doesn't matter at this zoom level).
    NeighborLand(Color(0xFFDAD4C4), [
      GeoPoint(28.0, 20.0),
      GeoPoint(35.5, 15.5),
      GeoPoint(34.5, 14.0),
      GeoPoint(33.3, 11.5),
      GeoPoint(33.0, 8.5),
      GeoPoint(34.0, 6.5),
      GeoPoint(35.7, 5.0),
      GeoPoint(33.0, 2.0),
      GeoPoint(28.0, 2.0),
      GeoPoint(28.0, 20.0),
    ]),
    // Kenya, south.
    NeighborLand(Color(0xFFD7D2BE), [
      GeoPoint(32.0, -2.0),
      GeoPoint(47.0, -2.0),
      GeoPoint(47.9, 5.5),
      GeoPoint(46.0, 4.5),
      GeoPoint(43.0, 4.1),
      GeoPoint(40.0, 4.7),
      GeoPoint(37.5, 4.2),
      GeoPoint(35.7, 5.0),
      GeoPoint(33.0, 6.5),
      GeoPoint(32.0, -2.0),
    ]),
    // Djibouti, the small notch just north of the Afar wedge.
    NeighborLand(Color(0xFFDCD5C0), [
      GeoPoint(41.3, 14.5),
      GeoPoint(44.5, 15.0),
      GeoPoint(44.0, 11.5),
      GeoPoint(42.7, 11.8),
      GeoPoint(41.5, 13.0),
      GeoPoint(41.3, 14.5),
    ]),
    // Somalia, east/south-east - wraps around Ethiopia's long straight
    // south-eastern border.
    NeighborLand(Color(0xFFDFD9C8), [
      GeoPoint(44.5, 13.0),
      GeoPoint(51.0, 13.0),
      GeoPoint(51.0, -3.0),
      GeoPoint(41.0, -3.0),
      GeoPoint(40.0, 3.8),
      GeoPoint(43.0, 3.9),
      GeoPoint(46.0, 4.2),
      GeoPoint(47.9, 4.8),
      GeoPoint(47.5, 6.7),
      GeoPoint(45.5, 8.8),
      GeoPoint(43.3, 11.5),
      GeoPoint(44.5, 13.0),
    ]),
  ];

  static Path _smoothClosedShape(List<GeoPoint> vertices, Size size) {
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

  static Path outline(Size size) => _smoothClosedShape(_outlineVertices, size);

  static Path neighborPath(NeighborLand land, Size size) => _smoothClosedShape(land.vertices, size);

  /// Projects an arbitrary [GeoPoint] (not necessarily a place or outline
  /// vertex) to canvas pixels - used by [WorldMapPainter] to anchor its
  /// highland/lowland terrain gradient on real geography instead of a
  /// fixed screen direction.
  static Offset projectToOffset(GeoPoint geo, Size size) => _project(geo).toOffset(size);
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
