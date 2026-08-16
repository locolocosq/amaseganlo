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
///
/// 100 points (Etappe 27 Nachtrag 3, on request - up from the 31 of
/// Nachtrag 2): the same 31-point silhouette above, densified by
/// subdividing each edge and adding small perpendicular jitter so the
/// coastline reads as naturally jagged rather than a smooth spline, with
/// jitter kept deliberately small around the narrow south-eastern tail to
/// avoid reintroducing the self-crossing Nachtrag 2 already had to fix
/// there. Verified programmatically (no screenshot possible in this
/// environment, see Nachtrag 2) to still be a simple, non-self-intersecting
/// polygon with the same overall shape and winding direction.
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
    GeoPoint(38.5000, 18.0500), // north tip (Karora/Sudan-Red Sea corner) - the sharp spike
    GeoPoint(38.3842, 17.9490),
    GeoPoint(38.2466, 17.8735),
    GeoPoint(38.1500, 17.7500),
    GeoPoint(38.2659, 17.6388),
    GeoPoint(38.3988, 17.5548),
    GeoPoint(38.5500, 17.5000),
    GeoPoint(38.6501, 17.3638),
    GeoPoint(38.8101, 17.2816),
    GeoPoint(38.8591, 17.0994),
    GeoPoint(39.0000, 17.0000),
    GeoPoint(39.0896, 16.8885),
    GeoPoint(39.0893, 16.7322),
    GeoPoint(39.1684, 16.6155),
    GeoPoint(39.2500, 16.5000),
    GeoPoint(39.1527, 16.3345),
    GeoPoint(39.1000, 16.1500), // small bay notch
    GeoPoint(39.2501, 16.0724),
    GeoPoint(39.3615, 15.9430),
    GeoPoint(39.5000, 15.8500),
    GeoPoint(39.6194, 15.7532),
    GeoPoint(39.7583, 15.6791),
    GeoPoint(39.8500, 15.5500),
    GeoPoint(39.7699, 15.3772),
    GeoPoint(39.7000, 15.2000), // Gulf-of-Zula-style notch
    GeoPoint(39.8174, 15.0912),
    GeoPoint(39.9632, 15.0278),
    GeoPoint(40.1000, 14.9500),
    GeoPoint(40.2187, 14.8687),
    GeoPoint(40.2871, 14.7371),
    GeoPoint(40.3865, 14.6365),
    GeoPoint(40.5000, 14.5500),
    GeoPoint(40.4353, 14.3706),
    GeoPoint(40.3500, 14.2000), // small coastal notch
    GeoPoint(40.4635, 14.0850),
    GeoPoint(40.6400, 14.0707),
    GeoPoint(40.7500, 13.9500), // the waist, where the tail narrows off the main body
    GeoPoint(40.9009, 13.8009),
    GeoPoint(41.0547, 13.6547),
    GeoPoint(41.2000, 13.5000), // south-east tail, outbound (coast) side
    GeoPoint(41.5342, 13.3014),
    GeoPoint(41.8615, 13.0914),
    GeoPoint(42.2000, 12.9000),
    GeoPoint(42.5520, 12.7444),
    GeoPoint(42.9037, 12.5881),
    GeoPoint(43.2500, 12.4200), // south-east tip (Ras Dumeira / Djibouti border)
    GeoPoint(42.8327, 12.5276), // back along the tail's return (southern/Ethiopia border) side
    GeoPoint(42.4170, 12.6414),
    GeoPoint(42.0000, 12.7500),
    GeoPoint(41.6650, 12.9303),
    GeoPoint(41.3291, 13.1090),
    GeoPoint(41.0000, 13.3000),
    GeoPoint(40.6306, 13.5629),
    GeoPoint(40.2609, 13.8254),
    GeoPoint(39.9000, 14.1000),
    GeoPoint(39.7333, 14.1833),
    GeoPoint(39.5653, 14.2640),
    GeoPoint(39.4000, 14.3500),
    GeoPoint(39.2378, 14.4149),
    GeoPoint(39.0623, 14.4354),
    GeoPoint(38.9000, 14.5000),
    GeoPoint(38.7557, 14.5314),
    GeoPoint(38.6334, 14.6230),
    GeoPoint(38.5004, 14.6855),
    GeoPoint(38.3500, 14.7000),
    GeoPoint(38.2029, 14.7493),
    GeoPoint(38.0410, 14.7392),
    GeoPoint(37.8954, 14.7939),
    GeoPoint(37.7500, 14.8500),
    GeoPoint(37.6011, 14.9032),
    GeoPoint(37.4642, 14.9927),
    GeoPoint(37.3120, 15.0359),
    GeoPoint(37.1500, 15.0500), // south-west corner, the Sudan border begins
    GeoPoint(37.0362, 15.1760),
    GeoPoint(36.8961, 15.2670),
    GeoPoint(36.7500, 15.3500),
    GeoPoint(36.6728, 15.4641),
    GeoPoint(36.6324, 15.5930),
    GeoPoint(36.5667, 15.7117),
    GeoPoint(36.5500, 15.8500), // westernmost bulge
    GeoPoint(36.6324, 15.9965),
    GeoPoint(36.7774, 16.0961),
    GeoPoint(36.8500, 16.2500), // small bay notch
    GeoPoint(36.8173, 16.4003),
    GeoPoint(36.7361, 16.5264),
    GeoPoint(36.6500, 16.6500),
    GeoPoint(36.6957, 16.8068),
    GeoPoint(36.8437, 16.8998),
    GeoPoint(36.9000, 17.0500),
    GeoPoint(36.9809, 17.1830),
    GeoPoint(37.1272, 17.2600),
    GeoPoint(37.2000, 17.4000),
    GeoPoint(37.3303, 17.4662),
    GeoPoint(37.4290, 17.5850),
    GeoPoint(37.5798, 17.6169),
    GeoPoint(37.7000, 17.7000),
    GeoPoint(37.8687, 17.7502),
    GeoPoint(38.0246, 17.8295),
    GeoPoint(38.1642, 17.9461),
    GeoPoint(38.3335, 17.9948),
    GeoPoint(38.5000, 18.0500), // close back at the north tip
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
