/// The Leitner-box state of one flashcard (a vocabulary word or a Fidel
/// sign). Box 0-5 correspond to Fach 1-6 in the spec.
class LeitnerCardProgress {
  final int box;
  final DateTime? lastReviewed;
  final int correctCount;
  final int incorrectCount;

  const LeitnerCardProgress({
    this.box = 0,
    this.lastReviewed,
    this.correctCount = 0,
    this.incorrectCount = 0,
  });

  LeitnerCardProgress copyWith({int? box, DateTime? lastReviewed, int? correctCount, int? incorrectCount}) {
    return LeitnerCardProgress(
      box: box ?? this.box,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
    );
  }

  factory LeitnerCardProgress.fromJson(Map<String, dynamic> json) {
    return LeitnerCardProgress(
      box: json['box'] as int? ?? 0,
      lastReviewed: json['lastReviewed'] != null ? DateTime.tryParse(json['lastReviewed'] as String) : null,
      correctCount: json['correctCount'] as int? ?? 0,
      incorrectCount: json['incorrectCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'box': box,
        'lastReviewed': lastReviewed?.toIso8601String(),
        'correctCount': correctCount,
        'incorrectCount': incorrectCount,
      };
}

class LessonProgress {
  final bool completed;
  final int stars;
  final double bestScore;
  final DateTime? lastPlayed;

  const LessonProgress({
    this.completed = false,
    this.stars = 0,
    this.bestScore = 0,
    this.lastPlayed,
  });

  LessonProgress copyWith({bool? completed, int? stars, double? bestScore, DateTime? lastPlayed}) {
    return LessonProgress(
      completed: completed ?? this.completed,
      stars: stars ?? this.stars,
      bestScore: bestScore ?? this.bestScore,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      completed: json['completed'] as bool? ?? false,
      stars: json['stars'] as int? ?? 0,
      bestScore: (json['bestScore'] as num?)?.toDouble() ?? 0,
      lastPlayed: json['lastPlayed'] != null ? DateTime.tryParse(json['lastPlayed'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'completed': completed,
        'stars': stars,
        'bestScore': bestScore,
        'lastPlayed': lastPlayed?.toIso8601String(),
      };
}

const int userProgressSchemaVersion = 1;

/// All of the learner's persisted progress: XP, streak, SRS card state for
/// every word and Fidel sign, per-lesson results, crowns, badges.
class UserProgress {
  final int schemaVersion;
  final int xpTotal;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastGoalMetDate;
  final Map<String, int> xpByDate; // 'yyyy-MM-dd' -> xp earned that day
  final Map<String, LeitnerCardProgress> lexemeCards;
  final Map<String, LeitnerCardProgress> fidelCards;
  final Map<String, LessonProgress> lessonProgress;
  final Map<String, int> unitCrowns; // 0-5
  final Set<String> badges;
  final Set<String> skippedUnitIds;

  const UserProgress({
    this.schemaVersion = userProgressSchemaVersion,
    this.xpTotal = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastGoalMetDate,
    this.xpByDate = const {},
    this.lexemeCards = const {},
    this.fidelCards = const {},
    this.lessonProgress = const {},
    this.unitCrowns = const {},
    this.badges = const {},
    this.skippedUnitIds = const {},
  });

  UserProgress copyWith({
    int? xpTotal,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastGoalMetDate,
    Map<String, int>? xpByDate,
    Map<String, LeitnerCardProgress>? lexemeCards,
    Map<String, LeitnerCardProgress>? fidelCards,
    Map<String, LessonProgress>? lessonProgress,
    Map<String, int>? unitCrowns,
    Set<String>? badges,
    Set<String>? skippedUnitIds,
  }) {
    return UserProgress(
      schemaVersion: userProgressSchemaVersion,
      xpTotal: xpTotal ?? this.xpTotal,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastGoalMetDate: lastGoalMetDate ?? this.lastGoalMetDate,
      xpByDate: xpByDate ?? this.xpByDate,
      lexemeCards: lexemeCards ?? this.lexemeCards,
      fidelCards: fidelCards ?? this.fidelCards,
      lessonProgress: lessonProgress ?? this.lessonProgress,
      unitCrowns: unitCrowns ?? this.unitCrowns,
      badges: badges ?? this.badges,
      skippedUnitIds: skippedUnitIds ?? this.skippedUnitIds,
    );
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      schemaVersion: userProgressSchemaVersion,
      xpTotal: json['xpTotal'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastGoalMetDate: json['lastGoalMetDate'] != null ? DateTime.tryParse(json['lastGoalMetDate'] as String) : null,
      xpByDate: Map<String, int>.from(json['xpByDate'] as Map? ?? const {}),
      lexemeCards: (json['lexemeCards'] as Map?)?.map(
            (k, v) => MapEntry(k as String, LeitnerCardProgress.fromJson(v as Map<String, dynamic>)),
          ) ??
          const {},
      fidelCards: (json['fidelCards'] as Map?)?.map(
            (k, v) => MapEntry(k as String, LeitnerCardProgress.fromJson(v as Map<String, dynamic>)),
          ) ??
          const {},
      lessonProgress: (json['lessonProgress'] as Map?)?.map(
            (k, v) => MapEntry(k as String, LessonProgress.fromJson(v as Map<String, dynamic>)),
          ) ??
          const {},
      unitCrowns: Map<String, int>.from(json['unitCrowns'] as Map? ?? const {}),
      badges: Set<String>.from(json['badges'] as List? ?? const []),
      skippedUnitIds: Set<String>.from(json['skippedUnitIds'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toJson() => {
        'schemaVersion': userProgressSchemaVersion,
        'xpTotal': xpTotal,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastGoalMetDate': lastGoalMetDate?.toIso8601String(),
        'xpByDate': xpByDate,
        'lexemeCards': lexemeCards.map((k, v) => MapEntry(k, v.toJson())),
        'fidelCards': fidelCards.map((k, v) => MapEntry(k, v.toJson())),
        'lessonProgress': lessonProgress.map((k, v) => MapEntry(k, v.toJson())),
        'unitCrowns': unitCrowns,
        'badges': badges.toList(),
        'skippedUnitIds': skippedUnitIds.toList(),
      };
}
