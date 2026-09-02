import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

/// Hidden developer/tester Premium unlock (Etappe 24), replacing the old
/// offline gift-code family (see git history / ENTSCHEIDUNGEN.md for that
/// design) with a small fixed set of codes, entered through a hidden gesture
/// (see about_screen.dart) instead of a visible field on the Premium
/// screen. Only these hashes - never the codes themselves - live in the
/// compiled app, so pulling the string table out of a release APK/AAB/web
/// build does not hand anyone a code directly.
///
/// Etappe 29 Nachtrag (hash upgrade): this used to be plain SHA-256, which
/// is honest-but-weak for a short, memorable code once the hash is public -
/// SHA-256 is deliberately *fast*, so a single consumer GPU can brute-force
/// the entire keyspace of an 8-9 character code in minutes to hours once it
/// can see the published hash (which it now can - the source is public on
/// GitHub). Switched to PBKDF2-HMAC-SHA256 with a high iteration count,
/// which is deliberately *slow* per guess (that's the whole point of a
/// password-hashing KDF vs. a general-purpose hash) - the same short code
/// stays exactly as easy to type and remember, but brute-forcing it now
/// costs orders of magnitude more. Implemented by hand against
/// `package:crypto`'s Hmac/sha256 (already a dependency) rather than adding
/// a new package, specifically because it needs to work identically on
/// Flutter Web too - most bcrypt/Argon2 Dart packages lean on native/FFI
/// code that doesn't compile to web, while this is pure Dart. Verified
/// against Node's built-in `crypto.pbkdf2Sync` for the exact same
/// input/salt/iteration count before being trusted (see
/// `test/core/dev_code_test.dart`), not just assumed correct.
const int _pbkdf2Iterations = 200000;

/// Doesn't need to be secret (a salt's job is to stop the same precomputed
/// table from working against many different services at once, not to add
/// secrecy of its own) - just fixed, so the same code always hashes the
/// same way.
final Uint8List _pbkdf2Salt = Uint8List.fromList(utf8.encode('habesha-speak-dev-code-v1'));

const Set<String> _devCodeHashesHex = {
  'ef17b399729cd2b5c540c14ebf7375a25eb3e8b824b21c77a6e0799800b1f6a5',
  '520a43168772b8e3ead5ac9107c6560bd75db0903fb79b6e9a1afda8696f9214',
};

String _normalize(String input) => input.trim().toLowerCase();

/// PBKDF2 (RFC 8018) with HMAC-SHA256 as the pseudorandom function,
/// producing a 32-byte key - a single SHA-256-sized block, so only the
/// single-block case needs implementing.
String _pbkdf2Hex(String password, {required Uint8List salt, required int iterations}) {
  final hmac = Hmac(sha256, utf8.encode(password));
  var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
  final t = Uint8List.fromList(u);
  for (var i = 1; i < iterations; i++) {
    u = hmac.convert(u).bytes;
    for (var k = 0; k < t.length; k++) {
      t[k] ^= u[k];
    }
  }
  return t.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

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
  final digest = _pbkdf2Hex(_normalize(rawInput), salt: _pbkdf2Salt, iterations: _pbkdf2Iterations);
  if (_testHashOverride != null) return digest == _testHashOverride;
  return _devCodeHashesHex.contains(digest);
}
