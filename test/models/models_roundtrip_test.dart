import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/models/fidel_char.dart';
import 'package:habesha_speak/models/lesson.dart';
import 'package:habesha_speak/models/lexeme.dart';
import 'package:habesha_speak/models/sentence.dart';
import 'package:habesha_speak/models/settings.dart';
import 'package:habesha_speak/models/user_progress.dart';

void main() {
  group('toJson/fromJson round trips', () {
    test('Lexeme', () {
      const lexeme = Lexeme(
        id: 'lex_water',
        am: 'ውሃ',
        tr: 'wuha',
        pos: 'noun',
        topic: 'food_drink',
        level: 'A1.1',
        t: {'de': 'das Wasser', 'en': 'water', 'sv': 'vatten', 'nl': 'water'},
        hint: {'de': 'Hinweis'},
        alt: {'de': ['Wasser']},
        emoji: '💧',
        verified: true,
      );
      final roundTripped = Lexeme.fromJson(lexeme.toJson());
      expect(roundTripped.id, lexeme.id);
      expect(roundTripped.am, lexeme.am);
      expect(roundTripped.tr, lexeme.tr);
      expect(roundTripped.t, lexeme.t);
      expect(roundTripped.alt, lexeme.alt);
      expect(roundTripped.verified, lexeme.verified);
    });

    test('Sentence', () {
      const sentence = Sentence(
        id: 'sen_x',
        am: 'ውሃ እጠጣለሁ',
        tr: "wuha it'et'alehu",
        level: 'A1.1',
        uses: ['lex_water'],
        t: {'de': 'Ich trinke Wasser.', 'en': 'I drink water.', 'sv': 'Jag dricker vatten.', 'nl': 'Ik drink water.'},
        chunks: ['wuha', "it'et'alehu"],
        verified: false,
      );
      final roundTripped = Sentence.fromJson(sentence.toJson());
      expect(roundTripped.id, sentence.id);
      expect(roundTripped.uses, sentence.uses);
      expect(roundTripped.chunks, sentence.chunks);
      expect(roundTripped.t, sentence.t);
    });

    test('FidelChar', () {
      const fidelChar = FidelChar(char: 'ለ', base: 'l', group: 'la', order: 1, tr: 'le', ipa: 'lə', regular: true);
      final roundTripped = FidelChar.fromJson(fidelChar.toJson());
      expect(roundTripped.char, fidelChar.char);
      expect(roundTripped.base, fidelChar.base);
      expect(roundTripped.group, fidelChar.group);
      expect(roundTripped.order, fidelChar.order);
      expect(roundTripped.regular, fidelChar.regular);
    });

    test('Lesson', () {
      final lesson = Lesson(
        id: 'lesson_x',
        unitId: 'unit_x',
        kind: LessonKind.wordPractice,
        lexemeIds: ['lex_water'],
        sentenceIds: [],
        exerciseTypes: [ExerciseType.wordChoiceAmToNative, ExerciseType.wordTyping],
      );
      final roundTripped = Lesson.fromJson(lesson.toJson(), unitId: 'unit_x');
      expect(roundTripped.id, lesson.id);
      expect(roundTripped.kind, lesson.kind);
      expect(roundTripped.exerciseTypes, lesson.exerciseTypes);
    });

    test('AppSettings', () {
      const settings = AppSettings(
        localeCode: 'de',
        themeMode: AppThemeMode.dark,
        fontSize: FontSizeOption.large,
        useHearts: true,
      );
      final roundTripped = AppSettings.fromJson(settings.toJson());
      expect(roundTripped.localeCode, settings.localeCode);
      expect(roundTripped.themeMode, settings.themeMode);
      expect(roundTripped.fontSize, settings.fontSize);
      expect(roundTripped.useHearts, settings.useHearts);
    });

    test('UserProgress', () {
      final progress = UserProgress(
        xpTotal: 120,
        currentStreak: 4,
        longestStreak: 10,
        lastGoalMetDate: DateTime(2026, 1, 1),
        xpByDate: const {'2026-01-01': 50},
        lexemeCards: const {'lex_water': LeitnerCardProgress(box: 2, correctCount: 3)},
        fidelCards: const {'fidel_le': LeitnerCardProgress(box: 1)},
        lessonProgress: const {'lesson_x': LessonProgress(completed: true, stars: 3)},
        unitCrowns: const {'unit_x': 5},
        badges: const {'first_lesson'},
        skippedUnitIds: const {'unit_y'},
      );
      final roundTripped = UserProgress.fromJson(progress.toJson());
      expect(roundTripped.xpTotal, progress.xpTotal);
      expect(roundTripped.currentStreak, progress.currentStreak);
      expect(roundTripped.lexemeCards['lex_water']?.box, 2);
      expect(roundTripped.lessonProgress['lesson_x']?.stars, 3);
      expect(roundTripped.unitCrowns['unit_x'], 5);
      expect(roundTripped.badges, {'first_lesson'});
      expect(roundTripped.skippedUnitIds, {'unit_y'});
    });
  });
}
