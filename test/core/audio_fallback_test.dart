import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/core/audio_service.dart';

/// A fake bundle that serves a fixed `manifest.json` declaring exactly one
/// bundled word recording, so tests can exercise the "bundled asset exists
/// but fails to play" path without touching the real, 1057-file manifest.
class _ManifestOnlyBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key == 'assets/audio/manifest.json') {
      final json = jsonEncode({
        'words': {'lex_haus': 'audio/words/lex_haus.mp3'},
        'feedback': <String, String>{},
      });
      final bytes = utf8.encode(json);
      return ByteData.view(Uint8List.fromList(bytes).buffer);
    }
    throw FlutterError('no asset for $key in this fake bundle');
  }
}

class _AlwaysAvailableTtsClient implements TtsClient {
  bool spoke = false;
  String? lastSpoken;

  @override
  Future<bool> isLanguageAvailable(String language) async => true;
  @override
  Future<void> setLanguage(String language) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> speak(String text) async {
    spoke = true;
    lastSpoken = text;
  }

  @override
  Future<void> stop() async {}
}

/// Simulates a bundled mp3 that the platform player can't decode (the real
/// bug this test guards against: a bad audio file must not mean silence).
class _ThrowingAudioPlayerClient implements AudioPlayerClient {
  @override
  Future<void> play(String assetPath, {required double volume}) async {
    throw Exception('PlatformException(WebAudioError, Failed to set source)');
  }

  @override
  Future<void> stop() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('speakText falls back to TTS when the bundled asset fails to play', () async {
    final tts = _AlwaysAvailableTtsClient();
    final service = AudioService(
      tts: tts,
      player: _ThrowingAudioPlayerClient(),
      bundle: _ManifestOnlyBundle(),
      voiceRetryDelay: Duration.zero,
    );
    await service.init();

    await service.speakText(id: 'lex_haus', amharicText: 'ቤት');

    expect(tts.spoke, isTrue);
    expect(tts.lastSpoken, 'ቤት');
  });
}
