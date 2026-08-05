// One-off generator for assets/icon/app_icon.png - not part of the regular
// test suite (flutter test only scans test/ by default), run explicitly with
// `flutter test tool/generate_icon_test.dart` whenever the icon design
// changes. Uses dart:ui directly (only available under the Flutter test/app
// engine, not plain `dart run`) to draw a simple, font-free chat-bubble mark
// in the app's brand green - see ENTSCHEIDUNGEN.md Etappe 11 for why no
// downloaded/AI-generated image asset is used here instead.
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

      final bubble = Paint()..color = Colors.white;
      const bubbleRect = Rect.fromLTRB(184, 287, 840, 635);
      canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(90)), bubble);

      final tail = Path()
        ..moveTo(330, 620)
        ..lineTo(255, 745)
        ..lineTo(410, 630)
        ..close();
      canvas.drawPath(tail, bubble);

      final dot = Paint()..color = const Color(0xFF0F7A3D);
      for (final dx in [-140.0, 0.0, 140.0]) {
        canvas.drawCircle(Offset(512 + dx, 461), 40, dot);
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
