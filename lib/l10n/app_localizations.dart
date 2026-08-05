import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('nl'),
    Locale('sv'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Amaseganlo'**
  String get appTitle;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navFidel.
  ///
  /// In en, this message translates to:
  /// **'Fidel'**
  String get navFidel;

  /// No description provided for @navReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get navReview;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// No description provided for @commonDontKnow.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know'**
  String get commonDontKnow;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguage;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @appearanceLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLight;

  /// No description provided for @appearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDark;

  /// No description provided for @appearanceSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appearanceSystem;

  /// No description provided for @settingsAccentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get settingsAccentColor;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get settingsFontSize;

  /// No description provided for @fontSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSizeSmall;

  /// No description provided for @fontSizeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get fontSizeNormal;

  /// No description provided for @fontSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontSizeLarge;

  /// No description provided for @fontSizeExtraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra large'**
  String get fontSizeExtraLarge;

  /// No description provided for @settingsShowFidelInMainPath.
  ///
  /// In en, this message translates to:
  /// **'Show Fidel script in the main path'**
  String get settingsShowFidelInMainPath;

  /// No description provided for @fidelDisplayNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get fidelDisplayNever;

  /// No description provided for @fidelDisplayBelow.
  ///
  /// In en, this message translates to:
  /// **'Below the transliteration'**
  String get fidelDisplayBelow;

  /// No description provided for @fidelDisplayInstead.
  ///
  /// In en, this message translates to:
  /// **'Instead of the transliteration'**
  String get fidelDisplayInstead;

  /// No description provided for @settingsSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get settingsSound;

  /// No description provided for @settingsVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get settingsVolume;

  /// No description provided for @settingsAutoPlayNewWords.
  ///
  /// In en, this message translates to:
  /// **'Play new words automatically'**
  String get settingsAutoPlayNewWords;

  /// No description provided for @settingsDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get settingsDailyGoal;

  /// No description provided for @dailyGoalRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed · 20 XP'**
  String get dailyGoalRelaxed;

  /// No description provided for @dailyGoalNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal · 50 XP'**
  String get dailyGoalNormal;

  /// No description provided for @dailyGoalAmbitious.
  ///
  /// In en, this message translates to:
  /// **'Ambitious · 100 XP'**
  String get dailyGoalAmbitious;

  /// No description provided for @settingsUseHearts.
  ///
  /// In en, this message translates to:
  /// **'Use hearts'**
  String get settingsUseHearts;

  /// No description provided for @settingsDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get settingsDailyReminder;

  /// No description provided for @settingsAllLessonsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'All lessons unlocked'**
  String get settingsAllLessonsUnlocked;

  /// No description provided for @settingsReduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get settingsReduceMotion;

  /// No description provided for @settingsBackupProgress.
  ///
  /// In en, this message translates to:
  /// **'Back up progress'**
  String get settingsBackupProgress;

  /// No description provided for @settingsRestoreProgress.
  ///
  /// In en, this message translates to:
  /// **'Restore progress'**
  String get settingsRestoreProgress;

  /// No description provided for @settingsResetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset progress'**
  String get settingsResetProgress;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get settingsAbout;

  /// No description provided for @settingsFidelLearningPath.
  ///
  /// In en, this message translates to:
  /// **'Fidel learning path'**
  String get settingsFidelLearningPath;

  /// No description provided for @fidelPathTraditional.
  ///
  /// In en, this message translates to:
  /// **'Traditional – as in Ethiopia'**
  String get fidelPathTraditional;

  /// No description provided for @fidelPathFast.
  ///
  /// In en, this message translates to:
  /// **'Read fast'**
  String get fidelPathFast;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @resetProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset progress?'**
  String get resetProgressTitle;

  /// No description provided for @resetProgressWarning.
  ///
  /// In en, this message translates to:
  /// **'This deletes all your learning progress permanently. This cannot be undone.'**
  String get resetProgressWarning;

  /// No description provided for @resetProgressTypeWord.
  ///
  /// In en, this message translates to:
  /// **'Type \"delete\" to confirm.'**
  String get resetProgressTypeWord;

  /// No description provided for @resetProgressConfirmWord.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get resetProgressConfirmWord;

  /// No description provided for @resetProgressDone.
  ///
  /// In en, this message translates to:
  /// **'Your progress has been reset.'**
  String get resetProgressDone;

  /// No description provided for @backupProgressDone.
  ///
  /// In en, this message translates to:
  /// **'Your progress has been backed up.'**
  String get backupProgressDone;

  /// No description provided for @backupProgressError.
  ///
  /// In en, this message translates to:
  /// **'Backing up failed.'**
  String get backupProgressError;

  /// No description provided for @restoreProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore progress?'**
  String get restoreProgressTitle;

  /// No description provided for @restoreProgressWarning.
  ///
  /// In en, this message translates to:
  /// **'Your current progress will be replaced by the backup from this file. This cannot be undone.'**
  String get restoreProgressWarning;

  /// No description provided for @restoreProgressDone.
  ///
  /// In en, this message translates to:
  /// **'Your progress has been restored.'**
  String get restoreProgressDone;

  /// No description provided for @restoreProgressInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'This file is not a valid Amaseganlo backup.'**
  String get restoreProgressInvalidFile;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// No description provided for @aboutBuildDate.
  ///
  /// In en, this message translates to:
  /// **'Build date'**
  String get aboutBuildDate;

  /// No description provided for @aboutPrivacy.
  ///
  /// In en, this message translates to:
  /// **'All your data stays on this device. No account, no server, no ads, no tracking.'**
  String get aboutPrivacy;

  /// No description provided for @aboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get aboutLicenses;

  /// No description provided for @aboutShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts'**
  String get aboutShortcuts;

  /// No description provided for @aboutShortcutsAnswer.
  ///
  /// In en, this message translates to:
  /// **'1–4: choose an answer'**
  String get aboutShortcutsAnswer;

  /// No description provided for @aboutShortcutsNext.
  ///
  /// In en, this message translates to:
  /// **'Enter: confirm / continue'**
  String get aboutShortcutsNext;

  /// No description provided for @aboutShortcutsCancel.
  ///
  /// In en, this message translates to:
  /// **'Escape: cancel'**
  String get aboutShortcutsCancel;

  /// No description provided for @aboutShortcutsAudio.
  ///
  /// In en, this message translates to:
  /// **'Space: replay audio'**
  String get aboutShortcutsAudio;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Selam! Welcome to Amaseganlo'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Amaseganlo teaches you Amharic (አማርኛ), the official language of Ethiopia.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingChooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your app language'**
  String get onboardingChooseLanguage;

  /// No description provided for @onboardingTwoPathsTitle.
  ///
  /// In en, this message translates to:
  /// **'Two learning paths'**
  String get onboardingTwoPathsTitle;

  /// No description provided for @onboardingTwoPathsBody.
  ///
  /// In en, this message translates to:
  /// **'\"Speak & understand\" teaches Amharic in Latin transliteration. \"Learn Fidel\" teaches the Ethiopic script. Both run side by side.'**
  String get onboardingTwoPathsBody;

  /// No description provided for @onboardingDailyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your daily goal'**
  String get onboardingDailyGoalTitle;

  /// No description provided for @onboardingAssessmentQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you already know some Amharic?'**
  String get onboardingAssessmentQuestion;

  /// No description provided for @onboardingAssessmentNone.
  ///
  /// In en, this message translates to:
  /// **'I\'m starting from zero'**
  String get onboardingAssessmentNone;

  /// No description provided for @onboardingAssessmentSome.
  ///
  /// In en, this message translates to:
  /// **'A few words'**
  String get onboardingAssessmentSome;

  /// No description provided for @onboardingAssessmentGood.
  ///
  /// In en, this message translates to:
  /// **'I already know quite a bit'**
  String get onboardingAssessmentGood;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get onboardingStart;

  /// No description provided for @homeContinueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue learning'**
  String get homeContinueLearning;

  /// No description provided for @homeDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get homeDailyGoal;

  /// No description provided for @homeStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get homeStreak;

  /// No description provided for @homeReviewDue.
  ///
  /// In en, this message translates to:
  /// **'{count} due for review'**
  String homeReviewDue(int count);

  /// No description provided for @homeFreePractice.
  ///
  /// In en, this message translates to:
  /// **'Free practice'**
  String get homeFreePractice;

  /// No description provided for @homeNoReviewsDue.
  ///
  /// In en, this message translates to:
  /// **'Nothing due right now. Practice your weak words instead?'**
  String get homeNoReviewsDue;

  /// No description provided for @pathSectionProgress.
  ///
  /// In en, this message translates to:
  /// **'Section {section}: {title} — {done} of {total} units'**
  String pathSectionProgress(int section, String title, int done, int total);

  /// No description provided for @pathLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get pathLocked;

  /// No description provided for @pathSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get pathSkipped;

  /// No description provided for @pathCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get pathCompleted;

  /// No description provided for @pathLockedDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'This unit builds on earlier ones'**
  String get pathLockedDialogTitle;

  /// No description provided for @pathLockedDialogBody.
  ///
  /// In en, this message translates to:
  /// **'You don\'t know all the words used here yet. Start anyway?'**
  String get pathLockedDialogBody;

  /// No description provided for @pathLockedDialogLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get pathLockedDialogLater;

  /// No description provided for @pathLockedDialogStart.
  ///
  /// In en, this message translates to:
  /// **'Start anyway'**
  String get pathLockedDialogStart;

  /// No description provided for @pathUnitTest.
  ///
  /// In en, this message translates to:
  /// **'Unit test'**
  String get pathUnitTest;

  /// No description provided for @pathUnitTestHint.
  ///
  /// In en, this message translates to:
  /// **'Skip this unit by passing a test'**
  String get pathUnitTestHint;

  /// No description provided for @chapterTestScore.
  ///
  /// In en, this message translates to:
  /// **'{correct} of {total} correct'**
  String chapterTestScore(int correct, int total);

  /// No description provided for @chapterTestPassedTitle.
  ///
  /// In en, this message translates to:
  /// **'Passed!'**
  String get chapterTestPassedTitle;

  /// No description provided for @chapterTestPassedBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve earned a crown for this unit.'**
  String get chapterTestPassedBody;

  /// No description provided for @chapterTestFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Not quite there yet'**
  String get chapterTestFailedTitle;

  /// No description provided for @chapterTestFailedBody.
  ///
  /// In en, this message translates to:
  /// **'No worries - the words you missed have been reset. Try again right away.'**
  String get chapterTestFailedBody;

  /// No description provided for @placementTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Placement test'**
  String get placementTestTitle;

  /// No description provided for @placementTestIntro.
  ///
  /// In en, this message translates to:
  /// **'We\'ll ask you a few questions to find the best place for you to start. You can cancel anytime.'**
  String get placementTestIntro;

  /// No description provided for @placementTestStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get placementTestStart;

  /// No description provided for @placementTestResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggestion: {section}'**
  String placementTestResultTitle(String section);

  /// No description provided for @placementTestResultBody.
  ///
  /// In en, this message translates to:
  /// **'Based on your answers, we suggest starting here. Earlier units are marked as skipped and can be caught up on anytime.'**
  String get placementTestResultBody;

  /// No description provided for @placementTestResultBodyBeginning.
  ///
  /// In en, this message translates to:
  /// **'Starting right from the beginning is the best fit - that\'s completely normal!'**
  String get placementTestResultBodyBeginning;

  /// No description provided for @placementTestAccept.
  ///
  /// In en, this message translates to:
  /// **'Use this'**
  String get placementTestAccept;

  /// No description provided for @placementTestCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel test'**
  String get placementTestCancel;

  /// No description provided for @unitOverviewLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get unitOverviewLessons;

  /// No description provided for @unitOverviewWordList.
  ///
  /// In en, this message translates to:
  /// **'Word list'**
  String get unitOverviewWordList;

  /// No description provided for @unitOverviewCrowns.
  ///
  /// In en, this message translates to:
  /// **'{crowns} of 5 crowns'**
  String unitOverviewCrowns(int crowns);

  /// No description provided for @lessonExitConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'End this lesson?'**
  String get lessonExitConfirmTitle;

  /// No description provided for @lessonExitConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your progress in this lesson will be lost.'**
  String get lessonExitConfirmBody;

  /// No description provided for @lessonCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Lesson complete!'**
  String get lessonCompleteTitle;

  /// No description provided for @lessonCompleteXp.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String lessonCompleteXp(int xp);

  /// No description provided for @lessonCompleteAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy: {percent}%'**
  String lessonCompleteAccuracy(int percent);

  /// No description provided for @lessonCompleteDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {minutes} min'**
  String lessonCompleteDuration(int minutes);

  /// No description provided for @lessonCompleteSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped: {count}'**
  String lessonCompleteSkipped(int count);

  /// No description provided for @lessonCompleteContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get lessonCompleteContinue;

  /// No description provided for @lessonCompleteRetry.
  ///
  /// In en, this message translates to:
  /// **'Do it again'**
  String get lessonCompleteRetry;

  /// No description provided for @lessonOutOfHearts.
  ///
  /// In en, this message translates to:
  /// **'Out of hearts'**
  String get lessonOutOfHearts;

  /// No description provided for @lessonOutOfHeartsBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all your hearts for this lesson. Come back later or practice again.'**
  String get lessonOutOfHeartsBody;

  /// No description provided for @feedbackCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get feedbackCorrect;

  /// No description provided for @feedbackIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Not quite'**
  String get feedbackIncorrect;

  /// No description provided for @feedbackAlmostCorrect.
  ///
  /// In en, this message translates to:
  /// **'Almost! Watch the spelling: {correct}'**
  String feedbackAlmostCorrect(String correct);

  /// No description provided for @feedbackCorrectAnswerWas.
  ///
  /// In en, this message translates to:
  /// **'Correct answer: {answer}'**
  String feedbackCorrectAnswerWas(String answer);

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewTitle;

  /// No description provided for @reviewDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get reviewDueToday;

  /// No description provided for @reviewDifficultWords.
  ///
  /// In en, this message translates to:
  /// **'Difficult words'**
  String get reviewDifficultWords;

  /// No description provided for @reviewFreePractice.
  ///
  /// In en, this message translates to:
  /// **'Free practice'**
  String get reviewFreePractice;

  /// No description provided for @reviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to review right now. Great job keeping up!'**
  String get reviewEmpty;

  /// No description provided for @reviewWordCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String reviewWordCount(int count);

  /// No description provided for @reviewWordCountOne.
  ///
  /// In en, this message translates to:
  /// **'1 word'**
  String get reviewWordCountOne;

  /// No description provided for @reviewStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get reviewStart;

  /// No description provided for @reviewNoWordsForSession.
  ///
  /// In en, this message translates to:
  /// **'There are no words for this right now.'**
  String get reviewNoWordsForSession;

  /// No description provided for @reviewFreePracticeChooseLevel.
  ///
  /// In en, this message translates to:
  /// **'Choose a level'**
  String get reviewFreePracticeChooseLevel;

  /// No description provided for @reviewFreePracticeAllLevels.
  ///
  /// In en, this message translates to:
  /// **'All levels'**
  String get reviewFreePracticeAllLevels;

  /// No description provided for @reviewSessionCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Review complete!'**
  String get reviewSessionCompleteTitle;

  /// No description provided for @reviewSessionCompleteXp.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP'**
  String reviewSessionCompleteXp(int xp);

  /// No description provided for @reviewSessionCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Keep it up!'**
  String get reviewSessionCompleteBody;

  /// No description provided for @dictionaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Dictionary'**
  String get dictionaryTitle;

  /// No description provided for @dictionarySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search words…'**
  String get dictionarySearchHint;

  /// No description provided for @dictionaryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All topics'**
  String get dictionaryFilterAll;

  /// No description provided for @dictionaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No words learned yet in this topic.'**
  String get dictionaryEmpty;

  /// No description provided for @dictionarySearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matches.'**
  String get dictionarySearchNoResults;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileWordsLearned.
  ///
  /// In en, this message translates to:
  /// **'Words learned'**
  String get profileWordsLearned;

  /// No description provided for @profileWordsMastered.
  ///
  /// In en, this message translates to:
  /// **'Words mastered'**
  String get profileWordsMastered;

  /// No description provided for @profileFidelChars.
  ///
  /// In en, this message translates to:
  /// **'Fidel signs learned'**
  String get profileFidelChars;

  /// No description provided for @profileTotalXp.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get profileTotalXp;

  /// No description provided for @profileLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest streak'**
  String get profileLongestStreak;

  /// No description provided for @profileCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get profileCurrentStreak;

  /// No description provided for @profileDaysLearned.
  ///
  /// In en, this message translates to:
  /// **'Days learned'**
  String get profileDaysLearned;

  /// No description provided for @profileAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get profileAccuracy;

  /// No description provided for @profileLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get profileLast7Days;

  /// No description provided for @profileBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get profileBadges;

  /// No description provided for @profileBadgesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No badges yet - get started!'**
  String get profileBadgesEmpty;

  /// No description provided for @profileSkippedUnits.
  ///
  /// In en, this message translates to:
  /// **'Skipped units'**
  String get profileSkippedUnits;

  /// No description provided for @profileSkippedUnitsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t skipped any units.'**
  String get profileSkippedUnitsEmpty;

  /// No description provided for @profileCatchUp.
  ///
  /// In en, this message translates to:
  /// **'Catch up'**
  String get profileCatchUp;

  /// No description provided for @profileAssessmentTest.
  ///
  /// In en, this message translates to:
  /// **'Placement test'**
  String get profileAssessmentTest;

  /// No description provided for @profileBadgeFirstLessonName.
  ///
  /// In en, this message translates to:
  /// **'First steps'**
  String get profileBadgeFirstLessonName;

  /// No description provided for @profileBadgeFirstLessonDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your first lesson.'**
  String get profileBadgeFirstLessonDesc;

  /// No description provided for @profileBadgeStreak7Name.
  ///
  /// In en, this message translates to:
  /// **'One week in'**
  String get profileBadgeStreak7Name;

  /// No description provided for @profileBadgeStreak7Desc.
  ///
  /// In en, this message translates to:
  /// **'Reach a 7-day streak.'**
  String get profileBadgeStreak7Desc;

  /// No description provided for @profileBadgeStreak30Name.
  ///
  /// In en, this message translates to:
  /// **'One month in'**
  String get profileBadgeStreak30Name;

  /// No description provided for @profileBadgeStreak30Desc.
  ///
  /// In en, this message translates to:
  /// **'Reach a 30-day streak.'**
  String get profileBadgeStreak30Desc;

  /// No description provided for @profileBadgeWords100Name.
  ///
  /// In en, this message translates to:
  /// **'Growing vocabulary'**
  String get profileBadgeWords100Name;

  /// No description provided for @profileBadgeWords100Desc.
  ///
  /// In en, this message translates to:
  /// **'Learn 100 words.'**
  String get profileBadgeWords100Desc;

  /// No description provided for @profileBadgeWords500Name.
  ///
  /// In en, this message translates to:
  /// **'Chatterbox'**
  String get profileBadgeWords500Name;

  /// No description provided for @profileBadgeWords500Desc.
  ///
  /// In en, this message translates to:
  /// **'Learn 500 words.'**
  String get profileBadgeWords500Desc;

  /// No description provided for @profileBadgeFidelMasterName.
  ///
  /// In en, this message translates to:
  /// **'Fidel master'**
  String get profileBadgeFidelMasterName;

  /// No description provided for @profileBadgeFidelMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn all 231 Fidel signs.'**
  String get profileBadgeFidelMasterDesc;

  /// No description provided for @profileBadgeXp1000Name.
  ///
  /// In en, this message translates to:
  /// **'1000 XP'**
  String get profileBadgeXp1000Name;

  /// No description provided for @profileBadgeXp1000Desc.
  ///
  /// In en, this message translates to:
  /// **'Earn a total of 1000 XP.'**
  String get profileBadgeXp1000Desc;

  /// No description provided for @profileBadgeFirstCrownName.
  ///
  /// In en, this message translates to:
  /// **'First crown'**
  String get profileBadgeFirstCrownName;

  /// No description provided for @profileBadgeFirstCrownDesc.
  ///
  /// In en, this message translates to:
  /// **'Pass your first unit test.'**
  String get profileBadgeFirstCrownDesc;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericBody.
  ///
  /// In en, this message translates to:
  /// **'Your progress is saved.'**
  String get errorGenericBody;

  /// No description provided for @errorGoHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get errorGoHome;

  /// No description provided for @errorReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get errorReload;

  /// No description provided for @errorContentUnit.
  ///
  /// In en, this message translates to:
  /// **'This unit couldn\'t be loaded and was skipped.'**
  String get errorContentUnit;

  /// No description provided for @errorCorruptSave.
  ///
  /// In en, this message translates to:
  /// **'Your saved data couldn\'t be read. Starting fresh.'**
  String get errorCorruptSave;

  /// No description provided for @resumeLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'You were in the middle of a lesson'**
  String get resumeLessonTitle;

  /// No description provided for @resumeLessonBody.
  ///
  /// In en, this message translates to:
  /// **'Continue where you left off?'**
  String get resumeLessonBody;

  /// No description provided for @resumeLessonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get resumeLessonContinue;

  /// No description provided for @resumeLessonRestart.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get resumeLessonRestart;

  /// No description provided for @exitAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get exitAppConfirm;

  /// No description provided for @exerciseCheckAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get exerciseCheckAnswer;

  /// No description provided for @exerciseTypeAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Type your answer…'**
  String get exerciseTypeAnswerHint;

  /// No description provided for @exercisePairMatchingHint.
  ///
  /// In en, this message translates to:
  /// **'Tap matching pairs'**
  String get exercisePairMatchingHint;

  /// No description provided for @exerciseTrueFalseQuestion.
  ///
  /// In en, this message translates to:
  /// **'Is this correct?'**
  String get exerciseTrueFalseQuestion;

  /// No description provided for @exerciseTrue.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get exerciseTrue;

  /// No description provided for @exerciseFalse.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get exerciseFalse;

  /// No description provided for @exerciseAudioUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Amharic audio isn\'t available on this device'**
  String get exerciseAudioUnavailable;

  /// No description provided for @introCardContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get introCardContinue;

  /// No description provided for @lessonKindIntro.
  ///
  /// In en, this message translates to:
  /// **'New words'**
  String get lessonKindIntro;

  /// No description provided for @lessonKindWordPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice words'**
  String get lessonKindWordPractice;

  /// No description provided for @lessonKindSentenceBuilding.
  ///
  /// In en, this message translates to:
  /// **'Build sentences'**
  String get lessonKindSentenceBuilding;

  /// No description provided for @lessonKindListening.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get lessonKindListening;

  /// No description provided for @lessonKindFreeApplication.
  ///
  /// In en, this message translates to:
  /// **'Free practice'**
  String get lessonKindFreeApplication;

  /// No description provided for @lessonKindReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get lessonKindReview;

  /// No description provided for @lessonKindUnitTest.
  ///
  /// In en, this message translates to:
  /// **'Unit test'**
  String get lessonKindUnitTest;

  /// No description provided for @fidelHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Fidel'**
  String get fidelHomeTitle;

  /// No description provided for @fidelStageProgress.
  ///
  /// In en, this message translates to:
  /// **'Stage {number}: {title}'**
  String fidelStageProgress(int number, String title);

  /// No description provided for @fidelStageBonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get fidelStageBonus;

  /// No description provided for @fidelStageComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get fidelStageComingSoon;

  /// No description provided for @fidelLessonList.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get fidelLessonList;

  /// No description provided for @fidelTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Fidel table'**
  String get fidelTableTitle;

  /// No description provided for @fidelTableFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get fidelTableFilterAll;

  /// No description provided for @fidelTableFilterLearned.
  ///
  /// In en, this message translates to:
  /// **'Learned only'**
  String get fidelTableFilterLearned;

  /// No description provided for @fidelTableFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Not yet learned'**
  String get fidelTableFilterOpen;

  /// No description provided for @fidelTableStudyRow.
  ///
  /// In en, this message translates to:
  /// **'Practice this row'**
  String get fidelTableStudyRow;

  /// No description provided for @fidelTableDetailLearned.
  ///
  /// In en, this message translates to:
  /// **'Learned'**
  String get fidelTableDetailLearned;

  /// No description provided for @fidelTableDetailNotLearned.
  ///
  /// In en, this message translates to:
  /// **'Not learned yet'**
  String get fidelTableDetailNotLearned;

  /// No description provided for @fidelHomophoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Careful: same sound'**
  String get fidelHomophoneTitle;

  /// No description provided for @fidelHomophoneBody.
  ///
  /// In en, this message translates to:
  /// **'This sign sounds exactly like {chars}, which you already know. Which one to write depends on the word - you\'ll learn that later when reading.'**
  String fidelHomophoneBody(String chars);

  /// No description provided for @fidelVowelExplainerTitle.
  ///
  /// In en, this message translates to:
  /// **'Every sign is a syllable'**
  String get fidelVowelExplainerTitle;

  /// No description provided for @fidelVowelExplainerIntro.
  ///
  /// In en, this message translates to:
  /// **'ለ is not \"l\", it\'s \"le\" - every Fidel sign stands for a whole syllable sound, not just a consonant.'**
  String get fidelVowelExplainerIntro;

  /// No description provided for @fidelVowelExplainerRow1Title.
  ///
  /// In en, this message translates to:
  /// **'Look at the ሀ (h) row'**
  String get fidelVowelExplainerRow1Title;

  /// No description provided for @fidelVowelExplainerRow1Body.
  ///
  /// In en, this message translates to:
  /// **'Seven forms, seven vowels - the base shape stays, only the vowel part (colored) changes.'**
  String get fidelVowelExplainerRow1Body;

  /// No description provided for @fidelVowelExplainerRow2Title.
  ///
  /// In en, this message translates to:
  /// **'Now the ለ (l) row'**
  String get fidelVowelExplainerRow2Title;

  /// No description provided for @fidelVowelExplainerRow2Body.
  ///
  /// In en, this message translates to:
  /// **'The same pattern as ሀ - that\'s not a coincidence, it\'s a system.'**
  String get fidelVowelExplainerRow2Body;

  /// No description provided for @fidelVowelExplainerOrder6Title.
  ///
  /// In en, this message translates to:
  /// **'The 6th order is the hardest'**
  String get fidelVowelExplainerOrder6Title;

  /// No description provided for @fidelVowelExplainerOrder6Body.
  ///
  /// In en, this message translates to:
  /// **'Its vowel is barely audible (a breathy \"ə\"), and the shape often differs only slightly from the base sign. It\'s also the single most common form - you\'ll see it a lot.'**
  String get fidelVowelExplainerOrder6Body;

  /// No description provided for @fidelVowelExplainerExceptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Not every row is perfectly regular'**
  String get fidelVowelExplainerExceptionTitle;

  /// No description provided for @fidelVowelExplainerExceptionBody.
  ///
  /// In en, this message translates to:
  /// **'Most rows follow this pattern, but a few don\'t. The app will always tell you honestly when that\'s the case.'**
  String get fidelVowelExplainerExceptionBody;

  /// No description provided for @fidelExplainerContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get fidelExplainerContinue;

  /// No description provided for @fidelLockedDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'This stage builds on the previous one'**
  String get fidelLockedDialogTitle;

  /// No description provided for @fidelLockedDialogBody.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t finished the previous stage yet. Start anyway?'**
  String get fidelLockedDialogBody;

  /// No description provided for @settingsHahuTempo.
  ///
  /// In en, this message translates to:
  /// **'Ha-Hu rhythm speed'**
  String get settingsHahuTempo;

  /// No description provided for @hahuTempoSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get hahuTempoSlow;

  /// No description provided for @hahuTempoNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get hahuTempoNormal;

  /// No description provided for @hahuTempoFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get hahuTempoFast;

  /// No description provided for @hahuDrillTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap along to the rhythm'**
  String get hahuDrillTapHint;

  /// No description provided for @hahuDrillWithTransliteration.
  ///
  /// In en, this message translates to:
  /// **'Round 1 of 2: with transliteration'**
  String get hahuDrillWithTransliteration;

  /// No description provided for @hahuDrillCharsOnly.
  ///
  /// In en, this message translates to:
  /// **'Round 2 of 2: signs only'**
  String get hahuDrillCharsOnly;

  /// No description provided for @hahuDrillContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get hahuDrillContinue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'nl', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
