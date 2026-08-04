// Runs on the Dart VM only (test code), reading the ARB source files
// directly to make sure all four languages define exactly the same set of
// translatable keys. "@"-prefixed entries are ICU metadata that only the
// template file (app_en.arb) needs, per the standard Flutter l10n workflow.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all four ARB files define exactly the same translation keys', () {
    const locales = ['de', 'en', 'sv', 'nl'];
    final keysByLocale = <String, Set<String>>{};

    for (final locale in locales) {
      final raw = File('lib/l10n/app_$locale.arb').readAsStringSync();
      final map = jsonDecode(raw) as Map<String, dynamic>;
      keysByLocale[locale] = map.keys.where((k) => !k.startsWith('@')).toSet();
    }

    final reference = keysByLocale['en']!;
    for (final locale in locales) {
      final missing = reference.difference(keysByLocale[locale]!);
      final extra = keysByLocale[locale]!.difference(reference);
      expect(missing, isEmpty, reason: '$locale fehlen die Schlüssel: $missing');
      expect(extra, isEmpty, reason: '$locale hat zusätzliche Schlüssel, die in en fehlen: $extra');
    }
  });

  test('no translation value is empty', () {
    const locales = ['de', 'en', 'sv', 'nl'];
    for (final locale in locales) {
      final raw = File('lib/l10n/app_$locale.arb').readAsStringSync();
      final map = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in map.entries) {
        if (entry.key.startsWith('@')) continue;
        expect(
          (entry.value as String).trim(),
          isNotEmpty,
          reason: '$locale: "${entry.key}" ist leer',
        );
      }
    }
  });
}
