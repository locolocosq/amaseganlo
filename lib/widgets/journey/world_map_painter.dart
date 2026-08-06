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
    // A plain "outside the country" backdrop first, then everything else
    // clipped to the outline - the terrain itself ends up shaped like
    // Ethiopia instead of a separate watermark competing with it, which is
    // what keeps this "dezent" (subtle) per the brief rather than adding a
    // second, busier layer on top of the existing map.
    canvas.drawRect(area, Paint()..color = const Color(0xFFF3EFDD));

    final outline = EthiopiaMap.outline(size);
    canvas.save();
    canvas.clipPath(outline);
    Sketch.sky(canvas, area, const Color(0xFFCDEBD4), const Color(0xFFF3EFDD));

    for (final region in WorldMapLayout.order) {
      final center = WorldMapLayout.positions[region]!.toOffset(size);
      final radius = size.shortestSide * 0.32;
      final paint = Paint()
        ..shader = RadialGradient(colors: [region.accent.withValues(alpha: 0.28), region.accent.withValues(alpha: 0.0)])
            .createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    for (final region in WorldMapLayout.order) {
      _decorateZone(canvas, size, region);
    }

    for (final road in WorldMapLayout.allRoads(size)) {
      Sketch.road(canvas, road);
    }
    canvas.restore();

    // A quiet outline stroke around the country shape for definition, and
    // clouds drifting over the top edge - both outside the clip so they sit
    // above the "map paper" and aren't cut off by the coastline-like edge.
    canvas.drawPath(
      outline,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0x33000000),
    );

    final rng = Sketch.seededRandom(7);
    for (var i = 0; i < 5; i++) {
      final cx = size.width * (0.08 + rng.nextDouble() * 0.84);
      final cy = size.height * (0.04 + rng.nextDouble() * 0.10);
      Sketch.cloud(canvas, Offset(cx, cy), 1.1 + rng.nextDouble() * 0.6, color: const Color(0xCCFFFFFF));
    }
  }

  void _decorateZone(Canvas canvas, Size size, JourneyRegion region) {
    final center = WorldMapLayout.positions[region]!.toOffset(size);
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
