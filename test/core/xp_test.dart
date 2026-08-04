import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/core/srs/xp.dart';

void main() {
  group('XpRules', () {
    test('a normal lesson gives base XP', () {
      expect(XpRules.forLesson(perfect: false), 10);
    });

    test('a perfect lesson gives a bonus', () {
      expect(XpRules.forLesson(perfect: true), 15);
    });

    test('a review session gives a flat bonus', () {
      expect(XpRules.forReviewSession(), 5);
    });

    test('a unit test gives base XP, more when perfect', () {
      expect(XpRules.forUnitTest(perfect: false), 10);
      expect(XpRules.forUnitTest(perfect: true), 15);
    });
  });
}
