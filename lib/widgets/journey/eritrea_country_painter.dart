import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/eritrea_map_layout.dart';
import '../../core/journey_regions.dart';
import 'painter_helpers.dart';

/// Background of Eritrea's own top-level country map (Etappe 27) - the
/// sibling to [WorldMapPainter], built the same way (a filled outline, a
/// per-region accent glow, scattered decoration, a road) but for
/// [EritreaCountryMap]'s four stops instead of Ethiopia's six. Kept as an
/// independent painter rather than a generalisation of [WorldMapPainter]
/// for the same reason [EritreaCountryMap] stays independent of
/// [EthiopiaMap]/[WorldMapLayout] - see that class's doc comment.
class EritreaCountryPainter extends CustomPainter {
  const EritreaCountryPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(0, 0, size.width, size.height);
    // The Red Sea to the east/south-east is the backdrop everything else
    // sits in front of - a cool marine blue, distinct from Ethiopia's warm
    // neutral "rest of the world" backdrop.
    canvas.drawRect(
      area,
      Paint()
        ..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: const [Color(0xFFCDE8EF), Color(0xFFA9D5E0)]).createShader(area),
    );

    final outline = EritreaCountryMap.outline(size);
    canvas.save();
    canvas.clipPath(outline);
    // West (Keren's farming belt) reads green/highland, east (Massawa's
    // coast) reads warm sandy - a west-to-east gradient anchored on real
    // geo points, the same technique WorldMapPainter uses for Ethiopia's
    // highland/lowland split.
    final westFocus = EritreaCountryMap.positions(size)[JourneyRegion.keren]!;
    final eastFocus = EritreaCountryMap.positions(size)[JourneyRegion.massawa]!;
    canvas.drawRect(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: _toAlignment(westFocus, size),
          end: _toAlignment(eastFocus, size),
          colors: const [Color(0xFFC7DA9E), Color(0xFFE6C99A), Color(0xFFFBDDA8)],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(area),
    );
    canvas.restore();

    for (final islandPath in EritreaCountryMap.islands(size)) {
      canvas.drawPath(islandPath, Paint()..color = const Color(0xFFE8D9A8));
    }

    final positions = EritreaCountryMap.positions(size);
    for (final region in EritreaCountryMap.order) {
      final center = positions[region]!;
      final radius = size.shortestSide * 0.34;
      final paint = Paint()
        ..shader = RadialGradient(colors: [region.accent.withValues(alpha: 0.28), region.accent.withValues(alpha: 0.0)])
            .createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    for (final region in EritreaCountryMap.order) {
      _decorateZone(canvas, size, positions[region]!, region);
    }

    for (final road in EritreaCountryMap.allRoads(size)) {
      Sketch.road(canvas, road, width: 9);
    }

    final rng = Sketch.seededRandom(19);
    for (var i = 0; i < 4; i++) {
      final cx = size.width * (0.08 + rng.nextDouble() * 0.84);
      final cy = size.height * (0.04 + rng.nextDouble() * 0.10);
      Sketch.cloud(canvas, Offset(cx, cy), 1.0 + rng.nextDouble() * 0.5, color: const Color(0xCCFFFFFF));
    }
  }

  void _decorateZone(Canvas canvas, Size size, Offset center, JourneyRegion region) {
    final rng = Sketch.seededRandom(region.index * 97 + 11);
    for (var i = 0; i < 3; i++) {
      final angle = rng.nextDouble() * math.pi * 2;
      final distance = size.shortestSide * (0.12 + rng.nextDouble() * 0.08);
      final spot = center + Offset(math.cos(angle) * distance, math.sin(angle) * distance * 0.6);
      switch (region) {
        case JourneyRegion.keren:
          Sketch.acacia(canvas, spot, 0.7 + rng.nextDouble() * 0.4);
          break;
        case JourneyRegion.asmara:
          Sketch.rock(canvas, spot, 0.7 + rng.nextDouble() * 0.3, color: const Color(0xFFD97B66));
          break;
        case JourneyRegion.massawa:
          Sketch.palm(canvas, spot, 0.7 + rng.nextDouble() * 0.4);
          break;
        case JourneyRegion.dahlak:
          if (i == 0) Sketch.palm(canvas, spot, 0.55);
          break;
        // These four never appear in EritreaCountryMap.order - kept only so
        // this switch stays exhaustive over every JourneyRegion value.
        case JourneyRegion.addisAbeba:
        case JourneyRegion.oromia:
        case JourneyRegion.tigray:
        case JourneyRegion.sidama:
        case JourneyRegion.harar:
        case JourneyRegion.safari:
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant EritreaCountryPainter oldDelegate) => false;
}

Alignment _toAlignment(Offset offset, Size size) {
  return Alignment((offset.dx / size.width) * 2 - 1, (offset.dy / size.height) * 2 - 1);
}
