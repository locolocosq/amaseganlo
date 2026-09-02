import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

/// Hidden developer/tester Premium unlock (Etappe 24), replacing the old
/// offline gift-code family (see git history / ENTSCHEIDUNGEN.md for that
/// design) with a small fixed set of codes, entered through a hidden gesture
/// (see about_screen.dart) instead of a visible field on the Premium
/// screen. Only these SHA-256 hashes - never the codes themselves - live in
/// the compiled app, so pulling the string table out of a release APK/AAB
/// does not hand anyone a code directly. This is still not real secrecy:
/// the codes are short and memorable by design (the whole point is that
/// they can be typed from memory), so they stay crackable by a dictionary
/// attack against the hash - the same honest tradeoff the old promo-code
/// system documented, just for a couple of fixed codes instead of a whole
/// family. Both codes below already work on some already-built app/device
/// (Etappe 29 Nachtrag: the original code was briefly exposed in plaintext
/// in this now-public repo's history before being scrubbed, then restored
/// here hashed once that plaintext was actually removed from history too -
/// see ENTSCHEIDUNGEN.md), which is why there's more than one.
const Set<String> _devCodeHashesHex = {
  '0ddb95ebc893977b06617d9ac9c089a9f8f08ba0cc2f80c56b9b03f1540f2a75',
  '2bc88e31bc0b0a78e6a9f32744f2ba21e44beeddcfa4478ad5b6d20f0dfd906e',
};

String _normalize(String input) => input.trim().toLowerCase();

/// Lets tests exercise the redemption flow with a throwaway test code
/// instead of a real one - this file is public (the app's source is on
/// GitHub), so a real code must never appear in a test file either, only
/// its hash ever does, same as here. Unset (null) outside of tests.
String? _testHashOverride;

@visibleForTesting
void debugSetDevCodeHashForTesting(String? hashHex) {
  _testHashOverride = hashHex;
}

/// Whether [rawInput] is one of the hidden developer codes - case/whitespace
/// insensitive so it's easy to type correctly on a phone keyboard.
bool isDevCode(String rawInput) {
  final digest = sha256.convert(utf8.encode(_normalize(rawInput))).toString();
  if (_testHashOverride != null) return digest == _testHashOverride;
  return _devCodeHashesHex.contains(digest);
}
