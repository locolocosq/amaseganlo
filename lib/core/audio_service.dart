/// Every sound in the app goes through this single interface, per Abschnitt
/// 13. This is a stub for now: it reports Amharic audio as unavailable, so
/// nothing depends on a text-to-speech voice existing yet. Etappe 7 fills in
/// the real flutter_tts / asset-audio logic behind this exact interface -
/// nothing above this class needs to change when that happens.
class AudioService {
  bool _amharicChecked = false;
  bool _amharicAvailable = false;

  Future<void> init() async {
    // Real detection (flutter_tts getLanguages / getVoices) lands in Etappe 7.
    _amharicChecked = true;
    _amharicAvailable = false;
  }

  bool get isAmharicAvailable {
    assert(_amharicChecked, 'AudioService.init() must be awaited before use.');
    return _amharicAvailable;
  }

  Future<void> speakAmharic(String transliterationOrAssetRef) async {
    if (!isAmharicAvailable) return;
  }

  Future<void> playFeedback({required bool correct}) async {}

  Future<void> stop() async {}
}
