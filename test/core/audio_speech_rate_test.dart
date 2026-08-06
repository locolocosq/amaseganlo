import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/audio_service.dart';

/// Serves a manifest with one bundled word and one feedback chime, so both
/// [AudioService.speakText] and [AudioService.playFeedback] can be
/// exercised against the same fake bundle.
class _ManifestBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key == 'assets/audio/manifest.json') {
      final json = jsonEncode({
        'words': {'lex_haus': 'audio/words/lex_haus.mp3'},
        'feedback': {'correct': 'audio/feedback/correct.mp3'},
      });
      return ByteData.view(Uint8List.fromList(utf8.encode(json)).buffer);
    }
    throw FlutterError('no asset for $key in this fake bundle');
  }
}

class _RecordingTtsClient implements TtsClient {
  double? lastRate;

  @override
  Future<bool> isLanguageAvailable(String language) async => true;
  @override
  Future<void> setLanguage(String language) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> setSpeechRate(double rate) async => lastRate = rate;
  @override
  Future<void> speak(String text) async {}
  @override
  Future<void> stop() async {}
}

class _RecordingAudioPlayerClient implements AudioPlayerClient {
  double? lastRate;

  @override
  Future<void> play(String assetPath, {required double volume, double rate = 1.0}) async {
    lastRate = rate;
  }

  @override
  Future<void> stop() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('speakText applies the configured speech rate to bundled word audio', () async {
    final player = _RecordingAudioPlayerClient();
    final service = AudioService(tts: _RecordingTtsClient(), player: player, bundle: _ManifestBundle());
    await service.init();
    service.speechRate = 0.5;

    await service.speakText(id: 'lex_haus', amharicText: 'ቤት');

    expect(player.lastRate, 0.5);
  });

  test('speakText applies the configured speech rate to the TTS fallback', () async {
    final tts = _RecordingTtsClient();
    // A bundle with no words at all forces the TTS fallback path.
    final service = AudioService(
      tts: tts,
      player: _RecordingAudioPlayerClient(),
      bundle: _ManifestBundle(),
    );
    await service.init();
    service.speechRate = 0.75;

    await service.speakText(id: 'lex_unbundled', amharicText: 'ሰላም');

    expect(tts.lastRate, 0.75);
  });

  test('playFeedback always plays at normal speed, regardless of speechRate', () async {
    final player = _RecordingAudioPlayerClient();
    final service = AudioService(tts: _RecordingTtsClient(), player: player, bundle: _ManifestBundle());
    await service.init();
    service.speechRate = 0.5;

    await service.playFeedback(correct: true);

    expect(player.lastRate, 1.0);
  });
}
