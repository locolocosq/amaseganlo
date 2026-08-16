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
/// [asmara], [massawa], [keren] and [dahlak] (Etappe 26/27) are Eritrea's
/// stops for a second target language - Tigrinya, not Amharic. Etappe 26
/// first tried a single combined [eritrea] node on this same map; Etappe 27
/// gave Eritrea its own top-level swipeable map instead (see
/// [WorldMapScreen]/`EritreaCountryMap`), with these four stops laid out on
/// it exactly the way [addisAbeba]..[safari] are laid out here - a road, a
/// bus, one stop per curriculum section. [dahlak] plays the same role
/// [safari] plays for Ethiopia: the final, capstone stop, no new vocabulary
/// of its own, only sentence-building with conjunctions built entirely from
/// words the three earlier Eritrea stops already taught. None of these four
/// are locked behind finishing every Amharic region first, or behind each
/// other beyond normal sequential unlocking - see [JourneyProgress]'s
/// per-language unlock tracks. Every place that switches on [JourneyRegion]
/// must still cover all ten values (Dart's exhaustiveness check enforces
/// this).
enum JourneyRegion { addisAbeba, oromia, tigray, sidama, harar, safari, asmara, massawa, keren, dahlak }

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
    case 'asmara':
      return JourneyRegion.asmara;
    case 'massawa':
      return JourneyRegion.massawa;
    case 'keren':
      return JourneyRegion.keren;
    case 'dahlak':
      return JourneyRegion.dahlak;
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
    case JourneyRegion.asmara:
      return l10n.journeyRegionLabelAsmara;
    case JourneyRegion.massawa:
      return l10n.journeyRegionLabelMassawa;
    case JourneyRegion.keren:
      return l10n.journeyRegionLabelKeren;
    case JourneyRegion.dahlak:
      return l10n.journeyRegionLabelDahlak;
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
      case JourneyRegion.asmara:
        // Warm coral/pink - Asmara's famous Art Deco skyline is built from
        // exactly this pastel palette (Etappe 27).
        return const Color(0xFFD97B66);
      case JourneyRegion.massawa:
        // The same deep Red Sea marine blue Etappe 26 chose for the single
        // combined Eritrea node - Massawa is the real port city that art
        // was always depicting, so it keeps the colour on the new map.
        return const Color(0xFF1D6FA3);
      case JourneyRegion.keren:
        // An olive/agricultural green, distinct from Oromia's brighter
        // highland green - Keren sits in Eritrea's western farming belt.
        return const Color(0xFF7A8B4F);
      case JourneyRegion.dahlak:
        // A light turquoise for the Dahlak archipelago's shallow reef
        // water - the capstone stop, distinct from Massawa's deeper blue.
        return const Color(0xFF5EC4C0);
    }
  }
}
