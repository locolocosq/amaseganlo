import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/journey_map_layout.dart';
import 'package:habesha_speak/models/settings.dart';
import 'package:habesha_speak/models/user_progress.dart';
import 'package:habesha_speak/widgets/journey/traveling_bus.dart';

import 'test_harness.dart';

void main() {
  testWidgets('the bus lands at the region actually reached, not a naive index fraction of the road', (tester) async {
    // sec_a1_1 (Addis Abeba, 7 units), sec_a1_2 (Tigray, 21 units) and
    // sec_a2 (Oromia, 36 units) fully skipped/done makes Sidama (index 3 of
    // 6 regions) the current region - matching the passport test's "mark
    // every unit skipped counts as done" recipe. Index 3 specifically:
    // measuring the real road segments (see below) shows the cumulative
    // length up to region 3 diverges from the naive 3/5 index fraction by
    // ~9%, a big enough gap that this test can't pass by accident the way
    // it would at, say, index 2 (where the two happen to coincide within 0.1%).
    final seeded = UserProgress(
      skippedUnitIds: {
        'unit_erste_begegnung',
        'unit_ich_und_du',
        'unit_familie_menschen',
        'unit_zahlen_1_20',
        'unit_essen_trinken',
        'unit_fragewoerter',
        'unit_adverbien_mehr',
        'unit_zuhause',
        'unit_zeit',
        'unit_farben_eigenschaften',
        'unit_zahlen_einkaufen',
        'unit_in_der_stadt',
        'unit_kleidung',
        'unit_praepositionen',
        'unit_haushalt',
        'unit_essen_mehr',
        'unit_zahlen_ordnung',
        'unit_moebel',
        'unit_zahlen_21_99',
        'unit_zahlen_mehr2',
        'unit_mengen_zeit_jahreszeiten',
        'unit_kueche_farben_getraenke',
        'unit_wetter_mehr',
        'unit_tiere_mehr',
        'unit_haushalt_mehr',
        'unit_kleidung_mehr',
        'unit_kuechenwerkzeuge',
        'unit_buerobedarf',
        'unit_verben_alltag',
        'unit_gegenwart_vergangenheit',
        'unit_koerper_gesundheit',
        'unit_arbeit_schule',
        'unit_reisen_verkehr',
        'unit_wetter_natur',
        'unit_berufe',
        'unit_sport_freizeit',
        'unit_mehr_adjektive',
        'unit_laender',
        'unit_verben_mehr',
        'unit_materialien',
        'unit_verben_erweitert',
        'unit_elektronik_kontinente',
        'unit_gesundheit_natur_schule',
        'unit_gefuehle_mehr',
        'unit_persoenlichkeit',
        'unit_berufe_mehr',
        'unit_einkaufen_mehr',
        'unit_verkehr_mehr',
        'unit_richtungen',
        'unit_sport_mehr',
        'unit_natur_mehr',
        'unit_landwirtschaft',
        'unit_gesundheit_mehr2',
        'unit_zeit_adverbien',
        'unit_konjunktionen',
        'unit_verben_bewegung',
        'unit_camping_wandern',
        'unit_werkzeuge',
        'unit_zahlen_teile',
        'unit_haushaltsgeraete',
        'unit_koerperteile_mehr',
        'unit_familie_mehr',
        'unit_verben_kochen',
      },
    );

    await pumpTestApp(
      tester,
      initialPrefs: {
        'amaseganlo.progress': jsonEncode(seeded.toJson()),
        'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson()),
      },
    );
    await tester.pumpAndSettle();

    final bus = tester.widget<TravelingBus>(find.byType(TravelingBus));
    final actualProgress = bus.progress.value;

    // Independently recompute what the *real* road geometry says the
    // progress fraction for "3 regions behind" should be, using the exact
    // same road-building function the screen itself uses.
    final size = tester.getSize(find.byType(TravelingBus));
    final segments = WorldMapLayout.allRoads(size);
    double pathLength(Path p) => p.computeMetrics().fold<double>(0, (sum, m) => sum + m.length);
    final totalLength = segments.fold<double>(0, (sum, s) => sum + pathLength(s));
    final reachedLength = segments.take(3).fold<double>(0, (sum, s) => sum + pathLength(s));
    final expectedProgress = reachedLength / totalLength;

    // The old, buggy calculation would have set this to a flat 3/5 = 0.6
    // regardless of how long each of the 5 road segments actually is. Confirm
    // the real segments actually diverge meaningfully from that here, so a
    // pass below can't be a coincidence of equal-length segments.
    const naiveIndexProgress = 3 / 5;
    expect(
      expectedProgress,
      isNot(closeTo(naiveIndexProgress, 0.03)),
      reason: 'road segments need unequal lengths for this test to actually distinguish real vs. naive progress',
    );

    expect(actualProgress, closeTo(expectedProgress, 0.01));
  });
}
