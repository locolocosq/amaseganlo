import 'package:flutter_test/flutter_test.dart';

import 'package:habesha_speak/content/content_repository.dart';
import 'package:habesha_speak/core/journey_progress.dart';
import 'package:habesha_speak/models/settings.dart';
import 'package:habesha_speak/models/user_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JourneyProgress', () {
    test('exactly the first 3 Eritrea (Tigrinya) units are free, the rest need Premium', () async {
      final repo = ContentRepository();
      await repo.load();
      final journey = JourneyProgress(
        content: repo,
        progress: const UserProgress(),
        settings: const AppSettings(),
        isPremium: false,
      );

      final eritreaSection = repo.curriculum.sections.firstWhere((s) => s.region == 'eritrea');
      final unitIds = eritreaSection.unitIds;
      expect(unitIds.length, greaterThan(freeTrialUnitCount), reason: 'this test only means something if there is at least one locked unit past the free ones');

      for (final id in unitIds.take(freeTrialUnitCount)) {
        expect(journey.isUnitPremiumLocked(id), isFalse, reason: '$id should be one of the free trial units');
      }
      for (final id in unitIds.skip(freeTrialUnitCount)) {
        expect(journey.isUnitPremiumLocked(id), isTrue, reason: '$id should require Premium');
      }
    });

    test('sectionsForLanguage/currentRegionIndexForLanguage keep the two map pages independent', () async {
      final repo = ContentRepository();
      await repo.load();
      final journey = JourneyProgress(
        content: repo,
        progress: const UserProgress(),
        settings: const AppSettings(),
        isPremium: true,
      );

      final amharicSections = journey.sectionsForLanguage('am');
      final tigrinyaSections = journey.sectionsForLanguage('ti');
      expect(amharicSections, isNotEmpty);
      expect(amharicSections.every((s) => s.language == 'am'), isTrue);
      expect(tigrinyaSections.length, 1);
      expect(tigrinyaSections.single.region, 'eritrea');

      // Nothing played yet on either track: both maps should show their own
      // first section as current (index 0), independent of each other.
      expect(journey.currentRegionIndexForLanguage('am'), 0);
      expect(journey.currentRegionIndexForLanguage('ti'), 0);
    });
  });
}
