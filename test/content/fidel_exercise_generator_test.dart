import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/content/content_repository.dart';
import 'package:habesha_speak/content/exercise_generator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ContentRepository repo;
  late FidelExerciseGenerator generator;

  setUpAll(() async {
    repo = ContentRepository();
    await repo.load();
    generator = FidelExerciseGenerator(repo);
  });

  group('FidelExerciseGenerator.generateCharToSound', () {
    test('always produces exactly 4 options including the correct one exactly once', () {
      final subject = repo.fidelCharsForGroup('la').first;
      for (var i = 0; i < 20; i++) {
        final exercise = generator.generateCharToSound(subject);
        expect(exercise.options.length, 4);
        expect(exercise.options.toSet().length, 4);
        expect(exercise.options.where((o) => o == exercise.correctAnswer).length, 1);
      }
    });
  });

  group('FidelExerciseGenerator.generateSoundToChar', () {
    test('never includes a homophone of the correct sign among the options', () {
      // hha (ሐ) sounds exactly like ha (ሀ) and hha2 (ኀ) - none of those may
      // appear together as choices, or the question would be unanswerable.
      final subject = repo.fidelCharsForGroup('hha').first;
      final homophoneChars = {
        ...repo.fidelCharsForGroup('ha').map((c) => c.char),
        ...repo.fidelCharsForGroup('hha2').map((c) => c.char),
      };

      for (var i = 0; i < 20; i++) {
        final exercise = generator.generateSoundToChar(subject);
        final wrongOptions = exercise.options.where((o) => o != exercise.correctAnswer);
        for (final option in wrongOptions) {
          expect(homophoneChars.contains(option), isFalse, reason: '$option sounds identical to ${subject.char}');
        }
      }
    });

    test('always exactly 4 distinct options with the correct sign present once', () {
      final subject = repo.fidelCharsForGroup('ma').first;
      final exercise = generator.generateSoundToChar(subject);
      expect(exercise.options.length, 4);
      expect(exercise.options.toSet().length, 4);
      expect(exercise.options.where((o) => o == subject.char).length, 1);
    });
  });

  group('FidelExerciseGenerator.generateOrderRecognition', () {
    test('all distractors come from the very same row', () {
      final rowChars = repo.fidelCharsForGroup('la').map((c) => c.char).toSet();
      final exercise = generator.generateOrderRecognition('la', 2);
      expect(exercise.correctAnswer, repo.fidelCharsForGroup('la').firstWhere((c) => c.order == 2).char);
      for (final option in exercise.options) {
        expect(rowChars.contains(option), isTrue);
      }
      expect(exercise.options.length, 4);
    });
  });
}
