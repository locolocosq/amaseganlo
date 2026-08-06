import 'package:flutter/material.dart';

/// The "Äthiopien-Reise" stops the curriculum's sections are themed around
/// (Abschnitt Design) - see ENTSCHEIDUNGEN.md for why the underlying lesson
/// order/content stays unchanged, only the framing. [harar] is Etappe 22's
/// newest stop - added to the map/route ahead of having real curriculum
/// content, so it is deliberately NOT referenced by any `CurriculumSection.
/// region` yet. Every place that switches on [JourneyRegion] must still
/// cover it (Dart's exhaustiveness check enforces this), which is exactly
/// what keeps "add a stop with no content yet" safe to do.
enum JourneyRegion { addisAbeba, oromia, tigray, sidama, harar }

JourneyRegion? journeyRegionFromId(String id) {
  switch (id) {
    case 'addis_abeba':
      return JourneyRegion.addisAbeba;
    case 'oromia':
      return JourneyRegion.oromia;
    case 'tigray':
      return JourneyRegion.tigray;
    case 'sidama':
      return JourneyRegion.sidama;
    case 'harar':
      return JourneyRegion.harar;
    default:
      return null;
  }
}

/// Parses the `name` a [JourneyRegion] serializes to in map-screen route
/// paths (`/learn/region/:regionId`) - unlike [journeyRegionFromId] this
/// matches the Dart enum name, not the curriculum's snake_case id, since
/// it round-trips through `EnumName.name` for the URL.
JourneyRegion? journeyRegionFromRouteName(String name) {
  for (final region in JourneyRegion.values) {
    if (region.name == name) return region;
  }
  return null;
}

/// A fixed accent color per region (Etappe 14 map redesign) - used for its
/// world-map node ring, its detail-map path/decoration palette, and its
/// station markers, so the same region always "feels" the same across both
/// map levels regardless of the app's light/dark theme.
extension JourneyRegionTheme on JourneyRegion {
  Color get accent {
    switch (this) {
      case JourneyRegion.addisAbeba:
        return const Color(0xFF6B7A99);
      case JourneyRegion.oromia:
        return const Color(0xFF5F9653);
      case JourneyRegion.tigray:
        return const Color(0xFFB98363);
      case JourneyRegion.sidama:
        return const Color(0xFF3F8FA6);
      case JourneyRegion.harar:
        // Deliberately muted/grey rather than a vivid theme color (unlike
        // the other four) - Harar has no real content yet, and this single
        // choice is what makes its glow/ring/badges read as "greyed out"
        // everywhere that already colors by region.accent, with no need
        // for a "locked" special case in each of those places.
        return const Color(0xFF9E9E9E);
    }
  }
}
