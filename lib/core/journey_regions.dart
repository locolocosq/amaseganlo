import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// The "Äthiopien-Reise" stops the curriculum's sections are themed around
/// (Abschnitt Design) - see ENTSCHEIDUNGEN.md for why the underlying lesson
/// order/content stays unchanged, only the framing. [harar] now has real B2
/// content (Islam/Christentum/restliches B2, Etappe 24 Nachtrag 2). [safari]
/// is the final, capstone stop - it teaches no new vocabulary of its own,
/// only male/female grammar (pronunciation and sentence-building
/// differences) built entirely from words every earlier stop already
/// taught. Every place that switches on [JourneyRegion] must still cover
/// both (Dart's exhaustiveness check enforces this).
enum JourneyRegion { addisAbeba, oromia, tigray, sidama, harar, safari }

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
    case 'safari':
      return JourneyRegion.safari;
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

/// The one short place-name for a region, used everywhere space is tight -
/// the world map's marker (accessibility label since Etappe 24 Nachtrag, which
/// dropped the visible caption pennant entirely) and the profile passport's
/// stamp caption. Addis Abeba and Sidama get an explicit override rather
/// than deriving a short name from the curriculum section's own (much
/// longer) title: Addis Abeba's is shortened to its everyday nickname
/// "Addis". Sidama's marker sits, for tap-clearance reasons, well east of
/// Sidama's own territory and inside Ethiopia's real Somali Region (see
/// [EthiopiaMap.geoPositions]) - it would be geographically more accurate to
/// label it "Somali" there, but the user explicitly asked for "Süden"
/// (matching the section's own "Der Süden — Sidama & Gurage" title) instead,
/// accepting that trade-off.
String journeyRegionShortLabel(JourneyRegion region, AppLocalizations l10n) {
  switch (region) {
    case JourneyRegion.addisAbeba:
      return l10n.journeyRegionLabelAddisAbeba;
    case JourneyRegion.tigray:
      return l10n.journeyRegionLabelTigray;
    case JourneyRegion.oromia:
      return l10n.journeyRegionLabelOromia;
    case JourneyRegion.sidama:
      return l10n.journeyRegionLabelSouth;
    case JourneyRegion.harar:
      return l10n.journeyRegionHarar;
    case JourneyRegion.safari:
      return l10n.journeyRegionLabelSafari;
  }
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
        // Warm gold - Harar's old walled city and its mosques/minarets
        // (Etappe 24 Nachtrag 2).
        return const Color(0xFFC9A227);
      case JourneyRegion.safari:
        // Sunset terracotta - the capstone stop, distinct from every
        // region it draws its grammar practice from.
        return const Color(0xFFD9662D);
    }
  }
}
