import 'dart:math' as math;
import 'dart:ui';

import 'journey_map_layout.dart';
import 'journey_regions.dart';

/// One scale factor + centring offset for a given canvas size - same
/// approach as `EthiopiaMap._MapTransform` in journey_map_layout.dart, just
/// a separate small copy rather than a shared/exported class: Etappe 27
/// deliberately keeps Eritrea's map layout independent of Ethiopia's
/// (see EritreaCountryMap's own doc comment for why), so this stays
/// private to this file too.
class _MapTransform {
  final double scale;
  final double dx;
  final double dy;
  const _MapTransform({required this.scale, required this.dx, required this.dy});
}

/// Eritrea's own top-level country map (Etappe 27) - the sibling to
/// [EthiopiaMap]/[WorldMapLayout] that Eritrea's four stops (Etappe 26's
/// single combined node grew into four, on user request) are laid out on.
/// Deliberately a separate, parallel implementation rather than a shared
/// generalisation of [EthiopiaMap]: both maps only ever need to exist once
/// each, and keeping them independent means a future change to one (a new
/// Ethiopia region, say) can never accidentally ripple into the other's
/// geometry or tests - the same "some duplication over shared fragility"
/// trade-off ENTSCHEIDUNGEN.md already documents for `LessonScreen` vs
/// `ExercisePlayer` (Etappe 6).
///
/// The outline below is a hand-authored approximation of Eritrea's real
/// boundary, redrawn (Etappe 27 Nachtrag 2) to closely trace the reference
/// silhouette the user sent: the sharp northern spike at the Sudan/Red Sea
/// corner near Karora, a scalloped western border with Sudan bulging out
/// around 15-16°N, a notched Red Sea coast, the waist where the body
/// narrows into the south-eastern tail, and that tail's jagged run down to
/// the pointed Ras Dumeira tip at the Djibouti border - not a surveyed
/// dataset the way [EthiopiaMap.outline] was (that one came from a real
/// `ETH.geo.json` boundary file), but traced point-by-point against the
/// reference image rather than the looser first attempt.
class EritreaCountryMap {
  static const double _minLon = 36.0;
  static const double _maxLon = 43.6;
  static const double _minLat = 12.0;
  static const double _maxLat = 18.3;
  static const double _pad = 0.06;

  /// The four stops, spread left-to-right/top-to-bottom across the map on
  /// request ("sollen nicht zu nah beieinander liegen... ein Pfad von oben
  /// links nach rechts... mit genügend Abstand") rather than at their exact
  /// real coordinates, which sit close enough together (Asmara and Keren
  /// are barely 60km apart in reality) to crowd a small map card - the same
  /// tap-clearance trade-off [EthiopiaMap.geoPositions] already makes for
  /// Sidama/Oromia.
  static const Map<JourneyRegion, GeoPoint> geoPositions = {
    JourneyRegion.keren: GeoPoint(37.2, 16.3), // west, the farming belt
    JourneyRegion.asmara: GeoPoint(38.9, 15.3), // the real capital
    JourneyRegion.massawa: GeoPoint(40.6, 14.0), // the Red Sea port
    JourneyRegion.dahlak: GeoPoint(41.9, 13.1), // the archipelago, furthest offshore/south-east
  };

  static const List<JourneyRegion> order = [
    JourneyRegion.keren,
    JourneyRegion.asmara,
    JourneyRegion.massawa,
    JourneyRegion.dahlak,
  ];

  static _MapTransform _transformFor(Size size) {
    final lonSpan = _maxLon - _minLon;
    final latSpan = _maxLat - _minLat;
    final availableWidth = size.width * (1 - 2 * _pad);
    final availableHeight = size.height * (1 - 2 * _pad);
    final scale = math.min(availableWidth / lonSpan, availableHeight / latSpan);
    final dx = (size.width - lonSpan * scale) / 2;
    final dy = (size.height - latSpan * scale) / 2;
    return _MapTransform(scale: scale, dx: dx, dy: dy);
  }

  static Offset _offsetFor(GeoPoint geo, _MapTransform t) {
    return Offset(t.dx + (geo.lon - _minLon) * t.scale, t.dy + (_maxLat - geo.lat) * t.scale);
  }

  static Map<JourneyRegion, Offset> positions(Size size) {
    final t = _transformFor(size);
    return {for (final entry in geoPositions.entries) entry.key: _offsetFor(entry.value, t)};
  }

  static const List<GeoPoint> _outlineVertices = [
    GeoPoint(38.5, 18.05), // north tip (Karora/Sudan-Red Sea corner) - the sharp spike
    GeoPoint(38.15, 17.75),
    GeoPoint(38.55, 17.5),
    GeoPoint(39.0, 17.0),
    GeoPoint(39.25, 16.5),
    GeoPoint(39.1, 16.15), // small bay notch
    GeoPoint(39.5, 15.85),
    GeoPoint(39.85, 15.55),
    GeoPoint(39.7, 15.2), // Gulf-of-Zula-style notch
    GeoPoint(40.1, 14.95),
    GeoPoint(40.5, 14.55),
    GeoPoint(40.35, 14.2), // small coastal notch
    GeoPoint(40.75, 13.95), // the waist, where the tail narrows off the main body
    GeoPoint(41.2, 13.5), // south-east tail, outbound (coast) side
    GeoPoint(42.2, 12.9),
    GeoPoint(43.25, 12.42), // south-east tip (Ras Dumeira / Djibouti border)
    GeoPoint(42.0, 12.75), // back along the tail's return (southern/Ethiopia border) side
    GeoPoint(41.0, 13.3),
    GeoPoint(39.9, 14.1),
    GeoPoint(39.4, 14.35),
    GeoPoint(38.9, 14.5),
    GeoPoint(38.35, 14.7),
    GeoPoint(37.75, 14.85),
    GeoPoint(37.15, 15.05), // south-west corner, the Sudan border begins
    GeoPoint(36.75, 15.35),
    GeoPoint(36.55, 15.85), // westernmost bulge
    GeoPoint(36.85, 16.25), // small bay notch
    GeoPoint(36.65, 16.65),
    GeoPoint(36.9, 17.05),
    GeoPoint(37.2, 17.4),
    GeoPoint(37.7, 17.7),
    GeoPoint(38.5, 18.05), // close back at the north tip
  ];

  /// The Dahlak archipelago's own small island shapes, offshore of Massawa
  /// - drawn separately from the mainland outline so they read as real
  /// islands (matching the reference outline the user sent) rather than
  /// bumps on the coast.
  static const List<List<GeoPoint>> dahlakIslands = [
    [GeoPoint(40.9, 15.85), GeoPoint(41.3, 15.95), GeoPoint(41.35, 15.65), GeoPoint(41.0, 15.55), GeoPoint(40.85, 15.7)],
    [GeoPoint(41.55, 15.6), GeoPoint(41.75, 15.55), GeoPoint(41.7, 15.35), GeoPoint(41.5, 15.4)],
    [GeoPoint(41.15, 15.2), GeoPoint(41.28, 15.18), GeoPoint(41.25, 15.05), GeoPoint(41.1, 15.08)],
  ];

  static Path _straightClosedShape(List<GeoPoint> vertices, Size size) {
    final t = _transformFor(size);
    final points = [for (final v in vertices) _offsetFor(v, t)];
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }

  static Path outline(Size size) => _straightClosedShape(_outlineVertices, size);

  static List<Path> islands(Size size) => [for (final island in dahlakIslands) _straightClosedShape(island, size)];

  /// A winding road between two stops, built the exact same way
  /// [WorldMapLayout.roadBetween] builds Ethiopia's inter-region roads.
  static Path roadBetween(Size size, JourneyRegion from, JourneyRegion to, {double amplitude = 0.07, int waves = 4}) {
    final positionsForSize = positions(size);
    final start = positionsForSize[from]!;
    final end = positionsForSize[to]!;
    final delta = end - start;
    final length = delta.distance;
    if (length == 0) return Path()..moveTo(start.dx, start.dy);
    final direction = delta / length;
    final perpendicular = Offset(-direction.dy, direction.dx);

    final points = <Offset>[start];
    for (var i = 1; i < waves; i++) {
      final t = i / waves;
      final base = start + delta * t;
      final side = i.isOdd ? 1 : -1;
      points.add(base + perpendicular * (length * amplitude * side));
    }
    points.add(end);

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final mid = Offset((current.dx + next.dx) / 2, (current.dy + next.dy) / 2);
      path.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
      if (i == points.length - 2) {
        path.quadraticBezierTo(next.dx, next.dy, next.dx, next.dy);
      }
    }
    return path;
  }

  static List<Path> allRoads(Size size) => [
        for (var i = 0; i < order.length - 1; i++) roadBetween(size, order[i], order[i + 1]),
      ];
}
