import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/l10n/app_localizations.dart';
import 'package:amaseganlo/models/fidel_char.dart';
import 'package:amaseganlo/widgets/exercises/hahu_drill.dart';

void main() {
  testWidgets('tapping the beat button gives visual feedback without affecting correctness', (tester) async {
    const chars = [
      FidelChar(char: 'ለ', base: 'l', group: 'la', order: 1, tr: 'le', ipa: 'lə'),
    ];

    var completed = false;

    await tester.pumpWidget(MaterialApp(
      locale: const Locale('de'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: HaHuDrill(
          chars: chars,
          tickDuration: const Duration(milliseconds: 50),
          reduceMotion: true,
          onComplete: () => completed = true,
        ),
      ),
    ));

    await tester.tap(find.byIcon(Icons.touch_app));
    await tester.pump();
    // Let the tap's own short pulse animation timer resolve, and let the
    // drill itself finish both rounds, so nothing is left pending.
    for (var i = 0; i < 7; i++) {
      await tester.pump(const Duration(milliseconds: 60));
    }

    expect(completed, isTrue);
  });
}
