// One-off generator for assets/icon/app_icon.png - not part of the regular
// test suite (flutter test only scans test/ by default), run explicitly with
// `flutter test tool/generate_icon_test.dart` whenever the icon design
// changes, then `dart run flutter_launcher_icons` to re-derive every
// platform's actual icon files from this one source image. Uses dart:ui
// directly (only available under the Flutter test/app engine, not plain
// `dart run`) to draw the app's taxi + driver mark by hand in the brand
// green - see ENTSCHEIDUNGEN.md Etappe 11 for why no downloaded/
// AI-generated image asset is used here instead, Etappe 17 for why the icon
// changed from a generic chat bubble to a vehicle/driver motif, and
// Etappe 18 for why the vehicle is a blue-and-white taxi (the shared
// minibus taxis common in Addis Ababa) rather than a plain yellow bus, with
// the driver waving out of the window.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('generates assets/icon/app_icon.png', (tester) async {
    // Image encoding happens on the engine's raster thread and completes via
    // a real (not fake-clock-controlled) Future - without runAsync() this
    // hangs forever under the test binding's synchronous time control, the
    // same class of issue as the AudioService platform-channel hang in
    // ENTSCHEIDUNGEN.md Etappe 7.
    await tester.runAsync(() async {
      const size = 1024.0;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, size, size));

      final background = Paint()..color = const Color(0xFF0F7A3D);
      canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, size, size), const Radius.circular(180)),
        background,
      );

      // Taxi body: blue with a white roof band, after the shared minibus
      // taxis common in Addis Ababa (Etappe 18 - this used to be a plain
      // yellow bus, same shape reused for the new livery).
      const bodyRect = Rect.fromLTRB(130, 380, 894, 662);
      final bodyRRect = RRect.fromRectAndRadius(bodyRect, const Radius.circular(56));
      canvas.drawRRect(bodyRRect, Paint()..color = const Color(0xFF1E5FA8));
      canvas.save();
      canvas.clipRRect(bodyRRect);
      canvas.drawRect(Rect.fromLTWH(bodyRect.left, bodyRect.top, bodyRect.width, bodyRect.height * 0.3), Paint()..color = Colors.white);
      canvas.restore();
      canvas.drawRRect(
        bodyRRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..color = const Color(0xFF3A3A3A),
      );

      // Three identically-shaped windows, so the driver's face slot lines
      // up with the two plain ones instead of standing out as a different
      // shape.
      final windowPaint = Paint()..color = const Color(0xFFCDEBFA);
      for (final cx in [284.0, 512.0, 738.0]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, 468), width: 148, height: 128), const Radius.circular(20)),
          windowPaint,
        );
      }

      const driverCenter = Offset(738, 478);

      // Waving arm, drawn BEFORE the head so the head/cap covers the
      // shoulder joint and the arm reads as coming from beside/behind the
      // head, not growing out of the cap. Reaches up and to the right,
      // clear of the other two windows and the roofline - "leaning out of
      // the window to wave" pose.
      final armPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 32
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF8D5A3B);
      const shoulder = Offset(806, 512);
      const hand = Offset(882, 300);
      canvas.drawLine(shoulder, hand, armPaint);
      canvas.drawCircle(hand, 30, Paint()..color = const Color(0xFF8D5A3B));
      // Two short motion arcs beside the hand, suggesting a waving motion.
      final wavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: 0.85);
      for (final r in [50.0, 74.0]) {
        canvas.drawArc(Rect.fromCircle(center: hand, radius: r), -1.25, 0.9, false, wavePaint);
      }

      // The driver's face, same palette as
      // lib/widgets/journey/bus_driver.dart's portrait, sized to sit
      // fully inside that third window.
      canvas.drawCircle(driverCenter, 48, Paint()..color = const Color(0xFF8D5A3B));
      // Cap: a flat-bottomed dome (round top corners only, not a full
      // pill) sitting on top of the head, plus a thin brim line - a
      // symmetric pill shape here reads as "horns" instead of a cap.
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromCenter(center: driverCenter + const Offset(0, -42), width: 116, height: 30),
          topLeft: const Radius.circular(58),
          topRight: const Radius.circular(58),
        ),
        Paint()..color = const Color(0xFFF4C430),
      );
      canvas.drawRect(
        Rect.fromCenter(center: driverCenter + const Offset(0, -30), width: 120, height: 12),
        Paint()..color = const Color(0xFF3A3A3A),
      );
      final eyePaint = Paint()..color = const Color(0xFF3A3A3A);
      canvas.drawCircle(driverCenter + const Offset(-15, 2), 6, eyePaint);
      canvas.drawCircle(driverCenter + const Offset(15, 2), 6, eyePaint);
      final smile = Path()
        ..moveTo(driverCenter.dx - 17, driverCenter.dy + 16)
        ..quadraticBezierTo(driverCenter.dx, driverCenter.dy + 30, driverCenter.dx + 17, driverCenter.dy + 16);
      canvas.drawPath(
        smile,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF3A2415),
      );

      // Wheels.
      final tirePaint = Paint()..color = const Color(0xFF2B2B2B);
      final hubPaint = Paint()..color = const Color(0xFFBFBFBF);
      for (final cx in [318.0, 706.0]) {
        final wheelCenter = Offset(cx, bodyRect.bottom);
        canvas.drawCircle(wheelCenter, 72, tirePaint);
        canvas.drawCircle(wheelCenter, 30, hubPaint);
      }

      final picture = recorder.endRecording();
      final image = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final file = File('assets/icon/app_icon.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);

      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), greaterThan(0));
    });
  });
}
