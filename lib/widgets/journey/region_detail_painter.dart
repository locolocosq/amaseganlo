import 'package:flutter/material.dart';

import '../../core/journey_map_layout.dart';
import '../../core/journey_regions.dart';
import 'painter_helpers.dart';

/// Background of the Ebene-2 region-detail map: a tall, scrollable,
/// region-themed "terrain" with the winding path drawn through it and
/// scattered decoration alongside (not on top of) the path, so numbered
/// station markers drawn above this by [RegionDetailScreen] stay readable.
class RegionDetailPainter extends CustomPainter {
  final JourneyRegion region;
  final List<StationLayoutPoint> stations;
  final Path road;

  RegionDetailPainter({required this.region, required this.stations, required this.road});

  (Color, Color) get _groundColors {
    switch (region) {
      case JourneyRegion.addisAbeba:
        return (const Color(0xFFEFE3CC), const Color(0xFFDCCBA0));
      case JourneyRegion.oromia:
        return (const Color(0xFFDCEFC9), const Color(0xFFB9DE9C));
      case JourneyRegion.tigray:
        return (const Color(0xFFF0DCC0), const Color(0xFFDCB98C));
      case JourneyRegion.sidama:
        return (const Color(0xFFCDEFE0), const Color(0xFFA6DEC7));
      case JourneyRegion.harar:
        // Not reachable yet in practice - Harar has no region-detail
        // screen content (Etappe 22) - kept muted/grey for consistency
        // with its other "not designed yet" placeholders.
        return (const Color(0xFFE4E4E4), const Color(0xFFCACACA));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(0, 0, size.width, size.height);
    final (top, bottom) = _groundColors;
    Sketch.sky(canvas, area, top, bottom);

    final rng = Sketch.seededRandom(region.index * 733 + 5);
    for (var i = 0; i < (size.height / 260).ceil(); i++) {
      final cx = size.width * (0.1 + rng.nextDouble() * 0.8);
      final cy = size.height * (i + rng.nextDouble()) / (size.height / 260);
      final blobColor = region.accent.withValues(alpha: 0.10);
      canvas.drawCircle(Offset(cx, cy), size.width * (0.3 + rng.nextDouble() * 0.2), Paint()..color = blobColor);
    }

    Sketch.road(canvas, road, width: 26);

    _scatterDecoration(canvas, size);

    for (var i = 0; i < stations.length; i += 7) {
      Sketch.cloud(canvas, Offset(size.width * (i.isEven ? 0.14 : 0.86), stations[i].position.dy - 70), 1.3, color: const Color(0xB3FFFFFF));
    }
  }

  void _scatterDecoration(Canvas canvas, Size size) {
    final rng = Sketch.seededRandom(region.index * 211 + 3);
    for (var i = 0; i < stations.length - 1; i++) {
      final a = stations[i].position;
      final b = stations[i + 1].position;
      final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
      final side = i.isEven ? 1 : -1;
      final offset = mid + Offset(side * (58 + rng.nextDouble() * 34), (rng.nextDouble() - 0.5) * 30);
      final clamped = Offset(offset.dx.clamp(24, size.width - 24), offset.dy);
      final scale = 0.7 + rng.nextDouble() * 0.5;
      switch (region) {
        case JourneyRegion.addisAbeba:
          if (i % 3 == 0) {
            Sketch.rock(canvas, clamped, scale);
          } else {
            _miniBuilding(canvas, clamped, scale);
          }
          break;
        case JourneyRegion.oromia:
          if (i % 2 == 0) {
            Sketch.acacia(canvas, clamped, scale);
          } else {
            Sketch.tukul(canvas, clamped, scale);
          }
          break;
        case JourneyRegion.tigray:
          Sketch.rock(canvas, clamped, scale, color: const Color(0xFFB98363));
          break;
        case JourneyRegion.sidama:
          if (i % 2 == 0) {
            Sketch.palm(canvas, clamped, scale);
          } else {
            Sketch.tukul(canvas, clamped, scale * 0.9);
          }
          break;
        case JourneyRegion.harar:
          Sketch.rock(canvas, clamped, scale, color: const Color(0xFFB0B0B0));
          break;
      }
    }
  }

  void _miniBuilding(Canvas canvas, Offset base, double scale) {
    final rect = Rect.fromLTWH(base.dx - 12 * scale, base.dy - 26 * scale, 24 * scale, 26 * scale);
    canvas.drawRect(rect, Paint()..color = const Color(0xFF8D99AE));
    final windowPaint = Paint()..color = const Color(0xFFFFE9A8);
    for (var r = 0; r < 2; r++) {
      canvas.drawRect(Rect.fromLTWH(rect.left + rect.width * 0.2, rect.top + rect.height * (0.2 + r * 0.4), rect.width * 0.25, rect.height * 0.2), windowPaint);
      canvas.drawRect(Rect.fromLTWH(rect.left + rect.width * 0.55, rect.top + rect.height * (0.2 + r * 0.4), rect.width * 0.25, rect.height * 0.2), windowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant RegionDetailPainter oldDelegate) => oldDelegate.region != region || oldDelegate.stations.length != stations.length;
}
