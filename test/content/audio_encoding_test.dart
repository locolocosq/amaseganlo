// Guards against a real, previously-shipped bug: every file under
// assets/audio/words/ was encoded as MPEG-2 Layer III at 16000 Hz (a
// low-bitrate profile `ffmpeg` picks automatically below 32000 Hz). That
// profile plays back unreliably - failing outright on some browsers
// (AudioPlayers "Format error") and on some real Android devices, even
// though it's byte-for-byte a valid, undamaged mp3. Any future batch of
// generated audio (e.g. from another Colab run) must be re-encoded to a
// standard MPEG-1 Layer III profile (sample rate >= 32000 Hz) before being
// committed - this test fails loudly if that step is ever skipped, instead
// of the bug only surfacing much later on a real device. See
// ENTSCHEIDUNGEN.md for the full investigation.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _wordsDir = 'assets/audio/words';

int _id3TagSize(List<int> bytes) {
  if (bytes.length < 10 || bytes[0] != 0x49 || bytes[1] != 0x44 || bytes[2] != 0x33) return 0;
  final size = (bytes[6] << 21) | (bytes[7] << 14) | (bytes[8] << 7) | bytes[9];
  return 10 + size;
}

/// The MPEG version ID from the first frame header (2=MPEG2, 3=MPEG1),
/// or null if no valid frame sync is found.
int? _firstFrameVersionId(List<int> bytes, int start) {
  for (var i = start; i < bytes.length - 4; i++) {
    if (bytes[i] != 0xFF) continue;
    final b2 = bytes[i + 1];
    if ((b2 & 0xE0) != 0xE0) continue; // 11-bit frame sync
    final layer = (b2 >> 1) & 0x3;
    if (layer == 0) continue; // reserved layer - not a real frame sync
    return (b2 >> 3) & 0x3;
  }
  return null;
}

void main() {
  test('every bundled word mp3 is encoded as MPEG-1 (not MPEG-2/2.5) Layer III', () {
    final files = Directory(_wordsDir).listSync().whereType<File>().where((f) => f.path.endsWith('.mp3')).toList();

    expect(files, isNotEmpty, reason: 'no mp3 files found under $_wordsDir');

    final notMpeg1 = <String>[];
    for (final file in files) {
      final bytes = file.readAsBytesSync();
      final versionId = _firstFrameVersionId(bytes, _id3TagSize(bytes));
      if (versionId != 3) {
        notMpeg1.add('${file.path}: versionId=$versionId (expected 3 = MPEG-1)');
      }
    }

    expect(
      notMpeg1,
      isEmpty,
      reason: 'These files are not MPEG-1 Layer III and must be re-encoded '
          '(sample rate >= 32000 Hz) before shipping:\n${notMpeg1.join('\n')}',
    );
  });
}
