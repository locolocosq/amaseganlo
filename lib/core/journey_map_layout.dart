import 'dart:math' as math;
import 'dart:ui';

import 'journey_regions.dart';

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

/// A uniform lon/lat-to-pixel [scale] plus centring offset ([dx]/[dy]) for
/// one specific canvas size - see [EthiopiaMap._transformFor].
class _MapTransform {
  final double scale;
  final double dx;
  final double dy;
  const _MapTransform({required this.scale, required this.dx, required this.dy});
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
  // canvas border instead of showing its real position. Etappe 22 Nachtrag
  // 4: refit around the real boundary's actual bounding box (lon
  // 32.95-47.79, lat 3.42-14.96) instead of a guessed one.
  //
  // Etappe 24 Nachtrag 5: tightened from a ~1° margin down to ~0.4° (on
  // request - "die Landkarte ist immer noch zu klein") - every GeoPoint
  // above already sits safely inside the *real* boundary polygon itself
  // (see their own comments), so shrinking this outer box towards that
  // polygon's actual bounding box only makes the rendered outline bigger;
  // it can't push a marker closer to clipping, since markers were never
  // anywhere near this box's old, far more generous edge.
  static const double _minLon = 32.5;
  static const double _maxLon = 48.2;
  static const double _minLat = 3.0;
  static const double _maxLat = 15.4;

  // Inset from the canvas edge so markers/outline never touch the border.
  // Etappe 24 Nachtrag 5: trimmed from 0.08 towards the same end as above.
  static const double _pad = 0.045;

  // Real Ethiopian geography clusters Addis Ababa/Oromia/Sidama/Tigray close
  // enough together that their map nodes would overlap - these lon/lat
  // values are pushed apart from their true city centres in exactly that
  // cluster, using the explicit "nicht exakt maßstabsgetreu, aber grob
  // richtig zueinander" (Etappe 22 brief) license: every place keeps its
  // correct rough compass direction from the others, just exaggerated in
  // distance enough to stay tappable as separate nodes on a small phone
  // screen.
  //
  // Etappe 24 Nachtrag: re-derived from scratch with a throwaway
  // point-in-polygon + brute-force search script (not hand-picked) after
  // the marker size shrank (see [RegionNodeMarker]) and Harar's position
  // was reported wrong. Every value below is confirmed to (a) land inside
  // the real boundary polygon WITH a small interior safety margin, not
  // just barely on the coastline, and (b) clear every other place's
  // ~66x121px tap box on at least one axis, at the map's real rendered
  // size (576x341 in the widget-test harness):
  //   - Addis Ababa and Harar now sit at their genuine real coordinates -
  //     no compromise was needed for either once the marker shrank.
  //   - Tigray moved from the Aksum area to Tigray's own north-western
  //     zone (near the Eritrean border) - every real Tigray city close to
  //     Aksum/Mekelle is simply too close to Addis at this map scale for
  //     any marker size to keep both tappable.
  //   - Oromia moved from a spot that was, honestly, already Gambela's
  //     real location (a neighbouring region, not Oromia) to a real point
  //     inside Oromia's own western highlands - a genuine correction, not
  //     just a re-verification.
  //   - Sidama remains pulled well east of Hawassa's real longitude (the
  //     one placement that still needs a real compromise - Sidama, Oromia
  //     and Addis are genuinely close together in reality), and also
  //     further south than Hawassa's own real latitude (Etappe 24
  //     Nachtrag, on request - re-searched for the southernmost latitude
  //     that still clears every other marker, not just nudged by eye) so
  //     it visibly reads as "the South" on the map rather than sitting at
  //     roughly the same height as Addis.
  static const Map<JourneyRegion, GeoPoint> geoPositions = {
    JourneyRegion.addisAbeba: GeoPoint(38.74, 9.03), // the real capital
    JourneyRegion.tigray: GeoPoint(37.98, 14.88), // real Tigray, north-western zone
    JourneyRegion.oromia: GeoPoint(35.62, 7.68), // real Oromia, western highlands
    JourneyRegion.sidama: GeoPoint(45.3, 5.4), // pulled east AND further south to read as "the South"
    JourneyRegion.harar: GeoPoint(42.15, 9.31), // the real city of Harar
    // Etappe 24 Nachtrag 2: the capstone "Safari" stop, placed centered and
    // as far south as the outline allows ("mittig unten" on the map) - a
    // real point inside the South Omo lowlands, re-searched the same way as
    // Sidama's re-placement above for the southernmost/most-centered spot
    // that still clears every other marker's tap-box.
    JourneyRegion.safari: GeoPoint(39.1, 4.9),
  };

  /// One scale factor + centring offset for a given canvas size (Etappe 22
  /// Nachtrag 5) - computed once per paint, then reused for every point.
  /// Using a single [scale] for both axes (the smaller of "fit by width" and
  /// "fit by height") is the whole fix for "die Landkarte wird verzehrt": the
  /// old projection normalized lon and lat to 0..1 independently, which
  /// silently re-stretched the real shape to match whatever aspect ratio the
  /// map card happened to have. Now the shape's true width:height ratio is
  /// always preserved - the map just gets smaller (and letterboxed, via
  /// [dx]/[dy]) on a card whose aspect ratio doesn't match.
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

  /// Every place's pixel position for a given canvas size - recomputed per
  /// paint (positions can no longer be cached size-independently once the
  /// projection stopped normalizing to a 0..1 fraction per axis).
  static Map<JourneyRegion, Offset> positions(Size size) {
    final t = _transformFor(size);
    return {for (final entry in geoPositions.entries) entry.key: _offsetFor(entry.value, t)};
  }

  /// Ethiopia's real national boundary (Etappe 22 Nachtrag 4) - the user
  /// asked explicitly for the outline from a reference map "1:1" instead of
  /// a further hand-stylized guess, so this is the actual boundary polygon
  /// (source: the `johan/world.geo.json` ETH.geo.json dataset, itself
  /// derived from real survey data), used as-is with no smoothing. It's
  /// already a simplified ~58-point polygon, not full-resolution survey
  /// detail, so it stays "nicht zu detailliert" while being the real shape
  /// rather than an approximation of it.
  static const List<GeoPoint> _outlineVertices = [
    GeoPoint(37.90607, 14.95943),
    GeoPoint(38.51295, 14.50547),
    GeoPoint(39.0994, 14.74064),
    GeoPoint(39.34061, 14.53155),
    GeoPoint(40.02625, 14.51959),
    GeoPoint(40.8966, 14.11864),
    GeoPoint(41.1552, 13.77333),
    GeoPoint(41.59856, 13.45209),
    GeoPoint(42.00975, 12.86582),
    GeoPoint(42.35156, 12.54223),
    GeoPoint(42.0, 12.1),
    GeoPoint(41.66176, 11.6312),
    GeoPoint(41.73959, 11.35511),
    GeoPoint(41.75557, 11.05091),
    GeoPoint(42.31414, 11.0342),
    GeoPoint(42.55493, 11.10511),
    GeoPoint(42.776852, 10.926879),
    GeoPoint(42.55876, 10.57258),
    GeoPoint(42.92812, 10.02194),
    GeoPoint(43.29699, 9.54048),
    GeoPoint(43.67875, 9.18358),
    GeoPoint(46.94834, 7.99688), // start of the long, near-straight Somalia border
    GeoPoint(47.78942, 8.003),
    GeoPoint(44.9636, 5.00162),
    GeoPoint(43.66087, 4.95755),
    GeoPoint(42.76967, 4.25259),
    GeoPoint(42.12861, 4.23413),
    GeoPoint(41.855083, 3.918912),
    GeoPoint(41.1718, 3.91909),
    GeoPoint(40.76848, 4.25702),
    GeoPoint(39.85494, 3.83879),
    GeoPoint(39.559384, 3.42206), // southernmost point
    GeoPoint(38.89251, 3.50074),
    GeoPoint(38.67114, 3.61607),
    GeoPoint(38.43697, 3.58851),
    GeoPoint(38.120915, 3.598605),
    GeoPoint(36.855093, 4.447864),
    GeoPoint(36.159079, 4.447864),
    GeoPoint(35.817448, 4.776966),
    GeoPoint(35.817448, 5.338232),
    GeoPoint(35.298007, 5.506),
    GeoPoint(34.70702, 6.59422),
    GeoPoint(34.25032, 6.82607),
    GeoPoint(34.0751, 7.22595),
    GeoPoint(33.56829, 7.71334),
    GeoPoint(32.95418, 7.78497), // westernmost point
    GeoPoint(33.2948, 8.35458),
    GeoPoint(33.8255, 8.37916),
    GeoPoint(33.97498, 8.68456),
    GeoPoint(33.96162, 9.58358),
    GeoPoint(34.25745, 10.63009),
    GeoPoint(34.73115, 10.91017),
    GeoPoint(34.83163, 11.31896),
    GeoPoint(35.26049, 12.08286),
    GeoPoint(35.86363, 12.57828),
    GeoPoint(36.27022, 13.56333),
    GeoPoint(36.42951, 14.42211),
    GeoPoint(37.59377, 14.2131),
    GeoPoint(37.90607, 14.95943), // back to start
  ];

  /// Deliberately oversized neighbouring-territory shapes (Etappe 22
  /// Nachtrag 2, re-fit in Nachtrag 4 to the real outline above) - see
  /// [NeighborLand]. The edge facing Ethiopia directly reuses consecutive
  /// runs of [_outlineVertices] (so it hugs the real border exactly, not an
  /// approximation of it) before sweeping far outside the canvas on every
  /// other edge; Ethiopia's own opaque fill (drawn on top) covers the seam
  /// regardless. Colours are a tight family of near-neutral warm greys
  /// (never green) - on the reference map the user sent, neighbouring
  /// countries are plain background next to Ethiopia's own coloured,
  /// detailed terrain, and that contrast is the point.
  static const List<NeighborLand> neighborLands = [
    // Eritrea, north - hugs the vertices from the NW corner to the start
    // of the Afar wedge.
    NeighborLand(Color(0xFFE2DDD0), [
      GeoPoint(30.0, 20.0),
      GeoPoint(48.0, 20.0),
      GeoPoint(41.1552, 13.77333),
      GeoPoint(40.8966, 14.11864),
      GeoPoint(40.02625, 14.51959),
      GeoPoint(39.34061, 14.53155),
      GeoPoint(39.0994, 14.74064),
      GeoPoint(38.51295, 14.50547),
      GeoPoint(37.90607, 14.95943),
      GeoPoint(37.59377, 14.2131),
      GeoPoint(36.42951, 14.42211),
      GeoPoint(30.0, 20.0),
    ]),
    // Djibouti, the small notch just north of the Afar wedge.
    NeighborLand(Color(0xFFDCD5C0), [
      GeoPoint(41.1552, 13.77333),
      GeoPoint(45.0, 15.0),
      GeoPoint(45.0, 9.5),
      GeoPoint(42.55876, 10.57258),
      GeoPoint(42.776852, 10.926879),
      GeoPoint(42.55493, 11.10511),
      GeoPoint(42.31414, 11.0342),
      GeoPoint(41.75557, 11.05091),
      GeoPoint(41.73959, 11.35511),
      GeoPoint(41.66176, 11.6312),
      GeoPoint(42.0, 12.1),
      GeoPoint(42.35156, 12.54223),
      GeoPoint(42.00975, 12.86582),
      GeoPoint(41.59856, 13.45209),
      GeoPoint(41.1552, 13.77333),
    ]),
    // Somalia, east/south-east - wraps around Ethiopia's long straight
    // south-eastern border.
    NeighborLand(Color(0xFFDFD9C8), [
      GeoPoint(42.55876, 10.57258),
      GeoPoint(48.0, 12.0),
      GeoPoint(51.0, 12.0),
      GeoPoint(51.0, 2.0),
      GeoPoint(41.0, 2.0),
      GeoPoint(42.76967, 4.25259),
      GeoPoint(43.66087, 4.95755),
      GeoPoint(44.9636, 5.00162),
      GeoPoint(47.78942, 8.003),
      GeoPoint(46.94834, 7.99688),
      GeoPoint(43.67875, 9.18358),
      GeoPoint(43.29699, 9.54048),
      GeoPoint(42.92812, 10.02194),
      GeoPoint(42.55876, 10.57258),
    ]),
    // Kenya, south.
    NeighborLand(Color(0xFFD7D2BE), [
      GeoPoint(42.76967, 4.25259),
      GeoPoint(43.0, 1.0),
      GeoPoint(30.0, 1.0),
      GeoPoint(36.855093, 4.447864),
      GeoPoint(38.120915, 3.598605),
      GeoPoint(38.43697, 3.58851),
      GeoPoint(38.67114, 3.61607),
      GeoPoint(38.89251, 3.50074),
      GeoPoint(39.559384, 3.42206),
      GeoPoint(39.85494, 3.83879),
      GeoPoint(40.76848, 4.25702),
      GeoPoint(41.1718, 3.91909),
      GeoPoint(41.855083, 3.918912),
      GeoPoint(42.12861, 4.23413),
      GeoPoint(42.76967, 4.25259),
    ]),
    // Sudan and South Sudan, west (kept as one shape - the distinction
    // doesn't matter at this zoom level).
    NeighborLand(Color(0xFFDAD4C4), [
      GeoPoint(36.855093, 4.447864),
      GeoPoint(30.0, 2.0),
      GeoPoint(28.0, 20.0),
      GeoPoint(38.0, 20.0),
      GeoPoint(36.42951, 14.42211),
      GeoPoint(36.27022, 13.56333),
      GeoPoint(35.86363, 12.57828),
      GeoPoint(35.26049, 12.08286),
      GeoPoint(34.83163, 11.31896),
      GeoPoint(34.73115, 10.91017),
      GeoPoint(34.25745, 10.63009),
      GeoPoint(33.96162, 9.58358),
      GeoPoint(33.97498, 8.68456),
      GeoPoint(33.8255, 8.37916),
      GeoPoint(33.2948, 8.35458),
      GeoPoint(32.95418, 7.78497),
      GeoPoint(33.56829, 7.71334),
      GeoPoint(34.0751, 7.22595),
      GeoPoint(34.25032, 6.82607),
      GeoPoint(34.70702, 6.59422),
      GeoPoint(35.298007, 5.506),
      GeoPoint(35.817448, 5.338232),
      GeoPoint(35.817448, 4.776966),
      GeoPoint(36.159079, 4.447864),
      GeoPoint(36.855093, 4.447864),
    ]),
  ];

  static Path _smoothClosedShape(List<GeoPoint> vertices, Size size) {
    final t = _transformFor(size);
    final points = [for (final v in vertices) _offsetFor(v, t)];
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

  /// Straight-line version of the closed path above, used for Ethiopia's
  /// own outline (Etappe 22 Nachtrag 4) so it stays exactly the real
  /// boundary's shape - the bezier smoothing in [_smoothClosedShape] is
  /// still right for the neighbours (rougher, deliberately less precise
  /// context shapes), but would only soften/distort the real coordinates
  /// here after the user asked for the reference outline "1:1".
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

  static Path neighborPath(NeighborLand land, Size size) => _smoothClosedShape(land.vertices, size);

  /// Projects an arbitrary [GeoPoint] (not necessarily a place or outline
  /// vertex) to canvas pixels - used by [WorldMapPainter] to anchor its
  /// highland/lowland terrain gradient on real geography instead of a
  /// fixed screen direction.
  static Offset projectToOffset(GeoPoint geo, Size size) => _offsetFor(geo, _transformFor(size));
}

/// Layout for the Ebene-1 world map: where each region's node sits, and the
/// order the road connects them in. Etappe 22: reordered so the road sweeps
/// roughly N → SW → S → E instead of crossing itself; Harar was added as a
/// fifth stop (Etappe 24 Nachtrag 2 gave it real B2 content), and Safari as
/// a sixth, final capstone stop - see ENTSCHEIDUNGEN.md. [order] no longer
/// has to equal `Curriculum.sections` in length; [WorldMapScreen] renders
/// any extra entries beyond the curriculum's own sections as a locked
/// "coming soon" placeholder instead of indexing into sections, which is
/// what keeps adding a new stop here safe even before it has content.
class WorldMapLayout {
  static const List<JourneyRegion> order = [
    JourneyRegion.addisAbeba,
    JourneyRegion.tigray,
    JourneyRegion.oromia,
    JourneyRegion.sidama,
    JourneyRegion.harar,
    JourneyRegion.safari,
  ];

  static Map<JourneyRegion, Offset> positions(Size size) => EthiopiaMap.positions(size);

  /// A winding, road-like path between two node positions (Etappe 24) -
  /// several waypoints alternating side to side along the straight line
  /// from [from] to [to], threaded into one smooth curve the same way
  /// [RegionMapLayout.smoothPathThrough] does for the region-detail path.
  /// The single quadratic-bezier "bow" this replaced only ever produced one
  /// gentle arc - closer to a flight path than an actual drive - and read
  /// as too straight/artificial once the road itself got thinner. Every
  /// offset is a fraction of the segment's own length, so short and long
  /// hops both wind by roughly the same visual amount regardless of screen
  /// size or how far apart two regions happen to be.
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
