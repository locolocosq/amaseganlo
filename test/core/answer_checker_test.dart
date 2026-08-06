import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/core/answer_checker.dart';

void main() {
  group('AnswerChecker.check - basic normalization', () {
    test('is case and whitespace insensitive', () {
      final result = AnswerChecker.check(input: '  SeLam  ', acceptedAnswers: ['selam']);
      expect(result.isCorrect, isTrue);
      expect(result.isAlmost, isFalse);
    });

    test('collapses multiple internal spaces', () {
      final result = AnswerChecker.check(input: 'dehna   negn', acceptedAnswers: ['dehna negn']);
      expect(result.isCorrect, isTrue);
    });

    test('ignores trailing punctuation', () {
      final result = AnswerChecker.check(input: 'selam!', acceptedAnswers: ['selam']);
      expect(result.isCorrect, isTrue);
    });

    test('rejects a clearly wrong answer', () {
      final result = AnswerChecker.check(input: 'wuha', acceptedAnswers: ['selam']);
      expect(result.isCorrect, isFalse);
      expect(result.isAlmost, isFalse);
    });

    test('empty input is never correct', () {
      final result = AnswerChecker.check(input: '   ', acceptedAnswers: ['selam']);
      expect(result.isCorrect, isFalse);
    });
  });

  group('AnswerChecker - Amharic transliteration tolerance', () {
    test('missing apostrophe is tolerated', () {
      final result = AnswerChecker.checkTransliteration('tiru', ["t'iru"]);
      expect(result.isCorrect, isTrue);
    });

    test('q / k-apostrophe variant is tolerated', () {
      final result = AnswerChecker.checkTransliteration('kali', ['qali']);
      expect(result.isCorrect, isTrue);
    });

    test('ts / s-apostrophe variant is tolerated', () {
      final result = AnswerChecker.checkTransliteration("s'af", ['tsaf']);
      expect(result.isCorrect, isTrue);
    });

    test('ph / f variant is tolerated', () {
      final result = AnswerChecker.checkTransliteration('fire', ['phire']);
      expect(result.isCorrect, isTrue);
    });
  });

  group('AnswerChecker - article tolerance', () {
    test('German article is optional', () {
      final result = AnswerChecker.checkTranslation('Wasser', ['das Wasser'], 'de');
      expect(result.isCorrect, isTrue);
    });

    test('Dutch article is optional', () {
      final result = AnswerChecker.checkTranslation('water', ['het water'], 'nl');
      expect(result.isCorrect, isTrue);
    });

    test('Swedish article is optional', () {
      final result = AnswerChecker.checkTranslation('vatten', ['ett vatten'], 'sv');
      expect(result.isCorrect, isTrue);
    });
  });

  group('AnswerChecker - alternate accepted answers', () {
    test('any accepted answer counts as correct', () {
      final result = AnswerChecker.check(input: 'okay', acceptedAnswers: ['fine', 'well', 'okay']);
      expect(result.isCorrect, isTrue);
    });
  });

  group('AnswerChecker - almost correct (Levenshtein)', () {
    test('a single-letter typo on a 5+ letter word counts as correct but flagged almost', () {
      final result = AnswerChecker.check(input: 'housr', acceptedAnswers: ['house']);
      expect(result.isCorrect, isTrue);
      expect(result.isAlmost, isTrue);
      expect(result.closestAccepted, 'house');
    });

    test('a single-letter typo on a word shorter than 5 letters is not tolerated', () {
      final result = AnswerChecker.check(input: 'wuxa', acceptedAnswers: ['wuha']);
      expect(result.isCorrect, isFalse);
    });

    test('two-letter difference is not tolerated even on long words', () {
      final result = AnswerChecker.check(input: 'hoxxe', acceptedAnswers: ['house']);
      expect(result.isCorrect, isFalse);
    });
  });

  group('AnswerChecker.levenshteinDistance', () {
    test('identical strings have distance 0', () {
      expect(AnswerChecker.levenshteinDistance('abc', 'abc'), 0);
    });

    test('one substitution has distance 1', () {
      expect(AnswerChecker.levenshteinDistance('abc', 'abd'), 1);
    });

    test('empty string distance equals the other string length', () {
      expect(AnswerChecker.levenshteinDistance('', 'abc'), 3);
      expect(AnswerChecker.levenshteinDistance('abc', ''), 3);
    });
  });
}
