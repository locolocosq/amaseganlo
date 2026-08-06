import 'package:flutter/material.dart';

import '../../core/journey_progress.dart';
import '../../core/journey_regions.dart';
import '../../core/theme.dart';

/// One numbered station ("1-1", "1-2", ...) on the Ebene-2 region path -
/// the direct visual equivalent of the old list's `_UnitTile`, just placed
/// on the winding map instead of stacked in a list. State semantics (which
/// units are locked/current/done) are unchanged - see [JourneyProgress].
class StationNodeMarker extends StatelessWidget {
  final JourneyRegion region;
  final String numberLabel;
  final String title;
  final UnitState state;
  final int crowns;
  final VoidCallback onTap;

  const StationNodeMarker({
    super.key,
    required this.region,
    required this.numberLabel,
    required this.title,
    required this.state,
    required this.crowns,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locked = state == UnitState.locked;

    late final Color ringColor;
    late final IconData icon;
    late final Color iconColor;
    switch (state) {
      case UnitState.completed:
        ringColor = successColor;
        icon = Icons.check;
        iconColor = successColor;
        break;
      case UnitState.skipped:
        ringColor = successColor;
        icon = Icons.fast_forward;
        iconColor = successColor;
        break;
      case UnitState.current:
        ringColor = theme.colorScheme.primary;
        icon = Icons.play_arrow;
        iconColor = theme.colorScheme.primary;
        break;
      case UnitState.locked:
        ringColor = theme.colorScheme.outlineVariant;
        icon = Icons.lock;
        iconColor = theme.colorScheme.outline;
        break;
    }

    const double diameter = 62;

    return Semantics(
      button: true,
      label: '$numberLabel $title',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: diameter,
                height: diameter,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (state == UnitState.current ? ringColor : Colors.black).withValues(alpha: state == UnitState.current ? 0.5 : 0.22),
                        blurRadius: state == UnitState.current ? 14 : 6,
                      ),
                    ],
                  ),
                  child: Opacity(
                    opacity: locked ? 0.75 : 1,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.surface,
                        border: Border.all(color: ringColor, width: 4),
                      ),
                      child: Center(child: Icon(icon, color: iconColor, size: 26)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: region.accent, borderRadius: BorderRadius.circular(10)),
                child: Text(numberLabel, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 3, offset: Offset(0, 1))],
                ),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall,
                ),
              ),
              if (crowns > 0) ...[
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < 5; i++)
                      Icon(Icons.emoji_events, size: 9, color: i < crowns ? successColor : theme.colorScheme.outlineVariant),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
