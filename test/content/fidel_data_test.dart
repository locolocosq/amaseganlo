import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/content/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ContentRepository repo;

  setUpAll(() async {
    repo = ContentRepository();
    await repo.load();
  });

  group('Fidel data (fidel.json)', () {
    test('has exactly 231 characters', () {
      expect(repo.allFidelChars.length, 231);
    });

    test('has exactly 33 distinct groups (rows)', () {
      expect(repo.fidelGroupsInOrder.length, 33);
    });

    test('every group has exactly 7 characters, one per order', () {
      for (final group in repo.fidelGroupsInOrder) {
        final chars = repo.fidelCharsForGroup(group);
        expect(chars.length, 7, reason: 'group $group should have 7 characters');
        expect(chars.map((c) => c.order).toSet(), {1, 2, 3, 4, 5, 6, 7});
      }
    });

    test('no duplicate glyphs across the whole table', () {
      final chars = repo.allFidelChars.map((c) => c.char).toList();
      expect(chars.toSet().length, chars.length);
    });

    test('every character has a valid order between 1 and 7', () {
      for (final c in repo.allFidelChars) {
        expect(c.order, inInclusiveRange(1, 7));
      }
    });

    test('the l-row transliterations match the spec example exactly', () {
      final la = repo.fidelCharsForGroup('la')..sort((a, b) => a.order.compareTo(b.order));
      expect(la.map((c) => c.tr).toList(), ['le', 'lu', 'li', 'la', 'le', 'l', 'lo']);
    });

    test('homophone groups share the same phonetic base', () {
      final ha = repo.fidelCharsForGroup('ha').first;
      final hha = repo.fidelCharsForGroup('hha').first;
      final hha2 = repo.fidelCharsForGroup('hha2').first;
      expect(ha.base, hha.base);
      expect(hha.base, hha2.base);

      final aa = repo.fidelCharsForGroup('aa').first;
      final aa2 = repo.fidelCharsForGroup('aa2').first;
      expect(aa.base, aa2.base);
    });
  });

  group('Fidel curriculum', () {
    test('Stufe 1 has 33 base characters spread across its lessons', () {
      final lessons = repo.fidelLessonsForStage('stufe1');
      final introduced = <String>{};
      for (final l in lessons) {
        if (l.kind.name == 'charIntro') introduced.addAll(l.groupIds);
      }
      expect(introduced.length, 33);
    });

    test('every homophone note only points to groups introduced in the same or an earlier lesson', () {
      final lessons = repo.fidelLessonsForStage('stufe1');
      final introducedSoFar = <String>{};
      for (final l in lessons) {
        // All signs in the current lesson are shown before its homophone
        // notes are read (Teil B, Stufe 1), so referencing a same-lesson
        // group is valid - only a *later* lesson's group would be wrong.
        introducedSoFar.addAll(l.groupIds);
        for (final entry in l.homophoneOf.entries) {
          for (final earlier in entry.value) {
            expect(introducedSoFar.contains(earlier), isTrue, reason: '${entry.key} claims to sound like $earlier, which is not yet introduced');
          }
        }
      }
    });
  });
}
