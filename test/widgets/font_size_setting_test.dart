import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

/// Regression test for a real crash: changing "Schriftgröße" to anything
/// other than "Normal" used to throw a `TextStyle.apply` assertion and
/// freeze the app in an error loop, because AppTheme.build() scaled
/// Material 3's default TextTheme (which leaves `fontSize` unset on every
/// style until Flutter's own Theme/Typography machinery fills it in) via
/// `TextStyle.apply(fontSizeFactor: ...)` - that assertion only tolerates a
/// null fontSize when the factor is exactly 1.0. Font scaling now goes
/// through MediaQuery's TextScaler in app.dart instead. See
/// ENTSCHEIDUNGEN.md Etappe 18.
void main() {
  testWidgets('every font size option can be selected without crashing, and actually changes text size', (tester) async {
    await pumpTestApp(
      tester,
      initialPrefs: {'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson())},
    );

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Schriftgröße'), 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();

    final normalSize = tester.getSize(find.text('Schriftgröße'));

    // Scoped to the font-size SegmentedButton specifically: other segmented
    // buttons further down the (now card-grouped, Etappe 19) settings screen
    // also have a "Normal" option (e.g. Ha-Hu-Tempo), and grouping everything
    // into cards shifted scroll offsets enough that both can be mounted at
    // once - a plain find.text(label) would then be ambiguous.
    final fontSizeSegmented = find.byType(SegmentedButton<FontSizeOption>);
    for (final label in ['Klein', 'Groß', 'Sehr groß', 'Normal']) {
      await tester.tap(find.descendant(of: fontSizeSegmented, matching: find.text(label)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'selecting "$label" must not throw');
    }

    await tester.tap(find.descendant(of: fontSizeSegmented, matching: find.text('Sehr groß')));
    await tester.pumpAndSettle();
    final largeSize = tester.getSize(find.text('Schriftgröße'));
    expect(largeSize.height, greaterThan(normalSize.height));
  });
}
