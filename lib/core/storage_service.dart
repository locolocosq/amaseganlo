import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';

/// Wraps all persistence for the app. This is the only place that talks to
/// SharedPreferences directly - nothing else should read or write storage.
///
/// Corrupted data must never crash the app: every read swallows decode
/// errors and falls back to defaults instead.
class StorageService {
  static const _settingsKey = 'amaseganlo.settings';

  SharedPreferences? _prefs;
  bool _lastLoadWasCorrupt = false;

  bool get lastLoadWasCorrupt => _lastLoadWasCorrupt;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('StorageService.init() must be awaited before use.');
    }
    return prefs;
  }

  AppSettings loadSettings() {
    final raw = _p.getString(_settingsKey);
    if (raw == null) return const AppSettings();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return AppSettings.fromJson(map);
    } catch (_) {
      _lastLoadWasCorrupt = true;
      return const AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _p.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  /// Generic string read/write for other providers (progress, lesson state, …)
  /// added in later stages. Kept generic here so this class stays the single
  /// point of contact with SharedPreferences.
  String? readString(String key) => _p.getString(key);

  Future<void> writeString(String key, String value) => _p.setString(key, value);

  Future<void> remove(String key) => _p.remove(key);

  Future<void> clearAll() => _p.clear();
}
