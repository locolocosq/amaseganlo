import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/audio_service.dart';

/// These tests are only about TTS voice detection, not the bundled-audio
/// manifest - using the real `rootBundle` would pull in the app's actual
/// `assets/audio/manifest.json`, which now has real entries and would make
/// `isAmharicAvailable` true via bundled audio alone regardless of what the
/// scripted TTS client answers, defeating the point of these tests.
class _EmptyAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw FlutterError('no assets in this fake bundle');
  }
}

/// Answers `isLanguageAvailable` with a fixed sequence of results per call,
/// so tests can simulate the web Speech Synthesis API's voice list still
/// being empty on the very first check right after page load.
class _ScriptedTtsClient implements TtsClient {
  final List<bool> answers;
  int _calls = 0;

  _ScriptedTtsClient(this.answers);

  @override
  Future<bool> isLanguageAvailable(String language) async {
    final result = answers[_calls.clamp(0, answers.length - 1)];
    _calls++;
    return result;
  }

  @override
  Future<void> setLanguage(String language) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> setSpeechRate(double rate) async {}
  @override
  Future<void> speak(String text) async {}
  @override
  Future<void> stop() async {}
}

class _FakeAudioPlayerClient implements AudioPlayerClient {
  @override
  Future<void> play(String assetPath, {required double volume, double rate = 1.0}) async {}
  @override
  Future<void> stop() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a voice reported unavailable on the first check but available on retry still counts as available', () async {
    final service = AudioService(
      tts: _ScriptedTtsClient([false, true]),
      player: _FakeAudioPlayerClient(),
      bundle: _EmptyAssetBundle(),
      voiceRetryDelay: Duration.zero,
    );
    await service.init();

    expect(service.isAmharicAvailable, isTrue);
  });

  test('a voice unavailable on every attempt is correctly reported as unavailable', () async {
    final service = AudioService(
      tts: _ScriptedTtsClient([false, false]),
      player: _FakeAudioPlayerClient(),
      bundle: _EmptyAssetBundle(),
      voiceRetryDelay: Duration.zero,
    );
    await service.init();

    expect(service.isAmharicAvailable, isFalse);
  });

  test('a voice available on the very first check needs no retry', () async {
    final service = AudioService(
      tts: _ScriptedTtsClient([true]),
      player: _FakeAudioPlayerClient(),
      bundle: _EmptyAssetBundle(),
      voiceRetryDelay: Duration.zero,
    );
    await service.init();

    expect(service.isAmharicAvailable, isTrue);
  });
}
