import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Shared hand-drawn vector "building blocks" for the journey map (Etappe
/// 14) - sky gradients, hills, huts, palms, mountains, and the bus shape.
/// Kept separate from [JourneyStopBanner]'s painter (which stays untouched
/// and tested as-is) so both can draw in the same friendly, flat-vector
/// style without one refactor risking the other's existing tests.
/// All functions take a `Size`/reference scale so shapes stay proportional
/// at any canvas size, matching the fractional-coordinate convention used
/// throughout this file.
class Sketch {
  static void sky(Canvas canvas, Rect area, Color top, Color bottom) {
    final paint = Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom]).createShader(area);
    canvas.drawRect(area, paint);
  }

  static void cloud(Canvas canvas, Offset center, double scale, {Color color = const Color(0xE6FFFFFF)}) {
    final paint = Paint()..color = color;
    canvas.drawCircle(center, 16 * scale, paint);
    canvas.drawCircle(center + Offset(14 * scale, 2 * scale), 12 * scale, paint);
    canvas.drawCircle(center + Offset(-14 * scale, 3 * scale), 11 * scale, paint);
    canvas.drawCircle(center + Offset(4 * scale, -8 * scale), 10 * scale, paint);
  }

  /// A rolling hill silhouette filling from `baseline` down to the bottom
  /// of `area`.
  static void hill(Canvas canvas, Rect area, Color color, double baseline, double bulge, {double leftLean = 0.3, double rightLean = 0.7}) {
    final path = Path()
      ..moveTo(area.left, area.bottom)
      ..lineTo(area.left, area.top + area.height * baseline)
      ..cubicTo(
        area.left + area.width * leftLean, area.top + area.height * (baseline - bulge),
        area.left + area.width * rightLean, area.top + area.height * (baseline - bulge),
        area.right, area.top + area.height * baseline,
      )
      ..lineTo(area.right, area.bottom)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  static void jaggedRange(Canvas canvas, Rect area, Color color, double baseline, List<double> peaks) {
    final path = Path()..moveTo(area.left, area.bottom);
    path.lineTo(area.left, area.top + area.height * baseline);
    final step = area.width / (peaks.length - 1);
    for (var i = 0; i < peaks.length; i++) {
      path.lineTo(area.left + step * i, area.top + area.height * (baseline - peaks[i]));
    }
    path.lineTo(area.right, area.bottom);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  /// A round-walled tukul hut with a conical thatch roof.
  static void tukul(Canvas canvas, Offset base, double scale, {Color wall = const Color(0xFFD8B37C), Color roof = const Color(0xFF6B4A2E)}) {
    final wallRadius = 14.0 * scale;
    final wallCenter = Offset(base.dx, base.dy - wallRadius * 0.6);
    canvas.drawOval(Rect.fromCenter(center: wallCenter, width: wallRadius * 2, height: wallRadius * 1.6), Paint()..color = wall);
    final roofPath = Path()
      ..moveTo(wallCenter.dx - wallRadius * 1.3, wallCenter.dy - wallRadius * 0.4)
      ..lineTo(wallCenter.dx, wallCenter.dy - wallRadius * 2.4)
      ..lineTo(wallCenter.dx + wallRadius * 1.3, wallCenter.dy - wallRadius * 0.4)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = roof);
  }

  static void acacia(Canvas canvas, Offset base, double scale) {
    final top = Offset(base.dx, base.dy - 26 * scale);
    canvas.drawLine(base, top, Paint()
      ..color = const Color(0xFF4A3324)
      ..strokeWidth = 3 * scale);
    canvas.drawOval(Rect.fromCenter(center: top + Offset(0, -2 * scale), width: 34 * scale, height: 13 * scale), Paint()..color = const Color(0xFF3C6E2E));
  }

  static void palm(Canvas canvas, Offset base, double scale) {
    final trunkTop = base + Offset(2 * scale, -32 * scale);
    final trunkPath = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(base.dx + 3 * scale, (base.dy + trunkTop.dy) / 2, trunkTop.dx, trunkTop.dy);
    canvas.drawPath(trunkPath, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * scale
      ..color = const Color(0xFF6B4A2E));
    for (final angle in [-0.9, -0.4, 0.0, 0.4, 0.9]) {
      final dx = 16 * scale * (1 - angle.abs() * 0.3) * (angle < 0 ? -1 : (angle == 0 ? 0.02 : 1));
      final dy = -13 * scale - 7 * scale * (1 - angle.abs());
      canvas.drawLine(trunkTop, trunkTop + Offset(dx, dy), Paint()
        ..color = const Color(0xFF2F6B3A)
        ..strokeWidth = 1.6 * scale
        ..strokeCap = StrokeCap.round);
    }
  }

  /// A small two-peak mountain silhouette with a snow cap on the taller
  /// peak - a compact scatter-decoration counterpart to [rock]/[acacia]
  /// (Etappe 24), for regions whose real landscape is mountainous rather
  /// than flat/wooded. The bigger [jaggedRange] stays the right tool for a
  /// full background mountain range; this is sized to be scattered
  /// alongside other small decorations instead.
  static void smallMountain(Canvas canvas, Offset base, double scale, {Color color = const Color(0xFF8C7A66)}) {
    final back = Path()
      ..moveTo(base.dx - 18 * scale, base.dy)
      ..lineTo(base.dx - 4 * scale, base.dy - 20 * scale)
      ..lineTo(base.dx + 9 * scale, base.dy)
      ..close();
    canvas.drawPath(back, Paint()..color = color.withValues(alpha: 0.75));

    final front = Path()
      ..moveTo(base.dx - 6 * scale, base.dy)
      ..lineTo(base.dx + 6 * scale, base.dy - 26 * scale)
      ..lineTo(base.dx + 18 * scale, base.dy)
      ..close();
    canvas.drawPath(front, Paint()..color = color);

    final snowCap = Path()
      ..moveTo(base.dx + 6 * scale, base.dy - 26 * scale)
      ..lineTo(base.dx + 1 * scale, base.dy - 17 * scale)
      ..lineTo(base.dx + 6 * scale, base.dy - 15 * scale)
      ..lineTo(base.dx + 11 * scale, base.dy - 17 * scale)
      ..close();
    canvas.drawPath(snowCap, Paint()..color = const Color(0xFFF5F5F5));
  }

  static void rock(Canvas canvas, Offset base, double scale, {Color color = const Color(0xFF9C8B78)}) {
    final path = Path()
      ..moveTo(base.dx - 14 * scale, base.dy)
      ..lineTo(base.dx - 10 * scale, base.dy - 12 * scale)
      ..lineTo(base.dx, base.dy - 18 * scale)
      ..lineTo(base.dx + 11 * scale, base.dy - 9 * scale)
      ..lineTo(base.dx + 14 * scale, base.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  static void rockChurch(Canvas canvas, Offset topCenter, double width, double height) {
    final rect = Rect.fromLTWH(topCenter.dx - width / 2, topCenter.dy, width, height);
    canvas.drawRect(rect, Paint()..color = const Color(0xFF8C6E56));
    final skyHole = Paint()..blendMode = BlendMode.dstOut;
    canvas.saveLayer(rect.inflate(4), Paint());
    canvas.drawRect(rect, Paint()..color = const Color(0xFF8C6E56));
    final crossV = Rect.fromCenter(center: Offset(rect.center.dx, rect.top + rect.height * 0.28), width: rect.width * 0.16, height: rect.height * 0.34);
    final crossH = Rect.fromCenter(center: crossV.center, width: rect.width * 0.42, height: rect.height * 0.10);
    canvas.drawRect(crossV, skyHole);
    canvas.drawRect(crossH, skyHole);
    canvas.restore();
  }

  static void obelisk(Canvas canvas, Offset base, double height, double width) {
    final rect = Rect.fromLTWH(base.dx - width / 2, base.dy - height, width, height);
    canvas.drawRect(rect, Paint()..color = const Color(0xFFB9AFA0));
    final cap = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.left + rect.width / 2, rect.top - height * 0.14)
      ..lineTo(rect.right, rect.top)
      ..close();
    canvas.drawPath(cap, Paint()..color = const Color(0xFFA79C8C));
    final stripeH = height * 0.05;
    final stripeY = rect.top + height * 0.1;
    canvas.drawRect(Rect.fromLTWH(rect.left, stripeY, width, stripeH), Paint()..color = const Color(0xFF0F7A3D));
    canvas.drawRect(Rect.fromLTWH(rect.left, stripeY + stripeH, width, stripeH), Paint()..color = const Color(0xFFF4C430));
    canvas.drawRect(Rect.fromLTWH(rect.left, stripeY + stripeH * 2, width, stripeH), Paint()..color = const Color(0xFFC62828));
  }

  /// A simple mosque silhouette - a domed prayer hall flanked by two thin
  /// minarets, each capped with its own small dome and topped by a crescent
  /// (Etappe 24 Nachtrag 2, for Harar's real content: "city of minarets",
  /// and its Islam-themed first chapter). Sized off `base` (the ground
  /// point) and `scale`, the same convention every other `Sketch` shape in
  /// this file uses. Default colours (Etappe 24 Nachtrag 4, on request) are
  /// the white walls and blue domes/minarets real Harar mosques are known
  /// for, not a generic gold.
  static void mosque(Canvas canvas, Offset base, double scale, {Color color = const Color(0xFFF3F7FA), Color accent = const Color(0xFF2C6CA3)}) {
    final wallPaint = Paint()..color = color;
    final domePaint = Paint()..color = accent;

    final hallRect = Rect.fromLTWH(base.dx - 22 * scale, base.dy - 22 * scale, 44 * scale, 22 * scale);
    canvas.drawRect(hallRect, wallPaint);
    canvas.drawArc(Rect.fromCenter(center: hallRect.topCenter, width: 34 * scale, height: 34 * scale), math.pi, math.pi, true, domePaint);

    void minaret(double dx) {
      final towerRect = Rect.fromLTWH(base.dx + dx - 3 * scale, base.dy - 40 * scale, 6 * scale, 40 * scale);
      canvas.drawRect(towerRect, wallPaint);
      canvas.drawOval(Rect.fromCenter(center: towerRect.topCenter, width: 9 * scale, height: 9 * scale), domePaint);
      canvas.drawLine(towerRect.topCenter, towerRect.topCenter - Offset(0, 6 * scale), Paint()
        ..color = accent
        ..strokeWidth = 1.4 * scale);
    }

    minaret(-28 * scale);
    minaret(28 * scale);

    final doorPaint = Paint()..color = accent.withValues(alpha: 0.6);
    canvas.drawRect(Rect.fromCenter(center: Offset(base.dx, base.dy - 5 * scale), width: 9 * scale, height: 12 * scale), doorPaint);
  }

  /// A simple standing zebra silhouette (Etappe 24 Nachtrag 5, for the
  /// Safari station - replaces an earlier lion that didn't read well at
  /// this size, on request) - a cream body and a longer horse-like head
  /// held apart from the body on its own neck, so the two never blur into
  /// each other, plus a few black stripes across the body (what actually
  /// reads as "zebra", as opposed to any other four-legged animal, at this
  /// small a scatter-decoration size), small pointed ears, and a simple
  /// tail. Sized off `base` (the ground point) and `scale`.
  static void zebra(Canvas canvas, Offset base, double scale, {Color body = const Color(0xFFF6F3EA), Color stripe = const Color(0xFF221F1D)}) {
    final bodyPaint = Paint()..color = body;

    final bodyRect = Rect.fromCenter(center: Offset(base.dx + 3 * scale, base.dy - 9 * scale), width: 25 * scale, height: 12 * scale);
    canvas.drawOval(bodyRect, bodyPaint);

    // Neck + head as one filled shape, angled down and away from the body
    // so there's real visual separation instead of two overlapping ovals.
    final headCenter = Offset(base.dx - 19 * scale, base.dy - 4 * scale);
    final neckPath = Path()
      ..moveTo(bodyRect.left + 5 * scale, bodyRect.top + 1 * scale)
      ..lineTo(headCenter.dx + 5 * scale, headCenter.dy - 5 * scale)
      ..lineTo(headCenter.dx - 6 * scale, headCenter.dy - 2 * scale)
      ..lineTo(headCenter.dx - 4 * scale, headCenter.dy + 3 * scale)
      ..lineTo(bodyRect.left, bodyRect.bottom - 2 * scale)
      ..close();
    canvas.drawPath(neckPath, bodyPaint);

    final earPaint = Paint()..color = stripe;
    canvas.drawPath(
      Path()
        ..moveTo(headCenter.dx - 1 * scale, headCenter.dy - 4 * scale)
        ..lineTo(headCenter.dx - 3 * scale, headCenter.dy - 9 * scale)
        ..lineTo(headCenter.dx + 1 * scale, headCenter.dy - 5 * scale)
        ..close(),
      earPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(headCenter.dx + 3 * scale, headCenter.dy - 4 * scale)
        ..lineTo(headCenter.dx + 2 * scale, headCenter.dy - 9 * scale)
        ..lineTo(headCenter.dx + 5 * scale, headCenter.dy - 5 * scale)
        ..close(),
      earPaint,
    );

    // Body stripes - what actually sells "zebra" at this size.
    final stripePaint = Paint()
      ..color = stripe
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * scale
      ..strokeCap = StrokeCap.round;
    for (final t in [0.22, 0.44, 0.66, 0.86]) {
      canvas.drawLine(
        Offset(bodyRect.left + bodyRect.width * t, bodyRect.top + 1 * scale),
        Offset(bodyRect.left + bodyRect.width * t, bodyRect.bottom - 1 * scale),
        stripePaint,
      );
    }

    canvas.drawLine(
      Offset(bodyRect.right, bodyRect.center.dy),
      Offset(bodyRect.right + 7 * scale, bodyRect.center.dy + 6 * scale),
      Paint()
        ..color = stripe
        ..strokeWidth = 1.6 * scale
        ..strokeCap = StrokeCap.round,
    );

    final legPaint = Paint()
      ..color = body
      ..strokeWidth = 2.4 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(bodyRect.left + 5 * scale, bodyRect.bottom - 1 * scale), Offset(bodyRect.left + 5 * scale, base.dy), legPaint);
    canvas.drawLine(Offset(bodyRect.right - 4 * scale, bodyRect.bottom - 1 * scale), Offset(bodyRect.right - 4 * scale, base.dy), legPaint);
  }

  static void lake(Canvas canvas, Rect area, double baseline) {
    final path = Path()..moveTo(area.left, area.bottom);
    path.lineTo(area.left, area.top + area.height * baseline);
    path.quadraticBezierTo(area.left + area.width * 0.25, area.top + area.height * (baseline - 0.06), area.left + area.width * 0.5, area.top + area.height * baseline);
    path.quadraticBezierTo(area.left + area.width * 0.75, area.top + area.height * (baseline + 0.06), area.right, area.top + area.height * (baseline - 0.02));
    path.lineTo(area.right, area.bottom);
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF3F8FA6));
  }

  /// A friendly little taxi, drawn centered at `center`, rotated by
  /// `headingRadians` (0 = facing right) - used both for the mini icon on
  /// nodes and for the animated traveling vehicle. Blue-and-white livery,
  /// after the shared minibus taxis common in Addis Ababa (Etappe 18 - the
  /// vehicle was originally a plain yellow bus).
  static void bus(Canvas canvas, Offset center, double scale, double headingRadians) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(headingRadians);
    final bodyRect = Rect.fromCenter(center: Offset.zero, width: 42 * scale, height: 22 * scale);
    final bodyRRect = RRect.fromRectAndRadius(bodyRect, Radius.circular(6 * scale));
    canvas.drawShadow(Path()..addRRect(bodyRRect.shift(Offset(0, 5 * scale))), Colors.black, 2, false);
    canvas.drawRRect(bodyRRect, Paint()..color = const Color(0xFF1E5FA8));
    // White roof band, clipped to the body's rounded silhouette so it
    // follows the corner radius instead of overhanging it.
    canvas.save();
    canvas.clipRRect(bodyRRect);
    canvas.drawRect(Rect.fromLTWH(bodyRect.left, bodyRect.top, bodyRect.width, bodyRect.height * 0.3), Paint()..color = Colors.white);
    canvas.restore();
    canvas.drawRRect(bodyRRect, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4 * scale
      ..color = const Color(0xFF3A3A3A));
    final windowPaint = Paint()..color = const Color(0xFFCDEBFA);
    for (var i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(bodyRect.left + bodyRect.width * (0.08 + i * 0.30), bodyRect.top + bodyRect.height * 0.18, bodyRect.width * 0.22, bodyRect.height * 0.42),
          Radius.circular(1.5 * scale),
        ),
        windowPaint,
      );
    }
    final wheelPaint = Paint()..color = const Color(0xFF2B2B2B);
    final wheelRadius = 5 * scale;
    canvas.drawCircle(Offset(bodyRect.left + bodyRect.width * 0.24, bodyRect.bottom), wheelRadius, wheelPaint);
    canvas.drawCircle(Offset(bodyRect.left + bodyRect.width * 0.76, bodyRect.bottom), wheelRadius, wheelPaint);
    canvas.restore();
  }

  /// A "sand" road stroke along [path] with a dashed darker centre line on
  /// top - the one road style shared by both map levels. Etappe 24: default
  /// thinned from 22 - it read as too heavy/dominant next to the now also
  /// smaller region/station markers.
  static void road(Canvas canvas, Path path, {double width = 14}) {
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = width
        ..color = const Color(0xFFDFC9A0),
    );
    final dashed = Path();
    for (final metric in path.computeMetrics()) {
      const dash = 16.0, gap = 12.0;
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + dash, metric.length);
        dashed.addPath(metric.extractPath(distance, next), Offset.zero);
        distance = next + gap;
      }
    }
    canvas.drawPath(
      dashed,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = width * 0.16
        ..color = const Color(0xFFB79A67),
    );
  }

  /// A small deterministic PRNG (not `dart:math`'s default seeding, which
  /// isn't guaranteed stable across runs) so scattered decorations render
  /// in the same spots every time - a rebuild must not visibly reshuffle
  /// the scenery under the user.
  static math.Random seededRandom(int seed) => math.Random(seed);
}
