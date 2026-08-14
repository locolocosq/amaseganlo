// One-off generator for assets/icon/app_icon.png - not part of the regular
// test suite (flutter test only scans test/ by default), run explicitly with
// `flutter test tool/generate_icon_test.dart` whenever the icon design
// changes, then `dart run flutter_launcher_icons` to re-derive every
// platform's actual icon files from this one source image. Uses dart:ui
// directly (only available under the Flutter test/app engine, not plain
// `dart run`) to draw the app's icon by hand in the brand green - see
// ENTSCHEIDUNGEN.md Etappe 11 for why no downloaded/AI-generated image
// asset is used here instead, Etappe 17 for why the icon changed from a
// generic chat bubble to a vehicle/driver motif, Etappe 18 for why the
// vehicle was a blue-and-white taxi (the shared minibus taxis common in
// Addis Ababa) rather than a plain yellow bus, Etappe 21 for why the
// driver's waving arm (also added in Etappe 18) was removed again, and
// Etappe 24 for why the icon dropped the whole taxi and became just the
// driver's face, filling the whole canvas - at 48x48px (the smallest
// Android launcher size) a small face tucked into one window of a whole
// taxi read as a barely-visible smudge, where the same face alone fills
// the icon and stays legible small.
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

      canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, size, size), const Radius.circular(180)),
        Paint()..color = const Color(0xFF0F7A3D),
      );

      // The driver's face, same palette as
      // lib/widgets/journey/bus_driver.dart's portrait, now filling the
      // whole icon instead of sitting in one window of a full taxi.
      const driverCenter = Offset(512, 552);
      const r = 340.0;

      canvas.drawCircle(driverCenter, r, Paint()..color = const Color(0xFF8D5A3B));

      // Cap: a flat-bottomed dome (round top corners only, not a full
      // pill) sitting on top of the head, plus a thin brim line - a
      // symmetric pill shape here reads as "horns" instead of a cap (see
      // Etappe 17 history).
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromCenter(center: driverCenter + const Offset(0, -r * 0.875), width: r * 2.42, height: r * 0.625),
          topLeft: const Radius.circular(r * 1.2),
          topRight: const Radius.circular(r * 1.2),
        ),
        Paint()..color = const Color(0xFFF4C430),
      );
      canvas.drawRect(
        Rect.fromCenter(center: driverCenter + const Offset(0, -r * 0.625), width: r * 2.5, height: r * 0.25),
        Paint()..color = const Color(0xFF3A3A3A),
      );

      final eyePaint = Paint()..color = const Color(0xFF3A3A3A);
      canvas.drawCircle(driverCenter + const Offset(-r * 0.3125, r * 0.0417), r * 0.125, eyePaint);
      canvas.drawCircle(driverCenter + const Offset(r * 0.3125, r * 0.0417), r * 0.125, eyePaint);

      final smile = Path()
        ..moveTo(driverCenter.dx - r * 0.354, driverCenter.dy + r * 0.333)
        ..quadraticBezierTo(driverCenter.dx, driverCenter.dy + r * 0.625, driverCenter.dx + r * 0.354, driverCenter.dy + r * 0.333);
      canvas.drawPath(
        smile,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.146
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF3A2415),
      );

      // Rosy cheeks (bus_driver.dart has these, the old window-tucked face
      // didn't bother - now that the face fills the whole icon, the extra
      // warmth/detail actually shows).
      final cheekPaint = Paint()..color = const Color(0x55E88A6B);
      canvas.drawCircle(driverCenter + const Offset(-r * 0.52, r * 0.20), r * 0.16, cheekPaint);
      canvas.drawCircle(driverCenter + const Offset(r * 0.52, r * 0.20), r * 0.16, cheekPaint);

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
