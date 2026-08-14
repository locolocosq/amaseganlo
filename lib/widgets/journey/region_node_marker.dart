import 'package:flutter/material.dart';

import '../../core/journey_regions.dart';
import '../../core/theme.dart';
import 'painter_helpers.dart';

/// [comingSoon] (Etappe 22, Harar) looks similar to [upcoming] (grey ring,
/// desaturated) but is a distinct state on purpose: unlike a normal
/// upcoming region, tapping it never navigates anywhere - there is no
/// content to show yet, only a "Bald verfügbar" hint.
enum RegionVisualState { completed, current, upcoming, comingSoon }

/// One tappable region "medallion" on the Ebene-1 world map: a round,
/// hand-drawn mini landmark icon on a wooden signpost platform, and a small
/// badge showing where the learner stands (done/current/not-yet-reached).
/// The place name itself is announced via this widget's [Semantics] label,
/// not shown as a visible caption (Etappe 24 Nachtrag - a text pennant
/// under the medallion used to be here, removed on request for taking up
/// too much room; the per-region artwork already tells stops apart).
/// Regions are never actually locked for *viewing* - only individual
/// stations inside them are, via the same rules as before (Abschnitt
/// Design) - so this only changes look, not tap behaviour.
class RegionNodeMarker extends StatelessWidget {
  final JourneyRegion region;
  final String title;
  final int stationNumber;
  final RegionVisualState state;
  final int crownsEarned;
  final int crownsPossible;
  final String? comingSoonLabel;

  /// Null for a [RegionVisualState.comingSoon] node - it never navigates
  /// anywhere, only shows [comingSoonLabel] as a brief tap response.
  final VoidCallback? onTap;

  const RegionNodeMarker({
    super.key,
    required this.region,
    required this.title,
    required this.stationNumber,
    required this.state,
    required this.crownsEarned,
    required this.crownsPossible,
    required this.onTap,
    this.comingSoonLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final comingSoon = state == RegionVisualState.comingSoon;
    final upcoming = state == RegionVisualState.upcoming || comingSoon;
    final ringColor = upcoming ? theme.colorScheme.outlineVariant : region.accent;
    // Etappe 24: shrunk again from 64/80 (itself already down from 88/128)
    // - still too large/dominant relative to the map card and the road
    // running under it.
    const double diameter = 52;

    return Semantics(
      button: true,
      label: comingSoon ? '$title. ${comingSoonLabel ?? ''}' : title,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          // Etappe 24: narrowed again from 80 (itself already down from
          // 96) alongside the diameter shrink above - re-verified with a
          // throwaway geometry script that every region's tap box still
          // clears every other's at the real map scale (see
          // EthiopiaMap.geoPositions), not eyeballed.
          width: 66,
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
                            color: (upcoming ? Colors.black : ringColor).withValues(alpha: state == RegionVisualState.current ? 0.5 : 0.3),
                            blurRadius: state == RegionVisualState.current ? 22 : 12,
                            spreadRadius: state == RegionVisualState.current ? 2 : 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    Opacity(
                      opacity: upcoming ? 0.55 : 1,
                      child: Container(
                        width: diameter,
                        height: diameter,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.surface,
                          border: Border.all(color: ringColor, width: 3),
                        ),
                        child: ClipOval(
                          child: CustomPaint(painter: _RegionIconPainter(region: region), size: Size.infinite),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -6,
                      left: -6,
                      child: _NumberFlag(number: stationNumber, color: upcoming ? theme.colorScheme.outline : region.accent),
                    ),
                    // Etappe 24 Nachtrag 4: moved up to the top-right corner
                    // (was bottom-right) so it no longer collides with the
                    // crown pill now sitting directly against the medallion's
                    // bottom edge, on request.
                    if (state == RegionVisualState.completed)
                      Positioned(
                        top: -6,
                        right: -6,
                        child: _Badge(icon: Icons.check, color: successColor),
                      ),
                    if (upcoming)
                      Positioned(
                        top: -6,
                        right: -6,
                        child: _Badge(icon: comingSoon ? Icons.hourglass_empty : Icons.lock, color: theme.colorScheme.outline),
                      ),
                    // Etappe 24 Nachtrag 4: pulled up from below the
                    // medallion (with a gap) to sit directly against its
                    // bottom edge instead, on request.
                    if (crownsPossible > 0)
                      Positioned(
                        bottom: -10,
                        left: 0,
                        right: 0,
                        child: Center(child: _CrownSummary(earned: crownsEarned, possible: crownsPossible)),
                      ),
                  ],
                ),
              ),
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
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 3, offset: Offset(0, 1))],
      ),
      child: Text(
        '$number',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
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
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
      child: Icon(icon, size: 11, color: Colors.white),
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
      // Etappe 22 Nachtrag 5: tightened padding/icon/gap - the marker's
      // outer width narrowed (see RegionNodeMarker, further shrunk again
      // in Etappe 24) to make real room for every region's tap target,
      // and a section with a
      // two-digit crown count ("25/25") no longer fit this pill's old,
      // roomier padding within that width - a real overflow, not
      // hypothetical.
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(10)),
      // Belt-and-suspenders against the box the marker's width narrowed
      // into: `possible` grows with however many units a section ends up
      // with, so rather than re-tune padding by hand again if a future
      // section needs a 3-digit crown count, FittedBox just scales the
      // whole pill down to fit - it can never overflow regardless of how
      // long the number gets.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 10, color: Color(0xFFF4C430)),
            const SizedBox(width: 2),
            Text('$earned/$possible', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
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
      case JourneyRegion.harar:
        // Harar, "city of minarets" (Etappe 24 Nachtrag 2: real content).
        Sketch.sky(canvas, area, const Color(0xFFF6E7BE), const Color(0xFFFFF6E0));
        Sketch.mosque(canvas, Offset(area.width * 0.5, area.height * 0.86), area.width / 100);
        break;
      case JourneyRegion.safari:
        // The capstone stop - a savanna dusk, since its grammar practice
        // spans everything learned across every earlier region.
        Sketch.sky(canvas, area, const Color(0xFFF7B267), const Color(0xFFF4845F));
        Sketch.hill(canvas, area, const Color(0xFF7A5A3A), 0.80, 0.04, leftLean: 0.25, rightLean: 0.75);
        Sketch.acacia(canvas, Offset(area.width * 0.68, area.height * 0.86), 0.95);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _RegionIconPainter oldDelegate) => oldDelegate.region != region;
}
