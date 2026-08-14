import 'package:flutter/foundation.dart';

import '../core/storage_service.dart';
import '../models/settings.dart';

/// Supported UI languages, in the order they should appear in pickers.
const List<String> supportedLocaleCodes = ['de', 'en', 'sv', 'nl'];

class SettingsProvider extends ChangeNotifier {
  final StorageService _storage;
  AppSettings _settings;
  bool corruptedOnLoad;

  SettingsProvider(this._storage)
      : _settings = _storage.loadSettings(),
        corruptedOnLoad = _storage.lastLoadWasCorrupt;

  AppSettings get settings => _settings;

  Future<void> _update(AppSettings Function(AppSettings) updater) async {
    _settings = updater(_settings);
    notifyListeners();
    await _storage.saveSettings(_settings);
  }

  Future<void> setLocaleCode(String? code) => _update((s) => s.copyWith(localeCode: code));
  Future<void> setThemeMode(AppThemeMode mode) => _update((s) => s.copyWith(themeMode: mode));
  Future<void> setFontSize(FontSizeOption size) => _update((s) => s.copyWith(fontSize: size));
  Future<void> setFidelDisplayMode(FidelDisplayMode mode) => _update((s) => s.copyWith(fidelDisplayMode: mode));
  Future<void> setSoundEnabled(bool enabled) => _update((s) => s.copyWith(soundEnabled: enabled));
  Future<void> setVolume(double volume) => _update((s) => s.copyWith(volume: volume));
  Future<void> setSpeechRate(SpeechRate rate) => _update((s) => s.copyWith(speechRate: rate));
  Future<void> setAutoPlayNewWords(bool enabled) => _update((s) => s.copyWith(autoPlayNewWords: enabled));
  Future<void> setDailyGoal(DailyGoal goal) => _update((s) => s.copyWith(dailyGoal: goal));
  Future<void> setUseHearts(bool enabled) => _update((s) => s.copyWith(useHearts: enabled));
  Future<void> setDailyReminderEnabled(bool enabled) => _update((s) => s.copyWith(dailyReminderEnabled: enabled));
  Future<void> setReminderTime(int hour, int minute) => _update((s) => s.copyWith(reminderHour: hour, reminderMinute: minute));
  Future<void> setAllLessonsUnlocked(bool enabled) => _update((s) => s.copyWith(allLessonsUnlocked: enabled));
  Future<void> setFidelLearningPath(FidelLearningPath path) => _update((s) => s.copyWith(fidelLearningPath: path));
  Future<void> setOnboardingCompleted(bool done) => _update((s) => s.copyWith(onboardingCompleted: done));
}
