import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/audio_service.dart';
import 'test_harness.dart';

/// Regression test for a real bug: "Neue Wörter automatisch abspielen"
/// (Einstellungen, default on) never actually triggered any playback -
/// hearing a word required noticing and tapping the small speaker icon on
/// the intro card, which a user testing on a real device never did,
/// reporting "kein Ton" even though the audio pipeline itself worked fine.
/// See ENTSCHEIDUNGEN.md Etappe 21.
class _EmptyAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw FlutterError('no assets in this fake bundle');
  }
}

class _SpyTtsClient implements TtsClient {
  bool spoke = false;
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
    spoke = true;
    lastSpoken = text;
  }

  @override
  Future<void> stop() async {}
}

class _NoopAudioPlayerClient implements AudioPlayerClient {
  @override
  Future<void> play(String assetPath, {required double volume, double rate = 1.0}) async {}
  @override
  Future<void> stop() async {}
}

void main() {
  testWidgets('a new word intro card plays its audio automatically, without tapping the speaker icon', (tester) async {
    final tts = _SpyTtsClient();
    final audioService = AudioService(
      tts: tts,
      player: _NoopAudioPlayerClient(),
      bundle: _EmptyAssetBundle(),
      voiceRetryDelay: Duration.zero,
    );

    await pumpTestLesson(
      tester,
      unitId: 'unit_erste_begegnung',
      lessonId: 'lesson_erste_begegnung_intro',
      audioService: audioService,
    );

    expect(tts.spoke, isTrue);
    expect(tts.lastSpoken, 'ሰላም');
  });
}
