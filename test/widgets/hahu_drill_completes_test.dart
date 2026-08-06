import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/l10n/app_localizations.dart';
import 'package:habesha_speak/models/fidel_char.dart';
import 'package:habesha_speak/widgets/exercises/hahu_drill.dart';

void main() {
  testWidgets('HaHuDrill cycles through both rounds without any sound and then completes', (tester) async {
    const chars = [
      FidelChar(char: 'ለ', base: 'l', group: 'la', order: 1, tr: 'le', ipa: 'lə'),
      FidelChar(char: 'ሉ', base: 'l', group: 'la', order: 2, tr: 'lu', ipa: 'lu'),
      FidelChar(char: 'ሊ', base: 'l', group: 'la', order: 3, tr: 'li', ipa: 'li'),
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

    expect(find.text('ለ'), findsOneWidget);
    expect(completed, isFalse);

    // 3 signs x 2 rounds x 50ms, plus a margin - enough real time for the
    // internal Timer.periodic to fire every beat and finish both rounds.
    for (var i = 0; i < 7; i++) {
      await tester.pump(const Duration(milliseconds: 60));
    }

    expect(completed, isTrue);
  });
}
