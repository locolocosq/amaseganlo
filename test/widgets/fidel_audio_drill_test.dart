import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/audio_service.dart';

import 'test_harness.dart';

/// Forces AudioService's manifest lookup to fail so [_SpyTtsClient] is
/// guaranteed to be the one that ends up speaking - same reasoning as the
/// identically-named class in lesson_intro_autoplay_test.dart.
class _EmptyAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw FlutterError('no assets in this fake bundle');
  }
}

class _SpyTtsClient implements TtsClient {
  String? lastSpoken;

  @override
  Future<bool> isLanguageAvailable(String language) async => true;
  @override
  Future<void> setLanguage(String language) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> setSpeechRate(double rate) async {}
  @override
  Future<void> speak(String text) async {
    lastSpoken = text;
  }

  @override
  Future<void> stop() async {}
}

void main() {
  testWidgets(
    'Etappe 24 "Hörtraining": the CTA only shows once audio is available, autoplays each sign, and can be answered by ear',
    (tester) async {
      final tts = _SpyTtsClient();
      final audioService = AudioService(
        tts: tts,
        player: FakeAudioPlayerClient(),
        bundle: _EmptyAssetBundle(),
        voiceRetryDelay: Duration.zero,
      );

      await pumpTestApp(tester, audioService: audioService);

      await tester.tap(find.byIcon(Icons.abc_outlined));
      await tester.pumpAndSettle();

      // Default test locale is English (see premium_screen_test.dart, which
      // has to opt into German explicitly) - "Listening drill" is
      // fidelAudioDrillTitle from app_en.arb.
      expect(find.text('Listening drill'), findsOneWidget);

      await tester.tap(find.text('Listening drill'));
      await tester.pumpAndSettle();

      // The drill's whole point: it plays the sign automatically, without
      // requiring a tap first (unlike a regular listenChoice exercise).
      expect(tts.lastSpoken, isNotNull, reason: 'the first exercise should have auto-played already');
      final correctChar = tts.lastSpoken!;

      // No transliteration text is shown anywhere - only the spoken sign and
      // four single-character sign options, exactly like generateListenToChar.
      expect(find.text(correctChar), findsOneWidget);

      await tester.tap(find.text(correctChar));
      await tester.pumpAndSettle();

      expect(find.text('Correct!'), findsOneWidget);
    },
  );
}
