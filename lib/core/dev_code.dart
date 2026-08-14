import 'dart:convert';

import 'package:crypto/crypto.dart';

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
const String _devCodeHashHex = '2bc88e31bc0b0a78e6a9f32744f2ba21e44beeddcfa4478ad5b6d20f0dfd906e';

String _normalize(String input) => input.trim().toLowerCase();

/// Whether [rawInput] is the one hidden developer code - case/whitespace
/// insensitive so it's easy to type correctly on a phone keyboard.
bool isDevCode(String rawInput) {
  final digest = sha256.convert(utf8.encode(_normalize(rawInput)));
  return digest.toString() == _devCodeHashHex;
}
