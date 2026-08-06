import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/journey_map_layout.dart';
import '../../core/journey_regions.dart';
import 'painter_helpers.dart';

/// Background of the Ebene-1 world map: a stylized Ethiopia silhouette
/// (Etappe 22, deliberately not accurate cartography) filled with a soft
/// "painted paper map" terrain, a colour-tinted zone behind each region, a
/// winding road threading through them in journey order, and light
/// decorative scatter (rocks, huts, trees, clouds) so it doesn't read as an
/// empty canvas with dots on it. Deliberately static/non-interactive - the
/// tappable region nodes are real widgets drawn on top by [WorldMapScreen].
class WorldMapPainter extends CustomPainter {
  const WorldMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(0, 0, size.width, size.height);
    // A neutral "rest of the world" backdrop first (Etappe 22 Nachtrag 2:
    // previously this was the exact same cream the terrain gradient faded
    // into further down, so the coastline all but disappeared in the lower
    // half of the map - now it's a cool, clearly different neutral from
    // every neighbouring shade below).
    canvas.drawRect(area, Paint()..color = const Color(0xFFE9E7DE));

    // Stylized neighbouring countries (Etappe 22 Nachtrag 2): drawn before
    // Ethiopia's own terrain so the outline reads as "a country bordered by
    // other countries" instead of floating alone on an empty backdrop -
    // without this context there was nothing for the eye to recognize the
    // shape *against*. Each is a muted sandy/arid tone, deliberately never
    // green, so Ethiopia's highland fill still stands out as the country in
    // focus.
    for (final land in EthiopiaMap.neighborLands) {
      final path = EthiopiaMap.neighborPath(land, size);
      canvas.drawPath(path, Paint()..color = land.color);
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = const Color(0x22000000),
      );
    }

    final outline = EthiopiaMap.outline(size);
    canvas.save();
    canvas.clipPath(outline);
    // Real Ethiopia is green highland in the centre/north-west (Addis,
    // Lalibela, the highland coffee country) fading to arid brown toward
    // the east/south-east (the Somali lowlands) - a reference relief map
    // the user sent showed this clearly, and a flat top-to-bottom gradient
    // (the previous approach) didn't capture it at all. The gradient's
    // begin/end points are real geo positions, not screen corners, so the
    // green/brown split lands in the right place regardless of the map
    // card's aspect ratio.
    final highlandFocus = EthiopiaMap.projectToOffset(const GeoPoint(37.0, 11.5), size);
    final lowlandFocus = EthiopiaMap.projectToOffset(const GeoPoint(46.5, 6.5), size);
    canvas.drawRect(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: _toAlignment(highlandFocus, size),
          end: _toAlignment(lowlandFocus, size),
          colors: const [Color(0xFFBFDD97), Color(0xFFCBC17E), Color(0xFFC2895A)],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(area),
    );
    canvas.restore();

    // Everything functional (glow, decoration, road) is drawn AFTER
    // restoring the clip, deliberately never confined to the outline: the
    // outline is a rough stylized silhouette, not a precise boundary, and
    // clipping the road to it risked visibly cutting the road off before
    // it reached a marker sitting right at (or just past) the coastline -
    // exactly the "keine Straßenbindung" bug a real device test found.
    final positions = WorldMapLayout.positions(size);
    for (final region in WorldMapLayout.order) {
      final center = positions[region]!;
      final radius = size.shortestSide * 0.32;
      final paint = Paint()
        ..shader = RadialGradient(colors: [region.accent.withValues(alpha: 0.28), region.accent.withValues(alpha: 0.0)])
            .createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    for (final region in WorldMapLayout.order) {
      _decorateZone(canvas, size, positions[region]!, region);
    }

    for (final road in WorldMapLayout.allRoads(size)) {
      Sketch.road(canvas, road);
    }

    // A clear outline stroke around the country shape for definition (a bit
    // bolder than the neighbours' own borders above, so Ethiopia still
    // visually leads), and clouds drifting over the top edge.
    canvas.drawPath(
      outline,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = const Color(0x59000000),
    );

    final rng = Sketch.seededRandom(7);
    for (var i = 0; i < 5; i++) {
      final cx = size.width * (0.08 + rng.nextDouble() * 0.84);
      final cy = size.height * (0.04 + rng.nextDouble() * 0.10);
      Sketch.cloud(canvas, Offset(cx, cy), 1.1 + rng.nextDouble() * 0.6, color: const Color(0xCCFFFFFF));
    }
  }

  void _decorateZone(Canvas canvas, Size size, Offset center, JourneyRegion region) {
    final rng = Sketch.seededRandom(region.index * 97 + 11);
    for (var i = 0; i < 4; i++) {
      final angle = rng.nextDouble() * math.pi * 2;
      final distance = size.shortestSide * (0.14 + rng.nextDouble() * 0.10);
      final spot = center + Offset(math.cos(angle) * distance, math.sin(angle) * distance * 0.6);
      switch (region) {
        case JourneyRegion.addisAbeba:
          Sketch.rock(canvas, spot, 0.8 + rng.nextDouble() * 0.4);
          break;
        case JourneyRegion.oromia:
          Sketch.acacia(canvas, spot, 0.7 + rng.nextDouble() * 0.5);
          break;
        case JourneyRegion.tigray:
          Sketch.rock(canvas, spot, 0.9 + rng.nextDouble() * 0.5, color: const Color(0xFFB98363));
          break;
        case JourneyRegion.sidama:
          Sketch.palm(canvas, spot, 0.6 + rng.nextDouble() * 0.5);
          break;
        case JourneyRegion.harar:
          // No real content yet (Etappe 22) - deliberately left undecorated
          // rather than inventing a themed scene for a place that hasn't
          // been designed yet; the muted grey glow (region.accent) is the
          // only visual it gets until real content arrives.
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant WorldMapPainter oldDelegate) => false;
}

/// Converts an absolute canvas offset into the -1..1 [Alignment] a
/// [Gradient] expects, so a [LinearGradient] can be anchored on real
/// projected geo-points instead of only the four corners/edges Alignment's
/// named constants cover.
Alignment _toAlignment(Offset offset, Size size) {
  return Alignment((offset.dx / size.width) * 2 - 1, (offset.dy / size.height) * 2 - 1);
}
