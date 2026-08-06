/// The 4 "Äthiopien-Reise" stops the curriculum's 4 sections are themed
/// around (Abschnitt Design) - see ENTSCHEIDUNGEN.md for why these four and
/// why the underlying lesson order/content is unchanged, only the framing.
enum JourneyRegion { addisAbeba, oromia, tigray, sidama }

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
    default:
      return null;
  }
}
