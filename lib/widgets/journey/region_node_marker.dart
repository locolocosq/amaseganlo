import 'package:flutter/material.dart';

import '../../core/journey_regions.dart';
import '../../core/theme.dart';
import 'painter_helpers.dart';

enum RegionVisualState { completed, current, upcoming }

/// Strips the curriculum's full section title (e.g. "Station 1: Addis
/// Abeba — die Hauptstadt-Ankunft") down to just the city/region name for
/// the compact pennant label under the map node - the number is already
/// its own badge on the node, and the "— ..." tagline never fully fit in
/// two lines anyway (Etappe 20: "es wird nicht alles angezeigt"). Falls
/// back to the untouched string if the expected "N: Name — Tagline"
/// pattern isn't found, so unexpected content never disappears silently.
String _shortRegionLabel(String fullTitle) {
  var s = fullTitle;
  final colonIndex = s.indexOf(': ');
  if (colonIndex != -1) s = s.substring(colonIndex + 2);
  final dashIndex = s.indexOf(' — ');
  if (dashIndex != -1) s = s.substring(0, dashIndex);
  return s;
}

/// One tappable region "medallion" on the Ebene-1 world map: a round,
/// hand-drawn mini landmark icon on a wooden signpost platform, a title
/// pennant below it, and a small badge showing where the learner stands
/// (done/current/not-yet-reached). Regions are never actually locked for
/// *viewing* - only individual stations inside them are, via the same
/// rules as before (Abschnitt Design) - so this only changes look, not
/// tap behaviour.
class RegionNodeMarker extends StatelessWidget {
  final JourneyRegion region;
  final String title;
  final int stationNumber;
  final RegionVisualState state;
  final int crownsEarned;
  final int crownsPossible;
  final VoidCallback onTap;

  const RegionNodeMarker({
    super.key,
    required this.region,
    required this.title,
    required this.stationNumber,
    required this.state,
    required this.crownsEarned,
    required this.crownsPossible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final upcoming = state == RegionVisualState.upcoming;
    final ringColor = upcoming ? theme.colorScheme.outlineVariant : region.accent;
    const double diameter = 88;

    final shortLabel = _shortRegionLabel(title);

    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 128,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: diameter,
                height: diameter,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (upcoming ? Colors.black : ringColor).withValues(alpha: state == RegionVisualState.current ? 0.45 : 0.25),
                            blurRadius: state == RegionVisualState.current ? 16 : 8,
                            spreadRadius: state == RegionVisualState.current ? 1 : 0,
                          ),
                        ],
                      ),
                    ),
                    Opacity(
                      opacity: upcoming ? 0.55 : 1,
                      child: Container(
                        width: diameter,
                        height: diameter,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.surface,
                          border: Border.all(color: ringColor, width: 4),
                        ),
                        child: ClipOval(
                          child: CustomPaint(painter: _RegionIconPainter(region: region), size: Size.infinite),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -8,
                      left: -8,
                      child: _NumberFlag(number: stationNumber, color: upcoming ? theme.colorScheme.outline : region.accent),
                    ),
                    if (state == RegionVisualState.completed)
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: _Badge(icon: Icons.check, color: successColor),
                      ),
                    if (upcoming)
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: _Badge(icon: Icons.lock, color: theme.colorScheme.outline),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Text(
                  shortLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (crownsPossible > 0) ...[
                const SizedBox(height: 4),
                _CrownSummary(earned: crownsEarned, possible: crownsPossible),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberFlag extends StatelessWidget {
  final int number;
  final Color color;
  const _NumberFlag({required this.number, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 3, offset: Offset(0, 1))],
      ),
      child: Text(
        '$number',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _Badge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
      child: Icon(icon, size: 14, color: Colors.white),
    );
  }
}

class _CrownSummary extends StatelessWidget {
  final int earned;
  final int possible;
  const _CrownSummary({required this.earned, required this.possible});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, size: 12, color: Color(0xFFF4C430)),
          const SizedBox(width: 3),
          Text('$earned/$possible', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _RegionIconPainter extends CustomPainter {
  final JourneyRegion region;
  const _RegionIconPainter({required this.region});

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(0, 0, size.width, size.height);
    switch (region) {
      case JourneyRegion.addisAbeba:
        Sketch.sky(canvas, area, const Color(0xFFFFD9A0), const Color(0xFFFFF3E0));
        Sketch.hill(canvas, area, const Color(0xFFC9B79C), 0.72, 0.02, leftLean: 0.2, rightLean: 0.8);
        canvas.drawRect(Rect.fromLTWH(area.width * 0.18, area.height * 0.42, area.width * 0.16, area.height * 0.32), Paint()..color = const Color(0xFF8D99AE));
        canvas.drawRect(Rect.fromLTWH(area.width * 0.40, area.height * 0.34, area.width * 0.14, area.height * 0.40), Paint()..color = const Color(0xFF6B7A99));
        Sketch.obelisk(canvas, Offset(area.width * 0.72, area.height * 0.74), area.height * 0.42, area.width * 0.05);
        break;
      case JourneyRegion.oromia:
        Sketch.sky(canvas, area, const Color(0xFFBEE3F8), const Color(0xFFEAF7FF));
        Sketch.hill(canvas, area, const Color(0xFF7FB069), 0.62, 0.16, leftLean: 0.2, rightLean: 0.6);
        Sketch.hill(canvas, area, const Color(0xFF4A7C43), 0.82, 0.10, leftLean: 0.35, rightLean: 0.8);
        Sketch.acacia(canvas, Offset(area.width * 0.72, area.height * 0.80), 1.1);
        Sketch.tukul(canvas, Offset(area.width * 0.24, area.height * 0.88), 0.9);
        break;
      case JourneyRegion.tigray:
        Sketch.sky(canvas, area, const Color(0xFFFCE8C7), const Color(0xFFFFF8EC));
        Sketch.jaggedRange(canvas, area, const Color(0xFFD7A98C), 0.58, [0.0, 0.18, 0.06, 0.20, 0.02]);
        Sketch.jaggedRange(canvas, area, const Color(0xFFB98363), 0.76, [0.0, 0.10, 0.02, 0.12, 0.0]);
        Sketch.rockChurch(canvas, Offset(area.width * 0.5, area.height * 0.40), area.width * 0.22, area.height * 0.42);
        break;
      case JourneyRegion.sidama:
        Sketch.sky(canvas, area, const Color(0xFFBFE6D8), const Color(0xFFF4FBF6));
        Sketch.hill(canvas, area, const Color(0xFF6FA85A), 0.78, 0.0, leftLean: 0.3, rightLean: 0.7);
        Sketch.lake(canvas, area, 0.66);
        Sketch.palm(canvas, Offset(area.width * 0.26, area.height * 0.78), 0.9);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _RegionIconPainter oldDelegate) => oldDelegate.region != region;
}
