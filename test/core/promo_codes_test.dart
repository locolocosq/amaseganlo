import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/core/promo_codes.dart';

void main() {
  test('a freshly generated code validates successfully', () {
    final code = generateRandomPromoCode(Random(1));
    expect(isValidPromoCode(code), isTrue);
  });

  test('validation tolerates lowercase, extra spaces and missing dashes', () {
    final code = generateRandomPromoCode(Random(2));
    final messy = ' ${code.toLowerCase().replaceAll('-', ' ')} ';
    expect(isValidPromoCode(messy), isTrue);
  });

  test('a code with one changed character is rejected', () {
    final code = generateRandomPromoCode(Random(3));
    final tampered = '${code.substring(0, code.length - 1)}${code.endsWith('9') ? '8' : '9'}';
    expect(isValidPromoCode(tampered), isFalse);
  });

  test('a completely made-up string is rejected', () {
    expect(isValidPromoCode('NOTAREALCODE12345'), isFalse);
  });

  test('an empty string is rejected', () {
    expect(isValidPromoCode(''), isFalse);
  });

  test('generated codes are not all identical (serials really vary)', () {
    final codes = {for (var i = 0; i < 20; i++) generateRandomPromoCode()};
    expect(codes.length, 20);
  });
}
