import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/journey_progress.dart';
import '../../core/purchase_service.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/curriculum.dart';
import '../../models/lesson.dart';
import '../../models/lexeme.dart';
import '../../state/content_provider.dart';
import '../../state/lesson_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/exercise_player.dart';
import '../../widgets/common/lesson_progress_bar.dart';

// wordChoice always generates for any lexeme, unlike some other exercise
// types that can silently produce nothing for a given word - important
// here since a block must always be exactly 5 questions.
const _blockExerciseTypes = [
  ExerciseType.wordChoiceAmToNative,
  ExerciseType.wordChoiceNativeToAm,
];

const _blockSize = 5;
const _maxQuestions = 30;

enum _Phase { intro, testing, result }

/// Adaptive Einstufungstest (Teil A2): one 5-question block per curriculum
/// section, easiest first. Passing a block (>=4/5) advances to the next
/// section's block; failing one (<=3/5) stops the test there and that
/// section becomes the proposed starting point - every earlier section's
/// units get marked as skipped once the learner accepts the suggestion.
class PlacementTestScreen extends StatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  State<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends State<PlacementTestScreen> {
  _Phase _phase = _Phase.intro;
  int _levelIndex = 0;
  int _highestPassedIndex = -1;
  int _totalAsked = 0;
  bool _blockActive = false;
  bool _handlingResult = false;

  // Etappe 28 Nachtrag 10: the test used to walk every curriculum section in
  // file order regardless of language, which meant it was Amharic-only in
  // practice - all 6 Ethiopia sections come before any Eritrea one, and
  // failing a block stops the test right there, so nobody could ever fail
  // their way into Tigrinya questions. Asking upfront and filtering by
  // language fixes both the mixed-language mismatch and, as a side effect,
  // keeps the test automatically in sync with however many units each
  // language has now (it was never a hardcoded question list to begin with
  // - lexemesForUnit already pulls from whatever's currently in that
  // section, so new content is picked up without any further changes here).
  String? _chosenLanguage;

  List<CurriculumSection> get _sections => context
      .read<ContentProvider>()
      .repository
      .curriculum
      .sections
      .where((s) => s.language == (_chosenLanguage ?? 'am'))
      .toList();

  void _startTest() {
    setState(() {
      _phase = _Phase.testing;
      _levelIndex = 0;
      _highestPassedIndex = -1;
      _totalAsked = 0;
    });
    _startBlock();
  }

  void _startBlock() {
    final sections = _sections;
    if (_levelIndex >= sections.length || _totalAsked >= _maxQuestions) {
      _finishTest();
      return;
    }

    final content = context.read<ContentProvider>().repository;
    final section = sections[_levelIndex];
    final pool = <Lexeme>[
      for (final unitId in section.unitIds) ...content.lexemesForUnit(unitId),
    ]..shuffle();

    if (pool.isEmpty) {
      // No content for this level yet - treat it as mastered and move on.
      _highestPassedIndex = _levelIndex;
      _levelIndex++;
      _startBlock();
      return;
    }

    final blockWords = pool.length > _blockSize
        ? pool.sublist(0, _blockSize)
        : pool;
    final settings = context.read<SettingsProvider>().settings;
    final locale =
        settings.localeCode ?? Localizations.localeOf(context).languageCode;
    final lesson = Lesson(
      id: 'placement_block_${section.id}',
      unitId: '',
      kind: LessonKind.review,
      lexemeIds: [for (final w in blockWords) w.id],
      exerciseTypes: _blockExerciseTypes,
    );
    _blockActive = true;
    context.read<LessonProvider>().startAdHocSession(
      lesson: lesson,
      locale: locale,
      useHearts: false,
    );
  }

  void _onBlockFinished(LessonSession session) {
    _blockActive = false;
    _handlingResult = false;
    _totalAsked += session.exercises.length;
    final blockPassed = session.correctCount >= 4;
    context.read<LessonProvider>().endSession();

    if (blockPassed) {
      _highestPassedIndex = _levelIndex;
      _levelIndex++;
      _startBlock();
    } else {
      _finishTest();
    }
  }

  void _finishTest() {
    setState(() => _phase = _Phase.result);
  }

  Future<void> _acceptSuggestion() async {
    final sections = _sections;
    final progress = context.read<ProgressProvider>();
    // Etappe 23: a strong placement-test result must not become a free way
    // past the paywall - a unit past the free trial only ever becomes
    // playable by actually buying Premium, no matter how well the learner
    // scored here.
    final isPremium = context.read<PurchaseService>().isPremium;
    final freeIds = freeTrialUnitIds(context.read<ContentProvider>().repository).toSet();
    for (var i = 0; i <= _highestPassedIndex && i < sections.length; i++) {
      for (final unitId in sections[i].unitIds) {
        if (!isPremium && !freeIds.contains(unitId)) continue;
        await progress.markUnitSkipped(unitId);
      }
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l10n.commonClose,
          onPressed: () => context.pop(),
        ),
        title: _phase == _Phase.testing ? null : Text(l10n.placementTestTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: switch (_phase) {
            _Phase.intro => _buildIntro(context, l10n),
            _Phase.testing => _buildTesting(context, l10n),
            _Phase.result => _buildResult(context, l10n),
          },
        ),
      ),
    );
  }

  Widget _buildIntro(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.placementTestTitle,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.placementTestIntro,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.placementTestChooseLanguagePrompt,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'am', label: Text(l10n.placementTestChooseLanguageEthiopia)),
              ButtonSegment(value: 'ti', label: Text(l10n.placementTestChooseLanguageEritrea)),
            ],
            selected: _chosenLanguage == null ? const {} : {_chosenLanguage!},
            emptySelectionAllowed: true,
            onSelectionChanged: (selection) {
              setState(() => _chosenLanguage = selection.isEmpty ? null : selection.first);
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _chosenLanguage == null ? null : _startTest,
              child: Text(l10n.placementTestStart),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTesting(BuildContext context, AppLocalizations l10n) {
    final lessonProvider = context.watch<LessonProvider>();
    final session = lessonProvider.session;
    final settings = context.watch<SettingsProvider>().settings;
    final locale =
        settings.localeCode ?? Localizations.localeOf(context).languageCode;

    if (session == null || !_blockActive) {
      return const Center(child: CircularProgressIndicator());
    }

    if (session.isFinished && !_handlingResult) {
      _handlingResult = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _onBlockFinished(session);
      });
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LessonProgressBar(
          progress: session.exercises.isEmpty
              ? 1
              : session.currentIndex / session.exercises.length,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ExercisePlayer(
            session: session,
            locale: locale,
            keyPrefix: 'placement',
          ),
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final sections = _sections;
    final proposedIndex = (_highestPassedIndex + 1).clamp(
      0,
      sections.isEmpty ? 0 : sections.length - 1,
    );
    final proposedSection = sections.isEmpty ? null : sections[proposedIndex];
    final settings = context.watch<SettingsProvider>().settings;
    final locale =
        settings.localeCode ?? Localizations.localeOf(context).languageCode;
    final startingFromScratch = _highestPassedIndex < 0;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_circle_outlined, size: 64, color: successColor),
          const SizedBox(height: 20),
          Text(
            proposedSection == null
                ? l10n.placementTestTitle
                : l10n.placementTestResultTitle(
                    proposedSection.title[locale] ?? proposedSection.id,
                  ),
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            startingFromScratch
                ? l10n.placementTestResultBodyBeginning
                : l10n.placementTestResultBody,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _acceptSuggestion,
              child: Text(l10n.placementTestAccept),
            ),
          ),
        ],
      ),
    );
  }
}
