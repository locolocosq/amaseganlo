import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/dev_code.dart';

/// The dev-code hash (Etappe 29 Nachtrag) is a hand-implemented
/// PBKDF2-HMAC-SHA256 rather than a library call, specifically so it works
/// on Flutter Web without a native/FFI dependency. A hand-implemented crypto
/// primitive is exactly the kind of code that must be checked against an
/// independent reference, not just trusted because it "looks right" - this
/// test compares against Node's built-in `crypto.pbkdf2Sync` for the exact
/// same input, salt, and iteration count, computed independently outside
/// this codebase.
void main() {
  tearDown(() => debugSetDevCodeHashForTesting(null));

  test('PBKDF2-HMAC-SHA256 output matches an independently computed reference value', () {
    // node -e "console.log(require('crypto').pbkdf2Sync('abc',
    //   Buffer.from('habesha-speak-dev-code-v1','utf8'), 10000, 32,
    //   'sha256').toString('hex'))"
    const referenceHashForAbc = '8772d29b28c3d00f92b2008c9ad069e4b5330c0cf2667a53b9c4f95bc94395de';
    debugSetDevCodeHashForTesting(referenceHashForAbc);

    expect(isDevCode('abc'), isTrue);
    expect(isDevCode('ABC'), isTrue, reason: 'case-insensitive, same as the old plain-SHA256 behavior');
    expect(isDevCode(' abc '), isTrue, reason: 'whitespace-insensitive, same as the old plain-SHA256 behavior');
    expect(isDevCode('abcd'), isFalse);
    expect(isDevCode('ab'), isFalse);
  });

  test('a code that does not match the configured hash is rejected', () {
    debugSetDevCodeHashForTesting('0' * 64);
    expect(isDevCode('anything'), isFalse);
  });
}
