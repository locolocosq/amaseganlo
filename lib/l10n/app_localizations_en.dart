// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Amaseganlo';

  @override
  String get navLearn => 'Learn';

  @override
  String get navFidel => 'Fidel';

  @override
  String get navReview => 'Review';

  @override
  String get navProfile => 'Profile';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSave => 'Save';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String get commonDontKnow => 'I don\'t know';

  @override
  String get commonSkip => 'Skip';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'App language';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get appearanceSystem => 'System';

  @override
  String get settingsAccentColor => 'Accent color';

  @override
  String get settingsFontSize => 'Font size';

  @override
  String get fontSizeSmall => 'Small';

  @override
  String get fontSizeNormal => 'Normal';

  @override
  String get fontSizeLarge => 'Large';

  @override
  String get fontSizeExtraLarge => 'Extra large';

  @override
  String get settingsShowFidelInMainPath =>
      'Show Fidel script in the main path';

  @override
  String get fidelDisplayNever => 'Never';

  @override
  String get fidelDisplayBelow => 'Below the transliteration';

  @override
  String get fidelDisplayInstead => 'Instead of the transliteration';

  @override
  String get settingsSound => 'Sound';

  @override
  String get settingsVolume => 'Volume';

  @override
  String get settingsAutoPlayNewWords => 'Play new words automatically';

  @override
  String get settingsDailyGoal => 'Daily goal';

  @override
  String get dailyGoalRelaxed => 'Relaxed · 20 XP';

  @override
  String get dailyGoalNormal => 'Normal · 50 XP';

  @override
  String get dailyGoalAmbitious => 'Ambitious · 100 XP';

  @override
  String get settingsUseHearts => 'Use hearts';

  @override
  String get settingsDailyReminder => 'Daily reminder';

  @override
  String get settingsAllLessonsUnlocked => 'All lessons unlocked';

  @override
  String get settingsReduceMotion => 'Reduce motion';

  @override
  String get settingsBackupProgress => 'Back up progress';

  @override
  String get settingsRestoreProgress => 'Restore progress';

  @override
  String get settingsResetProgress => 'Reset progress';

  @override
  String get settingsAbout => 'About this app';

  @override
  String get settingsFidelLearningPath => 'Fidel learning path';

  @override
  String get fidelPathTraditional => 'Traditional – as in Ethiopia';

  @override
  String get fidelPathFast => 'Read fast';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get resetProgressTitle => 'Reset progress?';

  @override
  String get resetProgressWarning =>
      'This deletes all your learning progress permanently. This cannot be undone.';

  @override
  String get resetProgressTypeWord => 'Type \"delete\" to confirm.';

  @override
  String get resetProgressConfirmWord => 'delete';

  @override
  String get resetProgressDone => 'Your progress has been reset.';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutBuildDate => 'Build date';

  @override
  String get aboutPrivacy =>
      'All your data stays on this device. No account, no server, no ads, no tracking.';

  @override
  String get aboutLicenses => 'Open source licenses';

  @override
  String get aboutShortcuts => 'Keyboard shortcuts';

  @override
  String get aboutShortcutsAnswer => '1–4: choose an answer';

  @override
  String get aboutShortcutsNext => 'Enter: confirm / continue';

  @override
  String get aboutShortcutsCancel => 'Escape: cancel';

  @override
  String get aboutShortcutsAudio => 'Space: replay audio';

  @override
  String get onboardingWelcomeTitle => 'Selam! Welcome to Amaseganlo';

  @override
  String get onboardingWelcomeBody =>
      'Amaseganlo teaches you Amharic (አማርኛ), the official language of Ethiopia.';

  @override
  String get onboardingChooseLanguage => 'Choose your app language';

  @override
  String get onboardingTwoPathsTitle => 'Two learning paths';

  @override
  String get onboardingTwoPathsBody =>
      '\"Speak & understand\" teaches Amharic in Latin transliteration. \"Learn Fidel\" teaches the Ethiopic script. Both run side by side.';

  @override
  String get onboardingDailyGoalTitle => 'Choose your daily goal';

  @override
  String get onboardingAssessmentQuestion =>
      'Do you already know some Amharic?';

  @override
  String get onboardingAssessmentNone => 'I\'m starting from zero';

  @override
  String get onboardingAssessmentSome => 'A few words';

  @override
  String get onboardingAssessmentGood => 'I already know quite a bit';

  @override
  String get onboardingStart => 'Let\'s go';

  @override
  String get homeContinueLearning => 'Continue learning';

  @override
  String get homeDailyGoal => 'Daily goal';

  @override
  String get homeStreak => 'Streak';

  @override
  String homeReviewDue(int count) {
    return '$count due for review';
  }

  @override
  String get homeFreePractice => 'Free practice';

  @override
  String get homeNoReviewsDue =>
      'Nothing due right now. Practice your weak words instead?';

  @override
  String pathSectionProgress(int section, String title, int done, int total) {
    return 'Section $section: $title — $done of $total units';
  }

  @override
  String get pathLocked => 'Locked';

  @override
  String get pathSkipped => 'Skipped';

  @override
  String get pathCompleted => 'Completed';

  @override
  String get pathLockedDialogTitle => 'This unit builds on earlier ones';

  @override
  String get pathLockedDialogBody =>
      'You don\'t know all the words used here yet. Start anyway?';

  @override
  String get pathLockedDialogLater => 'Maybe later';

  @override
  String get pathLockedDialogStart => 'Start anyway';

  @override
  String get pathUnitTest => 'Unit test';

  @override
  String get pathUnitTestHint => 'Skip this unit by passing a test';

  @override
  String get unitOverviewLessons => 'Lessons';

  @override
  String get unitOverviewWordList => 'Word list';

  @override
  String unitOverviewCrowns(int crowns) {
    return '$crowns of 5 crowns';
  }

  @override
  String get lessonExitConfirmTitle => 'End this lesson?';

  @override
  String get lessonExitConfirmBody =>
      'Your progress in this lesson will be lost.';

  @override
  String get lessonCompleteTitle => 'Lesson complete!';

  @override
  String lessonCompleteXp(int xp) {
    return '$xp XP';
  }

  @override
  String lessonCompleteAccuracy(int percent) {
    return 'Accuracy: $percent%';
  }

  @override
  String lessonCompleteDuration(int minutes) {
    return 'Duration: $minutes min';
  }

  @override
  String lessonCompleteSkipped(int count) {
    return 'Skipped: $count';
  }

  @override
  String get lessonCompleteContinue => 'Continue';

  @override
  String get lessonCompleteRetry => 'Do it again';

  @override
  String get lessonOutOfHearts => 'Out of hearts';

  @override
  String get lessonOutOfHeartsBody =>
      'You\'ve used all your hearts for this lesson. Come back later or practice again.';

  @override
  String get feedbackCorrect => 'Correct!';

  @override
  String get feedbackIncorrect => 'Not quite';

  @override
  String feedbackAlmostCorrect(String correct) {
    return 'Almost! Watch the spelling: $correct';
  }

  @override
  String feedbackCorrectAnswerWas(String answer) {
    return 'Correct answer: $answer';
  }

  @override
  String get reviewTitle => 'Review';

  @override
  String get reviewDueToday => 'Due today';

  @override
  String get reviewDifficultWords => 'Difficult words';

  @override
  String get reviewFreePractice => 'Free practice';

  @override
  String get reviewEmpty =>
      'Nothing to review right now. Great job keeping up!';

  @override
  String get dictionaryTitle => 'Dictionary';

  @override
  String get dictionarySearchHint => 'Search words…';

  @override
  String get dictionaryFilterAll => 'All topics';

  @override
  String get dictionaryEmpty => 'No words learned yet in this topic.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileWordsLearned => 'Words learned';

  @override
  String get profileWordsMastered => 'Words mastered';

  @override
  String get profileFidelChars => 'Fidel signs learned';

  @override
  String get profileTotalXp => 'Total XP';

  @override
  String get profileLongestStreak => 'Longest streak';

  @override
  String get profileCurrentStreak => 'Current streak';

  @override
  String get profileDaysLearned => 'Days learned';

  @override
  String get profileAccuracy => 'Accuracy';

  @override
  String get profileLast7Days => 'Last 7 days';

  @override
  String get profileBadges => 'Badges';

  @override
  String get profileSkippedUnits => 'Skipped units';

  @override
  String get profileSkippedUnitsEmpty => 'You haven\'t skipped any units.';

  @override
  String get profileCatchUp => 'Catch up';

  @override
  String get profileAssessmentTest => 'Placement test';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericBody => 'Your progress is saved.';

  @override
  String get errorGoHome => 'Back to home';

  @override
  String get errorReload => 'Reload';

  @override
  String get errorContentUnit =>
      'This unit couldn\'t be loaded and was skipped.';

  @override
  String get errorCorruptSave =>
      'Your saved data couldn\'t be read. Starting fresh.';

  @override
  String get resumeLessonTitle => 'You were in the middle of a lesson';

  @override
  String get resumeLessonBody => 'Continue where you left off?';

  @override
  String get resumeLessonContinue => 'Continue';

  @override
  String get resumeLessonRestart => 'Start over';

  @override
  String get exitAppConfirm => 'Press back again to exit';

  @override
  String get exerciseCheckAnswer => 'Check';

  @override
  String get exerciseTypeAnswerHint => 'Type your answer…';

  @override
  String get exercisePairMatchingHint => 'Tap matching pairs';

  @override
  String get exerciseTrueFalseQuestion => 'Is this correct?';

  @override
  String get exerciseTrue => 'True';

  @override
  String get exerciseFalse => 'False';

  @override
  String get exerciseAudioUnavailable =>
      'Amharic audio isn\'t available on this device';

  @override
  String get introCardContinue => 'Continue';

  @override
  String get lessonKindIntro => 'New words';

  @override
  String get lessonKindWordPractice => 'Practice words';

  @override
  String get lessonKindSentenceBuilding => 'Build sentences';

  @override
  String get lessonKindListening => 'Listening';

  @override
  String get lessonKindFreeApplication => 'Free practice';

  @override
  String get lessonKindReview => 'Review';

  @override
  String get lessonKindUnitTest => 'Unit test';
}
