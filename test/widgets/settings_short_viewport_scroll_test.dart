import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/settings.dart';
import 'test_harness.dart';

/// Etappe 26: reported bug - on a short desktop browser window (e.g. one
/// truncated by the Windows taskbar), the "Über die App" entry at the very
/// bottom of the settings list (with the hidden 7-tap dev-code unlock) could
/// not be scrolled into view. The default test surface (800x600) is tall
/// enough that this never reproduced in existing tests (see
/// dev_code_unlock_test.dart) - this test shrinks the viewport well below
/// the settings list's natural content height instead, so it actually
/// exercises the same constrained-viewport situation that was reported.
void main() {
  testWidgets(
    'the About entry stays reachable by scrolling even on a short viewport',
    (tester) async {
      tester.view.physicalSize = const Size(800, 420);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpTestApp(
        tester,
        initialPrefs: {
          'amaseganlo.settings': jsonEncode(
            const AppSettings(localeCode: 'de').toJson(),
          ),
        },
      );

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Über die App'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Über die App'), findsOneWidget);

      await tester.tap(find.text('Über die App'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Version'), findsOneWidget);
    },
  );
}
