import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/srs/xp.dart';
import '../../l10n/app_localizations.dart';
import '../../models/lesson.dart';
import '../../models/settings.dart';
import '../../state/lesson_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/exercise_player.dart';
import '../../widgets/common/lesson_progress_bar.dart';

const List<ExerciseType> _reviewExerciseTypes = [
  ExerciseType.wordChoiceAmToNative,
  ExerciseType.wordChoiceNativeToAm,
  ExerciseType.pairMatching,
  ExerciseType.wordTyping,
];

/// Plays a review session (fällige/schwierige Wörter, freies Üben) built
/// on the fly from a list of lexeme ids - not tied to a unit/lesson file,
/// unlike [LessonScreen]. Rewards a flat XP bonus instead of the normal
/// per-lesson score, and always ends back on the review screen.
class ReviewSessionScreen extends StatefulWidget {
  final List<String> lexemeIds;

  const ReviewSessionScreen({super.key, required this.lexemeIds});

  @override
  State<ReviewSessionScreen> createState() => _ReviewSessionScreenState();
}

class _ReviewSessionScreenState extends State<ReviewSessionScreen> {
  bool _started = false;
  bool _finishing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      final settings = context.read<SettingsProvider>().settings;
      final locale =
          settings.localeCode ?? Localizations.localeOf(context).languageCode;
      final lesson = Lesson(
        id: 'review_session',
        unitId: '',
        kind: LessonKind.review,
        lexemeIds: widget.lexemeIds,
        exerciseTypes: _reviewExerciseTypes,
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
    final locale =
        settings.localeCode ?? Localizations.localeOf(context).languageCode;

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
                  progress: session.exercises.isEmpty
                      ? 1
                      : session.currentIndex / session.exercises.length,
                ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: session.isFinished
                ? _buildComplete(context, l10n)
                : ExercisePlayer(
                    session: session,
                    locale: locale,
                    keyPrefix: 'review',
                  ),
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
