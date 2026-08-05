import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/settings.dart';
import '../../state/lesson_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/exercise_player.dart';
import '../../widgets/common/lesson_progress_bar.dart';

/// Kapitel-Test (Teil A1): pass at 85% to earn a crown and have every word
/// in the unit treated as known (Fach 3); fail and the missed words fall
/// back to Fach 1. No hearts, immediately retriable either way.
class ChapterTestScreen extends StatefulWidget {
  final String unitId;

  const ChapterTestScreen({super.key, required this.unitId});

  @override
  State<ChapterTestScreen> createState() => _ChapterTestScreenState();
}

class _ChapterTestScreenState extends State<ChapterTestScreen> {
  bool _started = false;
  bool _finishing = false;
  bool? _passed;
  final Set<String> _missedLexemeIds = {};

  void _start(BuildContext context) {
    final settings = context.read<SettingsProvider>().settings;
    final locale =
        settings.localeCode ?? Localizations.localeOf(context).languageCode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LessonProvider>().startChapterTest(
        unitId: widget.unitId,
        locale: locale,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _start(context);
    }
  }

  Future<void> _finish(LessonSession session, int dailyGoalXp) async {
    final passed = session.scoreRatio >= 0.85;
    final progress = context.read<ProgressProvider>();
    if (passed) {
      await progress.passUnitTest(
        widget.unitId,
        session.lesson.lexemeIds,
        dailyGoalXp: dailyGoalXp,
      );
    } else {
      await progress.failUnitTest(_missedLexemeIds.toList());
    }
    if (mounted) setState(() => _passed = passed);
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = context.watch<LessonProvider>();
    final session = lessonProvider.session;
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>().settings;
    final locale =
        settings.localeCode ?? Localizations.localeOf(context).languageCode;

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Track which words were ever answered wrong, for failUnitTest().
    if (session.answered && session.lastAnswerCorrect == false) {
      final exercise = session.currentExercise;
      if (exercise != null) _missedLexemeIds.add(exercise.subjectId);
    }

    if (session.isFinished && !_finishing) {
      _finishing = true;
      final dailyGoalXp = settings.dailyGoal.xp;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _finish(session, dailyGoalXp);
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
            onPressed: () {
              context.read<LessonProvider>().endSession();
              context.pop();
            },
          ),
          title: session.isFinished
              ? null
              : LessonProgressBar(
                  progress: session.exercises.isEmpty
                      ? 1
                      : session.currentIndex / session.exercises.length,
                ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _passed != null
                ? _buildResult(context, session, l10n)
                : (session.isFinished
                      ? const Center(child: CircularProgressIndicator())
                      : ExercisePlayer(
                          session: session,
                          locale: locale,
                          keyPrefix: 'chaptertest',
                        )),
          ),
        ),
      ),
    );
  }

  Widget _buildResult(
    BuildContext context,
    LessonSession session,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final passed = _passed!;
    final correct = session.correctCount;
    final total = session.exercises.length;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.emoji_events : Icons.refresh,
              size: 72,
              color: passed ? successColor : theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              passed
                  ? l10n.chapterTestPassedTitle
                  : l10n.chapterTestFailedTitle,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chapterTestScore(correct, total),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              passed ? l10n.chapterTestPassedBody : l10n.chapterTestFailedBody,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  context.read<LessonProvider>().endSession();
                  context.pop();
                },
                child: Text(l10n.lessonCompleteContinue),
              ),
            ),
            if (!passed) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // End the old (finished) session first, so the guard in
                    // build() doesn't see a stale finished session and
                    // re-trigger _finish() before the new one has started.
                    context.read<LessonProvider>().endSession();
                    setState(() {
                      _passed = null;
                      _finishing = false;
                      _missedLexemeIds.clear();
                    });
                    _start(context);
                  },
                  child: Text(l10n.lessonCompleteRetry),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
