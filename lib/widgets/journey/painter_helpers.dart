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

  /// A wide "sand" road stroke along [path] with a dashed darker centre
  /// line on top - the one road style shared by both map levels.
  static void road(Canvas canvas, Path path, {double width = 22}) {
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
