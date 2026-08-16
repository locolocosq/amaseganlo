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
/// The outline below is Eritrea's real national boundary (Etappe 27
/// Nachtrag 4) - after two rounds of hand-authored approximation (Nachtrag
/// 2/3), the user asked for the outline "1:1 wie die echte Erta[sic]
/// Landkarte", exactly the same request that got [EthiopiaMap.outline] its
/// real boundary (Etappe 22 Nachtrag 4). Same source and same treatment:
/// the `johan/world.geo.json` dataset's `ERI.geo.json` (real survey-derived
/// data, CC0), used as-is with no smoothing or densifying. It's already a
/// simplified ~27-point polygon, not full-resolution survey detail - a
/// deliberately lower point count than Nachtrag 3's densified 100, but
/// this time because it's what the actual boundary data has, not a
/// hand-picked round number. Several vertices are byte-identical to ones
/// in [EthiopiaMap.outline] (e.g. `GeoPoint(42.35156, 12.54223)`) - the
/// shared Ethiopia-Eritrea border, confirming both come from the same
/// consistent, real dataset rather than two independent guesses that
/// happen to be close.
///
/// Doesn't include the Dahlak archipelago as separate island geometry
/// (this simplified mainland-only dataset doesn't carry it) - `islands()`
/// below still draws them as their own hand-authored shapes, unchanged
/// from Etappe 27.
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
    JourneyRegion.massawa: GeoPoint(40.4, 14.4), // the Red Sea port (nudged inland of the old
    // hand-drawn outline in Etappe 27 Nachtrag 4 - the real coastline here sits further west, and
    // the old spot fell just outside the now-accurate mainland shape)
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
    GeoPoint(42.35156, 12.54223), // shared Ethiopia-Eritrea border point (see EthiopiaMap.outline)
    GeoPoint(42.00975, 12.86582), // shared border point
    GeoPoint(41.59856, 13.45209), // shared border point
    GeoPoint(41.155194, 13.77332),
    GeoPoint(40.8966, 14.11864), // shared border point
    GeoPoint(40.026219, 14.519579),
    GeoPoint(39.34061, 14.53155), // shared border point
    GeoPoint(39.0994, 14.74064), // shared border point
    GeoPoint(38.51295, 14.50547), // shared border point
    GeoPoint(37.90607, 14.95943), // shared border point
    GeoPoint(37.59377, 14.2131),
    GeoPoint(36.42951, 14.42211),
    GeoPoint(36.323189, 14.822481),
    GeoPoint(36.75386, 16.291874), // westernmost bulge, the Sudan border
    GeoPoint(36.85253, 16.95655),
    GeoPoint(37.16747, 17.26314),
    GeoPoint(37.904, 17.42754),
    GeoPoint(38.41009, 17.998307), // north tip (Karora/Sudan-Red Sea corner)
    GeoPoint(38.990623, 16.840626),
    GeoPoint(39.26611, 15.922723),
    GeoPoint(39.814294, 15.435647),
    GeoPoint(41.179275, 14.49108),
    GeoPoint(41.734952, 13.921037),
    GeoPoint(42.276831, 13.343992),
    GeoPoint(42.589576, 13.000421),
    GeoPoint(43.081226, 12.699639), // south-east tail, the Djibouti border
    GeoPoint(42.779642, 12.455416),
    GeoPoint(42.35156, 12.54223), // back to start
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
