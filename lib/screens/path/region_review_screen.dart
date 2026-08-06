import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/srs/xp.dart';
import '../../l10n/app_localizations.dart';
import '../../models/lesson.dart';
import '../../models/settings.dart';
import '../../state/content_provider.dart';
import '../../state/lesson_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/exercise_player.dart';
import '../../widgets/common/lesson_progress_bar.dart';

/// Deliberately productive exercise types only (typing a word, building or
/// typing a sentence) - the cumulative region-review station (Etappe 22) is
/// meant as free forming of words/sentences from everything learned so
/// far, not another round of multiple choice.
const List<ExerciseType> _regionReviewExerciseTypes = [
  ExerciseType.wordTyping,
  ExerciseType.sentenceBuild,
  ExerciseType.sentenceGapTyping,
];

/// The "Freies Wiederholen" station at the end of every region (Etappe 22):
/// built on the fly from every lexeme/sentence taught in [sectionIds] -
/// the current region AND every one before it, so it grows cumulatively
/// with each region the learner finishes. Otherwise the same ad-hoc-lesson
/// mechanism as [ReviewSessionScreen] (due/difficult words review), just
/// fed a bigger, region-based pool instead of an SRS-selected one.
class RegionReviewScreen extends StatefulWidget {
  final List<String> sectionIds;

  const RegionReviewScreen({super.key, required this.sectionIds});

  @override
  State<RegionReviewScreen> createState() => _RegionReviewScreenState();
}

class _RegionReviewScreenState extends State<RegionReviewScreen> {
  bool _started = false;
  bool _finishing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      final settings = context.read<SettingsProvider>().settings;
      final locale = settings.localeCode ?? Localizations.localeOf(context).languageCode;
      final content = context.read<ContentProvider>().repository;
      final lexemeIds = [for (final l in content.lexemesForSections(widget.sectionIds)) l.id];
      final sentenceIds = [for (final s in content.sentencesForSections(widget.sectionIds)) s.id];
      final lesson = Lesson(
        id: 'region_review_${widget.sectionIds.last}',
        unitId: '',
        kind: LessonKind.freeApplication,
        lexemeIds: lexemeIds,
        sentenceIds: sentenceIds,
        exerciseTypes: _regionReviewExerciseTypes,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<LessonProvider>().startAdHocSession(
          lesson: lesson,
          locale: locale,
          useHearts: false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = context.watch<LessonProvider>();
    final session = lessonProvider.session;
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>().settings;
    final locale = settings.localeCode ?? Localizations.localeOf(context).languageCode;

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session.isFinished && !_finishing) {
      _finishing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await context.read<ProgressProvider>().addXp(
          XpRules.forReviewSession(),
          dailyGoalXp: settings.dailyGoal.xp,
        );
        if (mounted) setState(() {});
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<LessonProvider>().endSession();
        context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.commonClose,
            onPressed: () {
              context.read<LessonProvider>().endSession();
              context.pop();
            },
          ),
          title: session.isFinished
              ? null
              : LessonProgressBar(
                  progress: session.exercises.isEmpty ? 1 : session.currentIndex / session.exercises.length,
                ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            // `LessonSession.isFinished` is already true the instant
            // `exercises` is empty (currentIndex 0 >= length 0), so that
            // edge case (a region with no real vocabulary yet) lands on
            // the normal completion screen below rather than needing its
            // own empty state.
            child: session.isFinished
                ? _buildComplete(context, l10n)
                : ExercisePlayer(session: session, locale: locale, keyPrefix: 'region_review'),
          ),
        ),
      ),
    );
  }

  Widget _buildComplete(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.celebration, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              l10n.reviewSessionCompleteTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reviewSessionCompleteXp(XpRules.forReviewSession()),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(l10n.reviewSessionCompleteBody, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                context.read<LessonProvider>().endSession();
                context.pop();
              },
              child: Text(l10n.commonContinue),
            ),
          ],
        ),
      ),
    );
  }
}
