import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habesha_speak/core/storage_service.dart';
import 'package:habesha_speak/models/settings.dart';

void main() {
  group('StorageService', () {
    test('returns default settings when nothing has been saved yet', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = StorageService();
      await storage.init();

      final settings = storage.loadSettings();
      expect(settings.themeMode, AppThemeMode.system);
      expect(storage.lastLoadWasCorrupt, isFalse);
    });

    test('saving and loading settings round-trips correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = StorageService();
      await storage.init();

      const settings = AppSettings(localeCode: 'de', themeMode: AppThemeMode.dark, accentColorIndex: 2);
      await storage.saveSettings(settings);

      final loaded = storage.loadSettings();
      expect(loaded.localeCode, 'de');
      expect(loaded.themeMode, AppThemeMode.dark);
      expect(loaded.accentColorIndex, 2);
    });

    test('corrupted settings JSON falls back to defaults instead of crashing', () async {
      SharedPreferences.setMockInitialValues({'amaseganlo.settings': '{ this is not valid json'});
      final storage = StorageService();
      await storage.init();

      final settings = storage.loadSettings();
      expect(settings.themeMode, AppThemeMode.system);
      expect(storage.lastLoadWasCorrupt, isTrue);
    });

    test('generic string read/write works for other providers', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = StorageService();
      await storage.init();

      expect(storage.readString('some.key'), isNull);
      await storage.writeString('some.key', 'hello');
      expect(storage.readString('some.key'), 'hello');
    });
  });
}
