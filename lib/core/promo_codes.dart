import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Offline "Geschenk-Code"-Einlösung (Abschnitt Design/Etappe 13, auf
/// expliziten Wunsch statt reiner Store-Gutscheine): the app has no server
/// (Abschnitt 1 - fully offline), so a code can only ever be validated
/// against a secret baked into the app itself, never checked against a
/// remote "already used" list. That means the same code CAN be redeemed on
/// more than one device - there is no way to prevent that offline. This is
/// a deliberate, documented tradeoff (see ENTSCHEIDUNGEN.md), acceptable
/// for handing out a handful of gift codes, not a fraud-proof coupon
/// system. Redeeming a valid code grants the exact same permanent
/// "Premium" entitlement a real purchase would, rather than inventing a
/// separate time-limited entitlement just for this.
const String _promoSecret = 'Amaseganlo-Aethiopien-Reise-Geschenkcode-2026-Nicht-Teilen';

/// Base32-ish alphabet (exactly 32 characters, required for clean 5-bit
/// encoding) that avoids characters easily confused with each other when
/// handwritten/read aloud: no '1' (vs I/L) and no 'O'/'I'/'L' (vs 0/1) -
/// '0' stays in since nothing letter-like that could be confused with it
/// remains.
const String _alphabet = '023456789ABCDEFGHJKMNPQRSTUVWXYZ';
const int _serialLength = 6;
const int _signatureLength = 8;

String _normalize(String input) => input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

String _base32Encode(List<int> bytes) {
  final buffer = StringBuffer();
  var bitBuffer = 0;
  var bitCount = 0;
  for (final byte in bytes) {
    bitBuffer = (bitBuffer << 8) | byte;
    bitCount += 8;
    while (bitCount >= 5) {
      bitCount -= 5;
      buffer.write(_alphabet[(bitBuffer >> bitCount) & 0x1F]);
    }
  }
  if (bitCount > 0) {
    buffer.write(_alphabet[(bitBuffer << (5 - bitCount)) & 0x1F]);
  }
  return buffer.toString();
}

String _signatureFor(String serial) {
  final hmac = Hmac(sha256, utf8.encode(_promoSecret));
  final digest = hmac.convert(utf8.encode(serial));
  return _base32Encode(digest.bytes).substring(0, _signatureLength);
}

/// Formats a serial + its signature as a code in the shape users actually
/// type, e.g. `AB23CD-EFGH2345`.
String _format(String serial, String signature) => '$serial-$signature';

/// Builds a valid code for the given serial (any string - the tool that
/// generates codes for distribution normally passes a random one, see
/// tool/generate_promo_codes.dart). Exposed so both that tool and tests can
/// construct known-good codes without duplicating the signing logic.
String buildPromoCode(String serial) {
  final normalizedSerial = _normalize(serial).padRight(_serialLength, '2').substring(0, _serialLength);
  return _format(normalizedSerial, _signatureFor(normalizedSerial));
}

/// Generates one fresh, valid, randomly-serialed code - what
/// tool/generate_promo_codes.dart calls in a loop to print a batch.
String generateRandomPromoCode([Random? random]) {
  final rand = random ?? Random.secure();
  final serial = List.generate(_serialLength, (_) => _alphabet[rand.nextInt(_alphabet.length)]).join();
  return buildPromoCode(serial);
}

/// Whether [rawInput] (whatever the user typed - dashes/spaces/casing are
/// all tolerated) is a code this app would have generated.
bool isValidPromoCode(String rawInput) {
  final normalized = _normalize(rawInput);
  if (normalized.length != _serialLength + _signatureLength) return false;
  final serial = normalized.substring(0, _serialLength);
  final providedSignature = normalized.substring(_serialLength);
  return providedSignature == _signatureFor(serial);
}
