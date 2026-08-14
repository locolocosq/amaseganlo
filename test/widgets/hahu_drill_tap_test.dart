import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/l10n/app_localizations.dart';
import 'package:habesha_speak/models/fidel_char.dart';
import 'package:habesha_speak/widgets/exercises/hahu_drill.dart';

void main() {
  testWidgets('tapping the button pulses once and advances exactly one step', (tester) async {
    const chars = [
      FidelChar(char: 'ለ', base: 'l', group: 'la', order: 1, tr: 'le', ipa: 'lə'),
      FidelChar(char: 'ሉ', base: 'l', group: 'la', order: 2, tr: 'lu', ipa: 'lu'),
    ];

    var completed = false;

    await tester.pumpWidget(MaterialApp(
      locale: const Locale('de'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: HaHuDrill(
          chars: chars,
          onComplete: () => completed = true,
        ),
      ),
    ));

    await tester.tap(find.byIcon(Icons.touch_app));
    await tester.pump();
    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1.15);

    // The pulse settles back down on its own shortly after the tap.
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1.0);
    expect(completed, isFalse);

    // 2 signs x 2 rounds - 1 tap already spent above, 3 more finish it.
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byIcon(Icons.touch_app));
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(completed, isTrue);
  });
}
