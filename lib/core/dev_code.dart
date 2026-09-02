import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

/// Hidden developer/tester Premium unlock (Etappe 24), replacing the old
/// offline gift-code family (see git history / ENTSCHEIDUNGEN.md for that
/// design) with exactly one fixed code, entered through a hidden gesture
/// (see about_screen.dart) instead of a visible field on the Premium
/// screen. Only this SHA-256 hash - never the code itself - lives in the
/// compiled app, so pulling the string table out of a release APK/AAB does
/// not hand anyone the code directly. This is still not real secrecy: the
/// code is short and memorable by design (the whole point is that it can be
/// typed from memory), so it stays crackable by a dictionary attack against
/// the hash - the same honest tradeoff the old promo-code system
/// documented, just for a single fixed code instead of a whole family.
const String _devCodeHashHex = '0ddb95ebc893977b06617d9ac9c089a9f8f08ba0cc2f80c56b9b03f1540f2a75';

String _normalize(String input) => input.trim().toLowerCase();

/// Lets tests exercise the redemption flow with a throwaway test code
/// instead of the real one - this file is public (the app's source is on
/// GitHub), so the real code must never appear in a test file either, only
/// its hash ever does, same as here. Unset (null) outside of tests.
String? _testHashOverride;

@visibleForTesting
void debugSetDevCodeHashForTesting(String? hashHex) {
  _testHashOverride = hashHex;
}

/// Whether [rawInput] is the one hidden developer code - case/whitespace
/// insensitive so it's easy to type correctly on a phone keyboard.
bool isDevCode(String rawInput) {
  final digest = sha256.convert(utf8.encode(_normalize(rawInput)));
  return digest.toString() == (_testHashOverride ?? _devCodeHashHex);
}
