enum AppThemeMode { light, dark, system }

enum FontSizeOption { small, normal, large, extraLarge }

enum FidelDisplayMode { never, below, instead }

enum DailyGoal { relaxed, normal, ambitious }

enum FidelLearningPath { traditional, fast }

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
  final int accentColorIndex;
  final FontSizeOption fontSize;
  final FidelDisplayMode fidelDisplayMode;
  final bool soundEnabled;
  final double volume;
  final bool autoPlayNewWords;
  final DailyGoal dailyGoal;
  final bool useHearts;
  final bool dailyReminderEnabled;
  final bool allLessonsUnlocked;
  final bool reduceMotion;
  final FidelLearningPath fidelLearningPath;
  final bool onboardingCompleted;

  const AppSettings({
    this.schemaVersion = settingsSchemaVersion,
    this.localeCode,
    this.themeMode = AppThemeMode.system,
    this.accentColorIndex = 0,
    this.fontSize = FontSizeOption.normal,
    this.fidelDisplayMode = FidelDisplayMode.never,
    this.soundEnabled = true,
    this.volume = 1.0,
    this.autoPlayNewWords = true,
    this.dailyGoal = DailyGoal.normal,
    this.useHearts = false,
    this.dailyReminderEnabled = false,
    this.allLessonsUnlocked = false,
    this.reduceMotion = false,
    this.fidelLearningPath = FidelLearningPath.traditional,
    this.onboardingCompleted = false,
  });

  AppSettings copyWith({
    String? localeCode,
    AppThemeMode? themeMode,
    int? accentColorIndex,
    FontSizeOption? fontSize,
    FidelDisplayMode? fidelDisplayMode,
    bool? soundEnabled,
    double? volume,
    bool? autoPlayNewWords,
    DailyGoal? dailyGoal,
    bool? useHearts,
    bool? dailyReminderEnabled,
    bool? allLessonsUnlocked,
    bool? reduceMotion,
    FidelLearningPath? fidelLearningPath,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      schemaVersion: settingsSchemaVersion,
      localeCode: localeCode ?? this.localeCode,
      themeMode: themeMode ?? this.themeMode,
      accentColorIndex: accentColorIndex ?? this.accentColorIndex,
      fontSize: fontSize ?? this.fontSize,
      fidelDisplayMode: fidelDisplayMode ?? this.fidelDisplayMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      volume: volume ?? this.volume,
      autoPlayNewWords: autoPlayNewWords ?? this.autoPlayNewWords,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      useHearts: useHearts ?? this.useHearts,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      allLessonsUnlocked: allLessonsUnlocked ?? this.allLessonsUnlocked,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      fidelLearningPath: fidelLearningPath ?? this.fidelLearningPath,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      schemaVersion: settingsSchemaVersion,
      localeCode: json['localeCode'] as String?,
      themeMode: _enumFromName(AppThemeMode.values, json['themeMode'], AppThemeMode.system),
      accentColorIndex: (json['accentColorIndex'] as num?)?.toInt() ?? 0,
      fontSize: _enumFromName(FontSizeOption.values, json['fontSize'], FontSizeOption.normal),
      fidelDisplayMode: _enumFromName(FidelDisplayMode.values, json['fidelDisplayMode'], FidelDisplayMode.never),
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      volume: (json['volume'] as num?)?.toDouble() ?? 1.0,
      autoPlayNewWords: json['autoPlayNewWords'] as bool? ?? true,
      dailyGoal: _enumFromName(DailyGoal.values, json['dailyGoal'], DailyGoal.normal),
      useHearts: json['useHearts'] as bool? ?? false,
      dailyReminderEnabled: json['dailyReminderEnabled'] as bool? ?? false,
      allLessonsUnlocked: json['allLessonsUnlocked'] as bool? ?? false,
      reduceMotion: json['reduceMotion'] as bool? ?? false,
      fidelLearningPath: _enumFromName(FidelLearningPath.values, json['fidelLearningPath'], FidelLearningPath.traditional),
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'schemaVersion': settingsSchemaVersion,
        'localeCode': localeCode,
        'themeMode': themeMode.name,
        'accentColorIndex': accentColorIndex,
        'fontSize': fontSize.name,
        'fidelDisplayMode': fidelDisplayMode.name,
        'soundEnabled': soundEnabled,
        'volume': volume,
        'autoPlayNewWords': autoPlayNewWords,
        'dailyGoal': dailyGoal.name,
        'useHearts': useHearts,
        'dailyReminderEnabled': dailyReminderEnabled,
        'allLessonsUnlocked': allLessonsUnlocked,
        'reduceMotion': reduceMotion,
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
