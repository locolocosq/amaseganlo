import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart' show AudioPlayer, AssetSource;
import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:flutter_tts/flutter_tts.dart';

/// Thin seams around `flutter_tts`/`audioplayers` so tests can inject fakes
/// that never touch a real platform channel. Constructing the real
/// `FlutterTts`/`AudioPlayer` classes and calling into them pulls in native
/// plugin code that - on this project's dev machine at least - makes every
/// widget test pay a many-minutes real-time-antivirus-scanning cost the
/// first time it runs (see ENTSCHEIDUNGEN.md, Etappe 7). Test code should
/// inject no-op implementations of these interfaces instead of letting
/// [AudioService] construct the real ones.
abstract class TtsClient {
  Future<bool> isLanguageAvailable(String language);
  Future<void> setLanguage(String language);
  Future<void> setVolume(double volume);
  Future<void> speak(String text);
  Future<void> stop();
}

class RealTtsClient implements TtsClient {
  final FlutterTts _tts = FlutterTts();

  @override
  Future<bool> isLanguageAvailable(String language) async => (await _tts.isLanguageAvailable(language)) == true;

  @override
  Future<void> setLanguage(String language) async => _tts.setLanguage(language);

  @override
  Future<void> setVolume(double volume) async => _tts.setVolume(volume);

  @override
  Future<void> speak(String text) async => _tts.speak(text);

  @override
  Future<void> stop() async => _tts.stop();
}

abstract class AudioPlayerClient {
  Future<void> play(String assetPath, {required double volume});
  Future<void> stop();
}

class RealAudioPlayerClient implements AudioPlayerClient {
  final AudioPlayer _player = AudioPlayer();

  @override
  Future<void> play(String assetPath, {required double volume}) => _player.play(AssetSource(assetPath), volume: volume);

  @override
  Future<void> stop() => _player.stop();
}

/// Every sound in the app goes through this single interface (Abschnitt 13):
/// bundled word/sentence audio if `assets/audio/manifest.json` declares one
/// for the given id, otherwise text-to-speech if an Amharic voice exists on
/// this device/browser, otherwise nothing - a missing voice or asset is
/// never an error, just silence, and callers only ever see
/// [isAmharicAvailable] to decide whether to offer listening exercises at
/// all.
///
/// Every call into [_tts]/[_player] is wrapped with a timeout, not just
/// try/catch: with no platform-channel handler registered, these plugins'
/// futures can simply never complete instead of throwing - a plain
/// try/catch does not protect against that, only an explicit timeout does.
class AudioService {
  static const _detectTimeout = Duration(seconds: 3);
  static const _playTimeout = Duration(seconds: 5);

  final TtsClient _tts;
  final AudioPlayerClient _player;
  final AssetBundle _bundle;
  final Duration _voiceRetryDelay;

  AudioService({
    TtsClient? tts,
    AudioPlayerClient? player,
    AssetBundle? bundle,
    Duration voiceRetryDelay = const Duration(milliseconds: 500),
  })  : _tts = tts ?? RealTtsClient(),
        _player = player ?? RealAudioPlayerClient(),
        _bundle = bundle ?? rootBundle,
        // this._voiceRetryDelay would force callers to use the private
        // field name as the argument label, so it's assigned manually.
        // ignore: prefer_initializing_formals
        _voiceRetryDelay = voiceRetryDelay;

  bool _initialized = false;
  String? _ttsAmharicLanguage;
  Map<String, String> _wordAudio = {};
  Map<String, String> _feedbackAudio = {};

  bool soundEnabled = true;
  double volume = 1.0;

  Future<void> init() async {
    await Future.wait([_detectAmharicTts(), _loadManifest()]);
    _initialized = true;
  }

  Future<void> _detectAmharicTts() async {
    for (final candidate in const ['am-ET', 'am']) {
      if (await _isAvailableWithRetry(candidate)) {
        _ttsAmharicLanguage = candidate;
        return;
      }
    }
    _ttsAmharicLanguage = null;
  }

  /// On web, `speechSynthesis.getVoices()` very often still returns an
  /// empty list on the first check right after page load - the browser
  /// populates it asynchronously, sometimes a few hundred ms later, with
  /// no platform-channel-level way for us to await that from here. One
  /// short retry catches a voice that genuinely exists but wasn't loaded
  /// yet; native platforms normally resolve on the first try either way,
  /// so this rarely adds real delay there. A timeout/exception is treated
  /// as definitively unavailable rather than retried, so a broken channel
  /// doesn't double the worst-case wait.
  Future<bool> _isAvailableWithRetry(String candidate) async {
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        if (await _tts.isLanguageAvailable(candidate).timeout(_detectTimeout)) {
          return true;
        }
      } catch (_) {
        return false;
      }
      if (attempt == 0 && _voiceRetryDelay > Duration.zero) await Future.delayed(_voiceRetryDelay);
    }
    return false;
  }

  Future<void> _loadManifest() async {
    try {
      final raw = await _bundle.loadString('assets/audio/manifest.json');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _wordAudio = Map<String, String>.from(map['words'] as Map? ?? const {});
      _feedbackAudio = (map['feedback'] as Map?)?.map(
            (k, v) => MapEntry(k as String, (v as String?) ?? ''),
          ) ??
          const {};
      _feedbackAudio.removeWhere((_, path) => path.isEmpty);
    } catch (_) {
      _wordAudio = {};
      _feedbackAudio = {};
    }
  }

  /// Whether there is any way at all to make Amharic audible right now -
  /// bundled word audio or a text-to-speech voice. Drives whether listening
  /// exercises are generated (Abschnitt 8: "Hörübungen werden automatisch
  /// übersprungen").
  bool get isAmharicAvailable {
    assert(_initialized, 'AudioService.init() must be awaited before use.');
    return _wordAudio.isNotEmpty || _ttsAmharicLanguage != null;
  }

  /// Speaks [amharicText] (Ge'ez script) for [id] - a lexeme or sentence id,
  /// used to look up a bundled recording first. Falls back to
  /// text-to-speech, then to silence.
  Future<void> speakText({required String id, required String amharicText}) async {
    if (!soundEnabled || !isAmharicAvailable || amharicText.isEmpty) return;

    final assetPath = _wordAudio[id];
    if (assetPath != null) {
      await _playAsset(assetPath);
      return;
    }

    final language = _ttsAmharicLanguage;
    if (language != null) {
      try {
        await _tts.setLanguage(language).timeout(_playTimeout);
        await _tts.setVolume(volume).timeout(_playTimeout);
        await _tts.speak(amharicText).timeout(_playTimeout);
      } catch (_) {
        // Silent skip - see class doc.
      }
    }
  }

  /// A short correct/incorrect chime, if one is bundled. Independent of
  /// Amharic availability - these are plain UI sounds.
  Future<void> playFeedback({required bool correct}) async {
    if (!soundEnabled) return;
    final assetPath = _feedbackAudio[correct ? 'correct' : 'incorrect'];
    if (assetPath == null) return;
    await _playAsset(assetPath);
  }

  Future<void> _playAsset(String assetPath) async {
    try {
      await _player.play(assetPath, volume: volume).timeout(_playTimeout);
    } catch (_) {
      // Declared in the manifest but missing/unplayable - silent skip.
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop().timeout(_playTimeout);
    } catch (_) {}
    try {
      await _player.stop().timeout(_playTimeout);
    } catch (_) {}
  }
}
