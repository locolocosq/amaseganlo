import 'package:flutter/material.dart';

/// The bus driver's portrait + a speech bubble with a short, contextual
/// comment - shown on both map levels (Etappe 14). Deliberately a simple,
/// friendly, stylised avatar (round face, cap, big smile) rather than a
/// detailed/caricatured illustration - warm without being twee or trying
/// to depict a specific person.
class BusDriverBubble extends StatelessWidget {
  final String message;

  const BusDriverBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _DriverAvatar(),
        const SizedBox(width: 8),
        Flexible(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Container(
              key: ValueKey(message),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Text(message, style: theme.textTheme.bodyMedium),
            ),
          ),
        ),
      ],
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(3),
      child: const ClipOval(child: CustomPaint(painter: _DriverFacePainter(), size: Size.infinite)),
    );
  }
}

class _DriverFacePainter extends CustomPainter {
  const _DriverFacePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawCircle(Offset(w / 2, h / 2), w / 2, Paint()..color = const Color(0xFFEFC9A0));

    // Cap: a rounded dome plus a dark brim line and a small peak.
    final domeRect = Rect.fromLTWH(-w * 0.02, -h * 0.08, w * 1.04, h * 0.52);
    canvas.drawRRect(RRect.fromRectAndRadius(domeRect, Radius.circular(w * 0.5)), Paint()..color = const Color(0xFFF4C430));
    canvas.drawRect(Rect.fromLTWH(0, h * 0.36, w, h * 0.07), Paint()..color = const Color(0xFF3A3A3A));
    canvas.drawOval(Rect.fromLTWH(w * 0.28, h * 0.39, w * 0.44, h * 0.09), Paint()..color = const Color(0xFF3A3A3A));

    // Eyes + smile.
    final eyePaint = Paint()..color = const Color(0xFF3A3A3A);
    canvas.drawCircle(Offset(w * 0.37, h * 0.56), w * 0.045, eyePaint);
    canvas.drawCircle(Offset(w * 0.63, h * 0.56), w * 0.045, eyePaint);
    final smile = Path()
      ..moveTo(w * 0.32, h * 0.68)
      ..quadraticBezierTo(w * 0.5, h * 0.82, w * 0.68, h * 0.68);
    canvas.drawPath(
      smile,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.045
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF8A5A3A),
    );

    // Rosy cheeks.
    final cheekPaint = Paint()..color = const Color(0x55E88A6B);
    canvas.drawCircle(Offset(w * 0.24, h * 0.66), w * 0.06, cheekPaint);
    canvas.drawCircle(Offset(w * 0.76, h * 0.66), w * 0.06, cheekPaint);
  }

  @override
  bool shouldRepaint(covariant _DriverFacePainter oldDelegate) => false;
}
