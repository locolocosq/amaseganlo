import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/models/settings.dart';
import 'package:amaseganlo/models/user_progress.dart';
import 'test_harness.dart';

void main() {
  testWidgets('the passport stamp for a finished stop is filled in, the others stay outlined', (tester) async {
    // sec_a1_1 (Addis Abeba) has exactly these 7 units - marking all of
    // them skipped counts as "done" for stamp purposes, same as the path
    // screen's own section-completion check.
    final seeded = UserProgress(
      skippedUnitIds: {
        'unit_erste_begegnung',
        'unit_ich_und_du',
        'unit_familie_menschen',
        'unit_zahlen_1_20',
        'unit_essen_trinken',
        'unit_fragewoerter',
        'unit_adverbien_mehr',
      },
    );
    await pumpTestApp(
      tester,
      initialPrefs: {
        'amaseganlo.progress': jsonEncode(seeded.toJson()),
        'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson()),
      },
    );

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('Dein Reisepass'), findsOneWidget);

    final outline = Theme.of(tester.element(find.byIcon(Icons.location_city))).colorScheme.outline;
    final addisAbebaStamp = tester.widget<Icon>(find.byIcon(Icons.location_city));
    expect(addisAbebaStamp.color, isNot(outline));

    final oromiaStamp = tester.widget<Icon>(find.byIcon(Icons.landscape));
    expect(oromiaStamp.color, outline);
  });
}
