// One-off generator for assets/splash/splash_background.png (Etappe 24) -
// not part of the regular test suite, run explicitly with
// `flutter test tool/generate_splash_test.dart` whenever the splash design
// changes, then `dart run flutter_native_splash:create` to regenerate the
// actual native Android/iOS/Web launch-screen resources from this one
// source image (see the `flutter_native_splash:` section in pubspec.yaml
// for the background_image/fullscreen config that consumes it). Same
// dart:ui-Canvas-by-hand mechanism as tool/generate_icon_test.dart - no
// downloaded/AI-generated image asset (ENTSCHEIDUNGEN.md Etappe 11).
//
// Went through four drafts before this one: v1 was a small logo card on a
// flat colour fill - rejected as looking unfinished. v2 added a gradient
// and calmer typography but was still a smaller centered card. v3 went
// full-bleed with the Ethiopia outline as a glowing line and no
// page-indicator dots. v4 (this one, Etappe 24 Nachtrag 4): v1-v3 all
// assumed the "safe zone" (title/map/taxi/subtitle) just needed to be
// inset from the edges by a fixed margin - on an iPad, whose screen is far
// squarer than this image's tall 1170x2532 canvas, `android_gravity:
// "fill|clip_vertical"`/`scaleAspectFill` (the only distortion-free native
// splash mode - see pubspec.yaml's comment for why `background_image`
// mode and any true CSS-"contain" equivalent aren't available on Android's
// side of this plugin) has to crop roughly 20-25% off BOTH the top and the
// bottom to cover a squarer screen, and that ate straight into the eyebrow
// label and title. The real fix isn't a smaller/repositioned crop margin -
// it's keeping every essential element inside a much narrower *vertical*
// band ([_safeTop]..[_safeBottom], as a fraction of the full canvas
// height) that survives that worst-case crop on anything up to a near-
// square screen, while the plain gradient (which never needs to show
// anything specific) absorbs the crop on regular phones almost entirely
// unnoticed, since a phone's own aspect ratio is already close to this
// canvas's.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, rootBundle;
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/journey_map_layout.dart';
import 'package:habesha_speak/widgets/journey/painter_helpers.dart';

const _canvasWidth = 1170.0;
const _canvasHeight = 2532.0;

// The vertical band every essential element (eyebrow/title/underline/map/
// taxi/subtitle) must live inside, as a fraction of _canvasHeight - see
// the file doc comment above for why. Chosen so it still survives
// `scaleAspectFill`/`fill|clip_vertical` cropping on a screen as square as
// ~4:5 (an iPad in portrait is closer to 3:4, so this has real margin to
// spare) without shrinking the safe zone more than necessary - on a normal
// phone (already close to this canvas's own ~9:19.5 ratio) little to
// nothing outside this band ever gets cropped anyway.
const _safeTop = 0.24;
const _safeBottom = 0.78;

// EthiopiaMap.outline()/projectToOffset() always fit the shape inside a
// fixed, padded lon/lat box (deliberately roomy in the real app, so
// station markers/labels never clip) - at any [_probeSize] the rendered
// shape only fills part of that box, not edge to edge. Rather than
// reverse-engineer that padding, probe the path once to find the shape's
// real bounding box, then apply one extra scale+translate below to fit
// that tightly into the splash's own target rect.
const _probeSize = Size(2000, 2000);

void main() {
  testWidgets('generates assets/splash/splash_background.png', (tester) async {
    await tester.runAsync(() async {
      final fontData = await rootBundle.load('assets/fonts/NotoSansEthiopic-Variable.ttf');
      final loader = FontLoader('SplashFont')..addFont(Future.value(fontData));
      await loader.load();

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, _canvasWidth, _canvasHeight));
      const fullArea = Rect.fromLTWH(0, 0, _canvasWidth, _canvasHeight);

      final safeTop = _canvasHeight * _safeTop;
      final safeBottom = _canvasHeight * _safeBottom;

      // Dark vignette: near-black corners, a brighter emerald glow centred
      // on the safe band (not the full canvas - Etappe 24 Nachtrag 4) where
      // the title/map actually sit, for real focal depth instead of a flat
      // single-colour fill.
      //
      // Etappe 24 Nachtrag 5: the glow is an ELLIPSE, not a circle - a plain
      // circular gradient sized to fade to the flat outer colour by the top/
      // bottom edges (a 1170x2532 canvas, so radius 1.0 = 1170px, based on
      // the shorter side) only reaches about half that fraction by the
      // left/right edges, leaving them a visibly lighter green than the
      // native splash's own flat #040F09 fallback. On any phone whose real
      // aspect ratio makes `fill|clip_vertical` gap or crop horizontally
      // instead of vertically, that mismatch shows through as a stray
      // coloured seam - reported as "schwarze Ränder" that shouldn't be
      // there. Squashing the gradient's vertical reach into a horizontal
      // radius that lands exactly on the canvas edge (while stretching it
      // back out vertically via a scaled canvas, so the vertical falloff
      // distance is unchanged from before) guarantees all four edges are
      // the exact same flat colour as the fallback, so no seam is possible
      // regardless of which direction ends up cropped or gapped.
      final safeMidY = (safeTop + safeBottom) / 2;
      final safeMidYFraction = (safeMidY - _canvasHeight / 2) / (_canvasHeight / 2);
      const verticalStretch = 2.0;
      canvas.drawRect(fullArea, Paint()..color = const Color(0xFF040F09));
      canvas.save();
      canvas.translate(_canvasWidth / 2, safeMidY);
      canvas.scale(1.0, verticalStretch);
      canvas.translate(-_canvasWidth / 2, -safeMidY);
      canvas.drawRect(
        fullArea,
        Paint()
          ..shader = RadialGradient(
            center: Alignment(0, safeMidYFraction),
            radius: 0.5,
            colors: const [Color(0xFF1E8E5A), Color(0xFF0C3D24), Color(0xFF040F09)],
            stops: const [0.0, 0.55, 1.0],
          ).createShader(fullArea),
      );
      canvas.restore();

      // Everything below is laid out top-to-bottom starting at the safe
      // band's own top edge, purely from each element's measured size - no
      // hand-guessed absolute y-coordinates, so the layout stays internally
      // consistent if a font size/spacing changes later.
      var cursorY = safeTop;

      // Eyebrow label.
      final eyebrowPainter = TextPainter(
        text: const TextSpan(
          text: 'ETHIOPIA · AMHARIC',
          style: TextStyle(
            fontFamily: 'SplashFont',
            fontSize: 30,
            color: Color(0xFFF4C430),
            fontWeight: FontWeight.w700,
            letterSpacing: 6,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: _canvasWidth);
      eyebrowPainter.paint(canvas, Offset((_canvasWidth - eyebrowPainter.width) / 2, cursorY));
      cursorY += eyebrowPainter.height + 22;

      // Title.
      final titlePainter = TextPainter(
        text: const TextSpan(
          text: 'Habesha Speak',
          style: TextStyle(
            fontFamily: 'SplashFont',
            fontSize: 108,
            color: Color(0xFFF3FBF5),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            shadows: [Shadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 16)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: _canvasWidth * 0.92);
      titlePainter.paint(canvas, Offset((_canvasWidth - titlePainter.width) / 2, cursorY));
      cursorY += titlePainter.height + 46;

      // Gradient underline, with a soft glow behind the crisp line.
      final underlineY = cursorY;
      final underlineRect = Rect.fromCenter(center: Offset(_canvasWidth / 2, underlineY), width: 260, height: 6);
      final underlineGradient = const LinearGradient(colors: [Color(0xFFF4C430), Color(0xFF3FD68C)]);
      canvas.drawRRect(
        RRect.fromRectAndRadius(underlineRect.inflate(6), const Radius.circular(6)),
        Paint()
          ..shader = underlineGradient.createShader(underlineRect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(underlineRect, const Radius.circular(3)),
        Paint()..shader = underlineGradient.createShader(underlineRect),
      );
      cursorY += 90;

      // Subtitle - measured now (but painted later, after the map) purely
      // so its height can be reserved up front, letting the map claim
      // every remaining pixel down to it instead of a hand-guessed height.
      final subtitlePainter = TextPainter(
        text: const TextSpan(
          text: 'Learn Amharic on the go',
          style: TextStyle(
            fontFamily: 'SplashFont',
            fontSize: 40,
            color: Color(0xCCEAF6EE),
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: _canvasWidth);
      final subtitleY = safeBottom - subtitlePainter.height;

      // Ethiopia silhouette, glowing-outline style, tightly fit into its
      // own target rect (see the bounds-probing comment above) - claims
      // every pixel left in the safe band between the underline and the
      // subtitle, so it's always as large as the safe band allows.
      final targetRect = Rect.fromLTWH(90, cursorY, _canvasWidth - 180, subtitleY - 40 - cursorY);
      final rawOutline = EthiopiaMap.outline(_probeSize);
      final bounds = rawOutline.getBounds();
      final fitScale = (targetRect.width / bounds.width < targetRect.height / bounds.height)
          ? targetRect.width / bounds.width
          : targetRect.height / bounds.height;
      final fittedWidth = bounds.width * fitScale;
      final fittedHeight = bounds.height * fitScale;
      final offsetX = targetRect.left + (targetRect.width - fittedWidth) / 2 - bounds.left * fitScale;
      final offsetY = targetRect.top + (targetRect.height - fittedHeight) / 2 - bounds.top * fitScale;

      canvas.save();
      canvas.translate(offsetX, offsetY);
      canvas.scale(fitScale);

      // Soft translucent fill first, then a blurred glow stroke, then a
      // crisp bright stroke on top - the layering that makes an outline
      // read as "glowing" instead of just "thin line".
      canvas.drawPath(rawOutline, Paint()..color = const Color(0xFF2BAA6E).withValues(alpha: 0.22));
      canvas.drawPath(
        rawOutline,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 18 / fitScale
          ..color = const Color(0xFF5CE0A0).withValues(alpha: 0.55)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 14 / fitScale),
      );
      canvas.drawPath(
        rawOutline,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 / fitScale
          ..color = const Color(0xFFBFF3D6),
      );

      // A couple of faint contour hints, purely decorative.
      canvas.save();
      canvas.clipPath(rawOutline);
      for (final t in [0.32, 0.55, 0.75]) {
        final y = bounds.top + bounds.height * t;
        final path = Path()..moveTo(bounds.left, y);
        path.quadraticBezierTo(bounds.left + bounds.width * 0.5, y - bounds.height * 0.05, bounds.left + bounds.width, y);
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5 / fitScale
            ..color = Colors.white.withValues(alpha: 0.12),
        );
      }
      canvas.restore();

      // Two light, translucent mountain accents - matching the glowing
      // outline palette instead of the flat brown Sketch.smallMountain
      // used on the in-app map.
      _paintGlowMountain(canvas, Offset(bounds.left + bounds.width * 0.30, bounds.top + bounds.height * 0.42), 150 / fitScale);
      _paintGlowMountain(canvas, Offset(bounds.left + bounds.width * 0.68, bounds.top + bounds.height * 0.30), 110 / fitScale);

      // A soft warm glow behind the taxi, then the taxi itself, centered
      // inside the shape.
      final busCenter = Offset(bounds.left + bounds.width * 0.50, bounds.top + bounds.height * 0.66);
      final busScale = 13.0 / fitScale;
      canvas.drawCircle(
        busCenter,
        320 / fitScale,
        Paint()
          ..shader = RadialGradient(
            colors: [Colors.white.withValues(alpha: 0.22), Colors.white.withValues(alpha: 0.0)],
          ).createShader(Rect.fromCircle(center: busCenter, radius: 320 / fitScale)),
      );
      Sketch.bus(canvas, busCenter, busScale, 0);
      _paintDriverFace(canvas, busCenter, busScale);

      canvas.restore(); // undo translate+scale

      // Subtitle - measured earlier (see above), painted last so it stays
      // pinned to the safe band's own bottom edge regardless of how big
      // the map ended up.
      subtitlePainter.paint(canvas, Offset((_canvasWidth - subtitlePainter.width) / 2, subtitleY));

      final picture = recorder.endRecording();
      final image = await picture.toImage(_canvasWidth.toInt(), _canvasHeight.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final file = File('assets/splash/splash_background.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);

      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), greaterThan(0));
    });
  });
}

/// A light, translucent two-peak mountain silhouette matching the glowing
/// outline palette - a lighter-weight cousin of [Sketch.smallMountain]
/// (which uses opaque browns fitted for the flat terrain-coloured map).
void _paintGlowMountain(Canvas canvas, Offset base, double size) {
  final path = Path()
    ..moveTo(base.dx - size * 0.55, base.dy)
    ..lineTo(base.dx, base.dy - size)
    ..lineTo(base.dx + size * 0.55, base.dy)
    ..close();
  canvas.drawPath(
    path,
    Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withValues(alpha: 0.9), const Color(0xFF3FA377).withValues(alpha: 0.6)],
      ).createShader(Rect.fromCircle(center: base, radius: size)),
  );
}

/// The driver's face inside the taxi's third window - same relative
/// position/size math [Sketch.bus] uses internally for that window, so
/// this only lines up correctly when [headingRadians] is 0 (no rotation).
void _paintDriverFace(Canvas canvas, Offset busCenter, double scale) {
  final driverCenter = busCenter + Offset(12.2 * scale, -2.4 * scale);
  final r = 4.6 * scale;

  canvas.drawCircle(driverCenter, r, Paint()..color = const Color(0xFF8D5A3B));
  canvas.drawRRect(
    RRect.fromRectAndCorners(
      Rect.fromCenter(center: driverCenter + Offset(0, -r * 0.875), width: r * 2.42, height: r * 0.625),
      topLeft: Radius.circular(r * 1.2),
      topRight: Radius.circular(r * 1.2),
    ),
    Paint()..color = const Color(0xFFF4C430),
  );
  canvas.drawRect(
    Rect.fromCenter(center: driverCenter + Offset(0, -r * 0.625), width: r * 2.5, height: r * 0.25),
    Paint()..color = const Color(0xFF3A3A3A),
  );
  final eyePaint = Paint()..color = const Color(0xFF3A3A3A);
  canvas.drawCircle(driverCenter + Offset(-r * 0.3125, r * 0.0417), r * 0.125, eyePaint);
  canvas.drawCircle(driverCenter + Offset(r * 0.3125, r * 0.0417), r * 0.125, eyePaint);
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
}
