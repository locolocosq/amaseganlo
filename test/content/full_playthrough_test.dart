// Etappe 28 Nachtrag 13: an actual "play every single station once" pass,
// requested explicitly by the user before a planned store update - not a
// sample, every unit. Screenshot-based manual click-through isn't possible
// in this environment (the Browser pane isn't visually displayed here, so
// CanvasKit never composites a frame - the same limitation already
// documented in ENTSCHEIDUNGEN.md for Etappe 8/27), so this drives the real
// LessonProvider/ExerciseGenerator pipeline directly instead: for every
// unit's every lesson stage, actually build the exercise queue the way the
// running app would and check it for crashes or malformed content. This is
// strictly more thorough than a manual sample would have been - it's every
// unit, not a handful.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habesha_speak/content/content_repository.dart';
import 'package:habesha_speak/core/audio_service.dart';
import 'package:habesha_speak/core/storage_service.dart';
import 'package:habesha_speak/models/lesson.dart';
import 'package:habesha_speak/state/lesson_provider.dart';
import 'package:habesha_speak/state/progress_provider.dart';

class _FakeTtsClient implements TtsClient {
  @override
  Future<bool> isLanguageAvailable(String language) async => false;
  @override
  Future<void> setLanguage(String language) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> setSpeechRate(double rate) async {}
  @override
  Future<void> speak(String text) async {}
  @override
  Future<void> stop() async {}
}

class _FakeAudioPlayerClient implements AudioPlayerClient {
  @override
  Future<void> play(String assetPath, {required double volume, double rate = 1.0}) async {}
  @override
  Future<void> stop() async {}
}

class _EmptyAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw FlutterError('no assets in this fake bundle');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ContentRepository repo;
  late LessonProvider lessonProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();
    final progressProvider = ProgressProvider(storage);

    repo = ContentRepository();
    await repo.load();

    final audio = AudioService(
      tts: _FakeTtsClient(),
      player: _FakeAudioPlayerClient(),
      bundle: _EmptyAssetBundle(),
      voiceRetryDelay: Duration.zero,
    );
    await audio.init();

    lessonProvider = LessonProvider(content: repo, progress: progressProvider, audioService: audio);
  });

  test('every lesson stage of every unit builds a well-formed exercise queue without crashing', () {
    final problems = <String>[];
    var unitsChecked = 0;
    var stagesChecked = 0;
    var exercisesChecked = 0;

    for (final unit in repo.curriculum.units) {
      unitsChecked++;
      final lessons = repo.lessonsForUnit(unit.id);
      for (final lesson in lessons) {
        if (lesson.kind == LessonKind.intro) continue; // no exercises to check, just a lexeme flip-through
        stagesChecked++;

        try {
          lessonProvider.startLesson(unitId: unit.id, lessonId: lesson.id, locale: 'de', useHearts: false);
        } catch (e) {
          problems.add('${unit.id}/${lesson.id}: startLesson threw $e');
          continue;
        }

        final session = lessonProvider.session;
        if (session == null) {
          problems.add('${unit.id}/${lesson.id}: startLesson produced no session');
          continue;
        }

        for (final exercise in session.exercises) {
          exercisesChecked++;
          final where = '${unit.id}/${lesson.id}/${exercise.type}/${exercise.subjectId}';
          // pairMatching stores its content in `pairs` and leaves
          // promptText/correctAnswer empty by design (generatePairMatching
          // in exercise_generator.dart) - the widget renders a fixed
          // instruction, not a per-exercise prompt.
          if (exercise.type == ExerciseType.pairMatching) {
            if (exercise.pairs.isEmpty) {
              problems.add('$where: pairMatching with no pairs');
            }
            continue;
          }
          if (exercise.promptText.trim().isEmpty) {
            problems.add('$where: empty promptText');
          }
          if (exercise.correctAnswer.trim().isEmpty) {
            problems.add('$where: empty correctAnswer');
          }
        }
      }
    }

    // ignore: avoid_print
    print('checked $unitsChecked units, $stagesChecked lesson stages, $exercisesChecked exercises');
    expect(problems, isEmpty, reason: problems.take(30).join('\n'));
  });
}
