enum AppThemeMode { light, dark, system }

enum FontSizeOption { small, normal, large, extraLarge }

enum FidelDisplayMode { never, below, instead }

enum DailyGoal { relaxed, normal, ambitious }

enum FidelLearningPath { traditional, fast }

/// How fast bundled word audio and text-to-speech play back. Slower
/// settings help while a word's pronunciation is still new.
enum SpeechRate { slow, medium, normal }

extension SpeechRateMultiplier on SpeechRate {
  double get multiplier {
    switch (this) {
      case SpeechRate.slow:
        return 0.5;
      case SpeechRate.medium:
        return 0.75;
      case SpeechRate.normal:
        return 1.0;
    }
  }
}

extension DailyGoalXp on DailyGoal {
  int get xp {
    switch (this) {
      case DailyGoal.relaxed:
        return 20;
      case DailyGoal.normal:
        return 50;
      case DailyGoal.ambitious:
        return 100;
    }
  }
}

extension FontSizeScale on FontSizeOption {
  double get scale {
    switch (this) {
      case FontSizeOption.small:
        return 0.9;
      case FontSizeOption.normal:
        return 1.0;
      case FontSizeOption.large:
        return 1.15;
      case FontSizeOption.extraLarge:
        return 1.3;
    }
  }
}

const int settingsSchemaVersion = 1;

class AppSettings {
  final int schemaVersion;
  final String? localeCode;
  final AppThemeMode themeMode;
  final FontSizeOption fontSize;
  final FidelDisplayMode fidelDisplayMode;
  final bool soundEnabled;
  final double volume;
  final SpeechRate speechRate;
  final bool autoPlayNewWords;
  final DailyGoal dailyGoal;
  final bool useHearts;
  final bool dailyReminderEnabled;
  // Etappe 24: local time-of-day the daily reminder notification fires at
  // - defaults to a reasonable early-evening slot, not tied to any locale
  // (a plain 24h hour/minute pair, formatted for display wherever needed).
  final int reminderHour;
  final int reminderMinute;
  final bool allLessonsUnlocked;
  final FidelLearningPath fidelLearningPath;
  final bool onboardingCompleted;

  const AppSettings({
    this.schemaVersion = settingsSchemaVersion,
    this.localeCode,
    this.themeMode = AppThemeMode.system,
    this.fontSize = FontSizeOption.normal,
    this.fidelDisplayMode = FidelDisplayMode.never,
    this.soundEnabled = true,
    this.volume = 1.0,
    this.speechRate = SpeechRate.normal,
    this.autoPlayNewWords = true,
    this.dailyGoal = DailyGoal.normal,
    this.useHearts = false,
    this.dailyReminderEnabled = false,
    this.reminderHour = 19,
    this.reminderMinute = 0,
    this.allLessonsUnlocked = false,
    this.fidelLearningPath = FidelLearningPath.traditional,
    this.onboardingCompleted = false,
  });

  AppSettings copyWith({
    String? localeCode,
    AppThemeMode? themeMode,
    FontSizeOption? fontSize,
    FidelDisplayMode? fidelDisplayMode,
    bool? soundEnabled,
    double? volume,
    SpeechRate? speechRate,
    bool? autoPlayNewWords,
    DailyGoal? dailyGoal,
    bool? useHearts,
    bool? dailyReminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? allLessonsUnlocked,
    FidelLearningPath? fidelLearningPath,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      schemaVersion: settingsSchemaVersion,
      localeCode: localeCode ?? this.localeCode,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      fidelDisplayMode: fidelDisplayMode ?? this.fidelDisplayMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      volume: volume ?? this.volume,
      speechRate: speechRate ?? this.speechRate,
      autoPlayNewWords: autoPlayNewWords ?? this.autoPlayNewWords,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      useHearts: useHearts ?? this.useHearts,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      allLessonsUnlocked: allLessonsUnlocked ?? this.allLessonsUnlocked,
      fidelLearningPath: fidelLearningPath ?? this.fidelLearningPath,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      schemaVersion: settingsSchemaVersion,
      localeCode: json['localeCode'] as String?,
      themeMode: _enumFromName(AppThemeMode.values, json['themeMode'], AppThemeMode.system),
      fontSize: _enumFromName(FontSizeOption.values, json['fontSize'], FontSizeOption.normal),
      fidelDisplayMode: _enumFromName(FidelDisplayMode.values, json['fidelDisplayMode'], FidelDisplayMode.never),
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      volume: (json['volume'] as num?)?.toDouble() ?? 1.0,
      speechRate: _enumFromName(SpeechRate.values, json['speechRate'], SpeechRate.normal),
      autoPlayNewWords: json['autoPlayNewWords'] as bool? ?? true,
      dailyGoal: _enumFromName(DailyGoal.values, json['dailyGoal'], DailyGoal.normal),
      useHearts: json['useHearts'] as bool? ?? false,
      dailyReminderEnabled: json['dailyReminderEnabled'] as bool? ?? false,
      reminderHour: (json['reminderHour'] as num?)?.toInt() ?? 19,
      reminderMinute: (json['reminderMinute'] as num?)?.toInt() ?? 0,
      allLessonsUnlocked: json['allLessonsUnlocked'] as bool? ?? false,
      fidelLearningPath: _enumFromName(FidelLearningPath.values, json['fidelLearningPath'], FidelLearningPath.traditional),
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'schemaVersion': settingsSchemaVersion,
        'localeCode': localeCode,
        'themeMode': themeMode.name,
        'fontSize': fontSize.name,
        'fidelDisplayMode': fidelDisplayMode.name,
        'soundEnabled': soundEnabled,
        'volume': volume,
        'speechRate': speechRate.name,
        'autoPlayNewWords': autoPlayNewWords,
        'dailyGoal': dailyGoal.name,
        'useHearts': useHearts,
        'dailyReminderEnabled': dailyReminderEnabled,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
        'allLessonsUnlocked': allLessonsUnlocked,
        'fidelLearningPath': fidelLearningPath.name,
        'onboardingCompleted': onboardingCompleted,
      };

  static T _enumFromName<T extends Enum>(List<T> values, dynamic name, T fallback) {
    if (name is! String) return fallback;
    for (final v in values) {
      if (v.name == name) return v;
    }
    return fallback;
  }
}
