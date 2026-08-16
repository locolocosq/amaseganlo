import 'package:flutter/material.dart';

import 'painter_helpers.dart';

/// Background of Eritrea's own top-level map page (Etappe 27) - the Red Sea
/// coast scene the region's own medallion already uses ([RegionIconPainter],
/// `region_node_marker.dart`), just filling the whole card instead of a
/// small circle, so this page reads as "its own place" rather than a
/// zoomed-in region node. Deliberately much simpler than [WorldMapPainter]:
/// there is only one stop here, so none of that painter's multi-region
/// geo-projection/road machinery applies - a single wide coastal vista is
/// the whole picture.
class EritreaMapPainter extends CustomPainter {
  const EritreaMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(0, 0, size.width, size.height);
    Sketch.sky(canvas, area, const Color(0xFFFFD9A0), const Color(0xFFB8DDE8));
    Sketch.lake(canvas, area, 0.62);

    final rng = Sketch.seededRandom(41);
    for (var i = 0; i < 4; i++) {
      final x = area.width * (0.08 + i * 0.24 + rng.nextDouble() * 0.06);
      final y = area.height * (0.66 + rng.nextDouble() * 0.18);
      Sketch.palm(canvas, Offset(x, y), 0.8 + rng.nextDouble() * 0.5);
    }
    for (var i = 0; i < 3; i++) {
      final x = area.width * (0.15 + i * 0.32 + rng.nextDouble() * 0.08);
      final y = area.height * (0.86 + rng.nextDouble() * 0.08);
      Sketch.rock(canvas, Offset(x, y), 0.7 + rng.nextDouble() * 0.4);
    }

    final towerX = area.width * 0.80;
    final towerBase = area.height * 0.62;
    canvas.drawRect(
      Rect.fromLTWH(towerX - area.width * 0.018, towerBase - area.height * 0.26, area.width * 0.036, area.height * 0.26),
      Paint()..color = const Color(0xFFF3F7FA),
    );
    canvas.drawRect(
      Rect.fromLTWH(towerX - area.width * 0.03, towerBase - area.height * 0.31, area.width * 0.06, area.height * 0.05),
      Paint()..color = const Color(0xFFB8492E),
    );

    for (var i = 0; i < 4; i++) {
      final cx = area.width * (0.1 + rng.nextDouble() * 0.8);
      final cy = area.height * (0.05 + rng.nextDouble() * 0.12);
      Sketch.cloud(canvas, Offset(cx, cy), 1.0 + rng.nextDouble() * 0.5, color: const Color(0xCCFFFFFF));
    }
  }

  @override
  bool shouldRepaint(covariant EritreaMapPainter oldDelegate) => false;
}
