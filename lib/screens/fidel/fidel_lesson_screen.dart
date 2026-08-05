import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/fidel_lesson.dart';
import '../../models/settings.dart';
import '../../state/fidel_lesson_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/dont_know_link.dart';
import '../../widgets/common/feedback_bar.dart';
import '../../widgets/common/lesson_progress_bar.dart';
import '../../widgets/exercises/homophone_note_card.dart';
import '../../widgets/exercises/multiple_choice_exercise.dart';
import 'fidel_vowel_explainer.dart';

class FidelLessonScreen extends StatefulWidget {
  final String stageId;
  final String lessonId;

  /// Set when launched from the Fidel table's "Diese Reihe üben" button -
  /// runs an ad-hoc drill instead of loading real stage/lesson content.
  final String? practiceGroup;

  const FidelLessonScreen({super.key, required this.stageId, required this.lessonId, this.practiceGroup});

  @override
  State<FidelLessonScreen> createState() => _FidelLessonScreenState();
}

class _FidelLessonScreenState extends State<FidelLessonScreen> {
  String? _selectedOption;
  bool _started = false;
  bool _finishing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      final settings = context.read<SettingsProvider>().settings;
      final practiceGroup = widget.practiceGroup;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final provider = context.read<FidelLessonProvider>();
        if (practiceGroup != null) {
          provider.startRowPractice(practiceGroup, useHearts: settings.useHearts);
        } else {
          provider.startLesson(
            stageId: widget.stageId,
            lessonId: widget.lessonId,
            useHearts: settings.useHearts,
          );
        }
      });
    }
  }

  Future<bool> _confirmExit(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.lessonExitConfirmTitle),
        content: Text(l10n.lessonExitConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonConfirm)),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final fidelProvider = context.watch<FidelLessonProvider>();
    final session = fidelProvider.session;
    final settings = context.watch<SettingsProvider>().settings;

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session.lesson.kind == FidelLessonKind.vowelExplainer) {
      return FidelVowelExplainerScreen(
        onFinished: () async {
          await context.read<ProgressProvider>().completeLesson(
                session.lessonId,
                score: 1,
                perfect: true,
                dailyGoalXp: settings.dailyGoal.xp,
              );
          if (!context.mounted) return;
          context.pop();
        },
      );
    }

    if (session.outOfHearts && !session.isFinished) {
      return _OutOfHeartsView(onGoHome: () => context.go('/fidel'));
    }

    if (session.isFinished && !_finishing) {
      _finishing = true;
      final isPractice = widget.practiceGroup != null;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!context.mounted) return;
        if (isPractice) {
          final l10n = AppLocalizations.of(context);
          context.read<FidelLessonProvider>().endSession();
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.lessonCompleteAccuracy(
              session.exercises.isEmpty ? 100 : ((session.correctCount / session.exercises.length) * 100).round(),
            ))),
          );
          return;
        }
        await context.read<ProgressProvider>().completeLesson(
              session.lessonId,
              score: session.scoreRatio,
              perfect: session.isPerfect,
              dailyGoalXp: settings.dailyGoal.xp,
            );
        if (!context.mounted) return;
        context.pushReplacement('/fidel/lesson/${widget.stageId}/${widget.lessonId}/complete');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final totalSteps = session.homophoneNotes.length + session.exercises.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit(context);
        if (shouldExit && context.mounted) {
          context.read<FidelLessonProvider>().endSession();
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldExit = await _confirmExit(context);
              if (shouldExit && context.mounted) {
                context.read<FidelLessonProvider>().endSession();
                context.pop();
              }
            },
          ),
          title: LessonProgressBar(
            progress: totalSteps == 0 ? 1 : session.currentIndex / totalSteps,
            heartsRemaining: session.heartsRemaining,
            showHearts: settings.useHearts,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: session.isShowingNote
                ? HomophoneNoteCard(
                    note: session.currentNote!,
                    onContinue: () => context.read<FidelLessonProvider>().advancePastNote(),
                  )
                : _buildExercise(context, session, fidelProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildExercise(BuildContext context, FidelLessonSession session, FidelLessonProvider provider) {
    final exercise = session.currentExercise;
    if (exercise == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: MultipleChoiceExercise(
              promptText: exercise.promptText,
              promptStyle: exercise.promptText.runes.length == 1
                  ? Theme.of(context).textTheme.displayLarge
                  : Theme.of(context).textTheme.headlineSmall,
              options: exercise.options,
              correctAnswer: exercise.correctAnswer,
              selectedOption: _selectedOption,
              answered: session.answered,
              onSelect: (value) {
                setState(() => _selectedOption = value);
                provider.submitAnswer(value);
              },
            ),
          ),
        ),
        if (!session.answered) DontKnowLink(onPressed: () => provider.skipCurrentExercise()),
        FeedbackBar(
          isCorrect: session.answered ? session.lastAnswerCorrect : null,
          isSkipped: session.lastAnswerSkipped,
          correctAnswerText: exercise.correctAnswer,
          onContinue: () {
            setState(() => _selectedOption = null);
            provider.nextExercise();
          },
        ),
      ],
    );
  }
}

class _OutOfHeartsView extends StatelessWidget {
  final VoidCallback onGoHome;
  const _OutOfHeartsView({required this.onGoHome});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 16),
                Text(l10n.lessonOutOfHearts, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(l10n.lessonOutOfHeartsBody, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(onPressed: onGoHome, child: Text(l10n.errorGoHome)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
