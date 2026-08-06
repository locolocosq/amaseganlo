import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/journey_map_layout.dart';
import '../../core/journey_regions.dart';
import 'painter_helpers.dart';

/// Background of the Ebene-1 world map: a soft "painted paper map" terrain
/// with a colour-tinted zone behind each region, a winding road threading
/// through all four in curriculum order, and light decorative scatter
/// (rocks, huts, trees, clouds) so it doesn't read as an empty canvas with
/// dots on it. Deliberately static/non-interactive - the tappable region
/// nodes are real widgets drawn on top by [WorldMapScreen].
class WorldMapPainter extends CustomPainter {
  const WorldMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(0, 0, size.width, size.height);
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
      }
    }
  }

  @override
  bool shouldRepaint(covariant WorldMapPainter oldDelegate) => false;
}
