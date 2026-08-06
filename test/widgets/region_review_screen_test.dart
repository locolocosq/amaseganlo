import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habesha_speak/core/audio_service.dart';
import 'package:habesha_speak/core/storage_service.dart';
import 'package:habesha_speak/l10n/app_localizations.dart';
import 'package:habesha_speak/screens/path/region_review_screen.dart';
import 'package:habesha_speak/state/content_provider.dart';
import 'package:habesha_speak/state/lesson_provider.dart';
import 'package:habesha_speak/state/progress_provider.dart';
import 'package:habesha_speak/state/settings_provider.dart';
import 'test_harness.dart';

/// Regression test for the cumulative "Freies Wiederholen" station
/// (Etappe 22): pumping [RegionReviewScreen] with more than one section id
/// must produce a real, non-empty exercise session drawn from productive
/// (typing/building) exercise types only - not the multiple-choice types
/// the due-words review screen uses.
void main() {
  testWidgets('a region review session starts with productive exercises from every given section', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();

    final contentProvider = ContentProvider();
    await contentProvider.load();

    final progressProvider = ProgressProvider(storage);
    final audioService = AudioService(
      tts: FakeTtsClient(),
      player: FakeAudioPlayerClient(),
      bundle: _EmptyAssetBundle(),
      voiceRetryDelay: Duration.zero,
    );
    await audioService.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider(storage)),
          ChangeNotifierProvider.value(value: contentProvider),
          ChangeNotifierProvider.value(value: progressProvider),
          Provider<AudioService>.value(value: audioService),
          ChangeNotifierProvider(
            create: (_) => LessonProvider(
              content: contentProvider.repository,
              progress: progressProvider,
              audioService: audioService,
            ),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const RegionReviewScreen(sectionIds: ['sec_a1_1', 'sec_a1_2']),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final lessonProvider = tester
        .element(find.byType(RegionReviewScreen))
        .read<LessonProvider>();
    expect(lessonProvider.session, isNotNull);
    expect(lessonProvider.session!.exercises, isNotEmpty);
    // Only the deliberately productive types (Etappe 22) - never a
    // multiple-choice/emoji-match/pair-matching type.
    const allowedTypes = {
      'wordTyping',
      'sentenceBuild',
      'sentenceGapTyping',
    };
    for (final exercise in lessonProvider.session!.exercises) {
      expect(allowedTypes.contains(exercise.type.name), isTrue, reason: 'unexpected exercise type ${exercise.type.name}');
    }
  });
}

class _EmptyAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw FlutterError('no assets in this fake bundle');
  }
}
