import 'package:flutter/material.dart';

import '../../core/journey_regions.dart';

/// A hand-drawn "postcard" for one stop on the Äthiopien-Reise (Abschnitt
/// Design) - shown atop its section on the learning path. Deliberately flat
/// vector shapes (no photos/AI-generated images - see ENTSCHEIDUNGEN.md for
/// why), so it scales cleanly at any size and never needs a network/asset
/// fetch. Each region keeps its own fixed "postcard" palette regardless of
/// the app's light/dark theme, the same way a photo would.
class JourneyStopBanner extends StatelessWidget {
  final JourneyRegion region;
  final bool current;

  const JourneyStopBanner({super.key, required this.region, this.current = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 2.6,
        child: CustomPaint(
          painter: _JourneyPainter(region: region, showBus: current),
        ),
      ),
    );
  }
}

class _JourneyPainter extends CustomPainter {
  final JourneyRegion region;
  final bool showBus;

  _JourneyPainter({required this.region, required this.showBus});

  double _w(Size s, double f) => s.width * f;
  double _h(Size s, double f) => s.height * f;

  @override
  void paint(Canvas canvas, Size size) {
    switch (region) {
      case JourneyRegion.addisAbeba:
        _paintAddisAbeba(canvas, size);
        break;
      case JourneyRegion.oromia:
        _paintOromia(canvas, size);
        break;
      case JourneyRegion.tigray:
        _paintTigray(canvas, size);
        break;
      case JourneyRegion.sidama:
        _paintSidama(canvas, size);
        break;
      case JourneyRegion.harar:
      case JourneyRegion.safari:
      case JourneyRegion.asmara:
      case JourneyRegion.massawa:
      case JourneyRegion.keren:
      case JourneyRegion.dahlak:
        // This whole painter has had no active caller since Etappe 14 (see
        // class doc below) - not worth a bespoke scene for any of these.
        _sky(canvas, size, const Color(0xFFD8D8D8), const Color(0xFFEDEDED));
        break;
    }
    if (showBus) _paintBus(canvas, size);
  }

  void _sky(Canvas canvas, Size size, Color top, Color bottom) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom]).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _ground(Canvas canvas, Size size, Color color, double topFraction) {
    final path = Path()
      ..moveTo(0, _h(size, topFraction))
      ..lineTo(size.width, _h(size, topFraction))
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _paintAddisAbeba(Canvas canvas, Size size) {
    _sky(canvas, size, const Color(0xFFFFD9A0), const Color(0xFFFFF3E0));
    _ground(canvas, size, const Color(0xFFC9B79C), 0.82);

    final buildingColors = [const Color(0xFF8D99AE), const Color(0xFF6B7A99), const Color(0xFF98A8C1), const Color(0xFF7D8CA3)];
    final buildingXs = [0.06, 0.20, 0.32, 0.46];
    final buildingWidths = [0.10, 0.09, 0.11, 0.08];
    final buildingHeights = [0.30, 0.42, 0.24, 0.36];
    for (var i = 0; i < buildingXs.length; i++) {
      final x = _w(size, buildingXs[i]);
      final width = _w(size, buildingWidths[i]);
      final top = _h(size, 0.82 - buildingHeights[i]);
      final rect = Rect.fromLTWH(x, top, width, _h(size, buildingHeights[i]));
      canvas.drawRect(rect, Paint()..color = buildingColors[i]);
      final windowPaint = Paint()..color = const Color(0xFFFFE9A8);
      for (var row = 0; row < 3; row++) {
        for (var col = 0; col < 2; col++) {
          final wx = rect.left + width * (0.22 + col * 0.4);
          final wy = rect.top + rect.height * (0.18 + row * 0.28);
          canvas.drawRect(Rect.fromLTWH(wx, wy, width * 0.14, rect.height * 0.12), windowPaint);
        }
      }
    }

    // Obelisk (nods to the Meskel Square/Africa Unity monument), with a
    // thin green-yellow-red stripe near the top.
    final obeliskX = _w(size, 0.66);
    final obeliskWidth = _w(size, 0.045);
    final obeliskTop = _h(size, 0.30);
    final obeliskRect = Rect.fromLTWH(obeliskX, obeliskTop, obeliskWidth, _h(size, 0.82) - obeliskTop);
    canvas.drawRect(obeliskRect, Paint()..color = const Color(0xFFB9AFA0));
    final cap = Path()
      ..moveTo(obeliskRect.left, obeliskRect.top)
      ..lineTo(obeliskRect.left + obeliskRect.width / 2, obeliskRect.top - _h(size, 0.06))
      ..lineTo(obeliskRect.right, obeliskRect.top)
      ..close();
    canvas.drawPath(cap, Paint()..color = const Color(0xFFA79C8C));
    final stripeY = obeliskRect.top + _h(size, 0.05);
    final stripeHeight = _h(size, 0.02);
    canvas.drawRect(Rect.fromLTWH(obeliskRect.left, stripeY, obeliskRect.width, stripeHeight), Paint()..color = const Color(0xFF0F7A3D));
    canvas.drawRect(Rect.fromLTWH(obeliskRect.left, stripeY + stripeHeight, obeliskRect.width, stripeHeight), Paint()..color = const Color(0xFFF4C430));
    canvas.drawRect(Rect.fromLTWH(obeliskRect.left, stripeY + stripeHeight * 2, obeliskRect.width, stripeHeight), Paint()..color = const Color(0xFFC62828));
  }

  void _hill(Canvas canvas, Size size, Color color, double baseline, double height, double leftBulge, double rightBulge) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, _h(size, baseline))
      ..cubicTo(
        _w(size, leftBulge), _h(size, baseline - height),
        _w(size, rightBulge), _h(size, baseline - height),
        size.width, _h(size, baseline),
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _tukul(Canvas canvas, Size size, double cx, double baseline, double scale) {
    final wallRadius = _w(size, 0.055 * scale);
    final wallCenter = Offset(_w(size, cx), _h(size, baseline) - wallRadius * 0.6);
    canvas.drawOval(
      Rect.fromCenter(center: wallCenter, width: wallRadius * 2, height: wallRadius * 1.6),
      Paint()..color = const Color(0xFFD8B37C),
    );
    final roofPath = Path()
      ..moveTo(wallCenter.dx - wallRadius * 1.3, wallCenter.dy - wallRadius * 0.4)
      ..lineTo(wallCenter.dx, wallCenter.dy - wallRadius * 2.4)
      ..lineTo(wallCenter.dx + wallRadius * 1.3, wallCenter.dy - wallRadius * 0.4)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = const Color(0xFF6B4A2E));
  }

  void _paintOromia(Canvas canvas, Size size) {
    _sky(canvas, size, const Color(0xFFBEE3F8), const Color(0xFFEAF7FF));
    _hill(canvas, size, const Color(0xFF7FB069), 0.62, 0.14, 0.25, 0.55);
    _hill(canvas, size, const Color(0xFF5F9653), 0.74, 0.16, 0.15, 0.85);
    _hill(canvas, size, const Color(0xFF4A7C43), 0.88, 0.10, 0.4, 0.75);

    // Acacia tree.
    final trunkX = _w(size, 0.72);
    final trunkTop = _h(size, 0.55);
    final trunkBottom = _h(size, 0.80);
    canvas.drawLine(Offset(trunkX, trunkBottom), Offset(trunkX, trunkTop), Paint()
      ..color = const Color(0xFF4A3324)
      ..strokeWidth = _w(size, 0.012));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(trunkX, trunkTop - _h(size, 0.02)), width: _w(size, 0.24), height: _h(size, 0.09)),
      Paint()..color = const Color(0xFF3C6E2E),
    );

    _tukul(canvas, size, 0.18, 0.90, 1.0);
    _tukul(canvas, size, 0.30, 0.94, 0.8);
  }

  void _paintTigray(Canvas canvas, Size size) {
    _sky(canvas, size, const Color(0xFFFCE8C7), const Color(0xFFFFF8EC));

    Path jaggedRange(double baseline, List<double> peaks) {
      final path = Path()..moveTo(0, size.height);
      path.lineTo(0, _h(size, baseline));
      final step = size.width / (peaks.length - 1);
      for (var i = 0; i < peaks.length; i++) {
        path.lineTo(step * i, _h(size, baseline - peaks[i]));
      }
      path.lineTo(size.width, size.height);
      path.close();
      return path;
    }

    canvas.drawPath(jaggedRange(0.62, [0.0, 0.16, 0.06, 0.20, 0.08, 0.14, 0.0]), Paint()..color = const Color(0xFFD7A98C));
    canvas.drawPath(jaggedRange(0.78, [0.0, 0.10, 0.03, 0.13, 0.02, 0.09, 0.0]), Paint()..color = const Color(0xFFB98363));

    // Rock-hewn church: a stone monolith with a cross silhouetted against
    // the sky near the top, echoing Lalibela's Bete Giyorgis.
    final blockRect = Rect.fromLTWH(_w(size, 0.42), _h(size, 0.42), _w(size, 0.18), _h(size, 0.42));
    canvas.drawRect(blockRect, Paint()..color = const Color(0xFF8C6E56));
    final crossVertical = Rect.fromCenter(
      center: Offset(blockRect.center.dx, blockRect.top + blockRect.height * 0.28),
      width: blockRect.width * 0.16,
      height: blockRect.height * 0.34,
    );
    final crossHorizontal = Rect.fromCenter(
      center: crossVertical.center,
      width: blockRect.width * 0.42,
      height: blockRect.height * 0.10,
    );
    final skyPaint = Paint()..color = const Color(0xFFFCE8C7);
    canvas.drawRect(crossVertical, skyPaint);
    canvas.drawRect(crossHorizontal, skyPaint);
  }

  void _paintSidama(Canvas canvas, Size size) {
    _sky(canvas, size, const Color(0xFFBFE6D8), const Color(0xFFF4FBF6));
    _ground(canvas, size, const Color(0xFF6FA85A), 0.70);

    // Lake with a soft wavy shoreline.
    final lakePath = Path()..moveTo(0, size.height);
    lakePath.lineTo(0, _h(size, 0.80));
    lakePath.quadraticBezierTo(_w(size, 0.25), _h(size, 0.74), _w(size, 0.5), _h(size, 0.80));
    lakePath.quadraticBezierTo(_w(size, 0.75), _h(size, 0.86), size.width, _h(size, 0.78));
    lakePath.lineTo(size.width, size.height);
    lakePath.close();
    canvas.drawPath(lakePath, Paint()..color = const Color(0xFF3F8FA6));

    void palm(double cx, double baseline, double scale) {
      final trunkTop = _h(size, baseline) - _h(size, 0.22 * scale);
      final trunkBase = Offset(_w(size, cx), _h(size, baseline));
      final trunkPath = Path()
        ..moveTo(trunkBase.dx, trunkBase.dy)
        ..quadraticBezierTo(_w(size, cx) + _w(size, 0.02 * scale), (trunkBase.dy + trunkTop) / 2, _w(size, cx) + _w(size, 0.015 * scale), trunkTop);
      canvas.drawPath(trunkPath, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _w(size, 0.014 * scale)
        ..color = const Color(0xFF6B4A2E));
      final frondTip = Offset(_w(size, cx) + _w(size, 0.015 * scale), trunkTop);
      for (final angle in [-0.9, -0.4, 0.0, 0.4, 0.9]) {
        final dx = _w(size, 0.11 * scale) * (1 - angle.abs() * 0.3);
        final dy = -_h(size, 0.09 * scale) - _h(size, 0.05 * scale) * (1 - angle.abs());
        canvas.drawLine(
          frondTip,
          Offset(frondTip.dx + dx * (angle < 0 ? -1 : 1) * (angle == 0 ? 0.001 : 1), frondTip.dy + dy),
          Paint()
            ..color = const Color(0xFF2F6B3A)
            ..strokeWidth = _w(size, 0.01 * scale)
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    palm(0.14, 0.70, 1.0);
    palm(0.24, 0.72, 0.75);
    _tukul(canvas, size, 0.85, 0.94, 0.9);
  }

  void _paintBus(Canvas canvas, Size size) {
    final bodyRect = Rect.fromLTWH(_w(size, 0.06), _h(size, 0.68), _w(size, 0.20), _h(size, 0.16));
    final bodyRRect = RRect.fromRectAndRadius(bodyRect, Radius.circular(_w(size, 0.02)));
    canvas.drawRRect(bodyRRect, Paint()..color = const Color(0xFF1E5FA8));
    canvas.save();
    canvas.clipRRect(bodyRRect);
    canvas.drawRect(Rect.fromLTWH(bodyRect.left, bodyRect.top, bodyRect.width, bodyRect.height * 0.3), Paint()..color = Colors.white);
    canvas.restore();
    canvas.drawRRect(
      bodyRRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _w(size, 0.006)
        ..color = const Color(0xFF3A3A3A),
    );
    final windowPaint = Paint()..color = const Color(0xFFCDEBFA);
    for (var i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(bodyRect.left + bodyRect.width * (0.10 + i * 0.28), bodyRect.top + bodyRect.height * 0.16, bodyRect.width * 0.2, bodyRect.height * 0.4),
        windowPaint,
      );
    }
    final wheelPaint = Paint()..color = const Color(0xFF2B2B2B);
    final wheelRadius = _h(size, 0.035);
    canvas.drawCircle(Offset(bodyRect.left + bodyRect.width * 0.22, bodyRect.bottom), wheelRadius, wheelPaint);
    canvas.drawCircle(Offset(bodyRect.left + bodyRect.width * 0.78, bodyRect.bottom), wheelRadius, wheelPaint);
  }

  @override
  bool shouldRepaint(covariant _JourneyPainter oldDelegate) => oldDelegate.region != region || oldDelegate.showBus != showBus;
}
