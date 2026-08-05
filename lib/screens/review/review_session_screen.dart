import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/srs/xp.dart';
import '../../l10n/app_localizations.dart';
import '../../models/exercise.dart';
import '../../models/lesson.dart';
import '../../models/settings.dart';
import '../../state/lesson_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/dont_know_link.dart';
import '../../widgets/common/feedback_bar.dart';
import '../../widgets/common/lesson_progress_bar.dart';
import '../../widgets/exercises/build_chunks_exercise.dart';
import '../../widgets/exercises/multiple_choice_exercise.dart';
import '../../widgets/exercises/pair_matching_exercise.dart';
import '../../widgets/exercises/typing_exercise.dart';

const List<ExerciseType> _reviewExerciseTypes = [
  ExerciseType.wordChoiceAmToNative,
  ExerciseType.wordChoiceNativeToAm,
  ExerciseType.emojiMatch,
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
  String? _selectedOption;
  final TextEditingController _textController = TextEditingController();
  List<String> _selectedChunks = [];
  List<String> _availableChunks = [];
  bool _started = false;
  bool _finishing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      final settings = context.read<SettingsProvider>().settings;
      final locale = settings.localeCode ?? Localizations.localeOf(context).languageCode;
      final lesson = Lesson(
        id: 'review_session',
        unitId: '',
        kind: LessonKind.review,
        lexemeIds: widget.lexemeIds,
        exerciseTypes: _reviewExerciseTypes,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<LessonProvider>().startAdHocSession(lesson: lesson, locale: locale, useHearts: false);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _resetLocalState(GeneratedExercise? exercise) {
    _selectedOption = null;
    _textController.clear();
    _selectedChunks = [];
    _availableChunks = exercise?.chunks ?? [];
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
        await context.read<ProgressProvider>().addXp(XpRules.forReviewSession(), dailyGoalXp: settings.dailyGoal.xp);
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
            onPressed: () {
              context.read<LessonProvider>().endSession();
              context.pop();
            },
          ),
          title: session.isFinished
              ? null
              : LessonProgressBar(progress: session.exercises.isEmpty ? 1 : session.currentIndex / session.exercises.length),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: session.isFinished
                ? _buildComplete(context, l10n)
                : _buildExercise(context, session, lessonProvider, locale, l10n),
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
            Text(l10n.reviewSessionCompleteTitle, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(l10n.reviewSessionCompleteXp(XpRules.forReviewSession()), style: theme.textTheme.titleLarge),
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

  Widget _buildExercise(
    BuildContext context,
    LessonSession session,
    LessonProvider lessonProvider,
    String locale,
    AppLocalizations l10n,
  ) {
    final exercise = session.currentExercise;
    if (exercise == null) return const SizedBox.shrink();

    if (_availableChunks.isEmpty && exercise.isBuildBased && _selectedChunks.isEmpty && !session.answered) {
      _availableChunks = List.of(exercise.chunks);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: _buildExerciseBody(context, exercise, session, lessonProvider, locale),
          ),
        ),
        if (!session.answered) DontKnowLink(onPressed: () => lessonProvider.skipCurrentExercise()),
        FeedbackBar(
          isCorrect: session.answered ? session.lastAnswerCorrect : null,
          isAlmost: session.lastAnswerAlmost,
          isSkipped: session.lastAnswerSkipped,
          correctAnswerText: exercise.correctAnswer,
          onContinue: () => _handleContinue(session, lessonProvider),
        ),
      ],
    );
  }

  Widget _buildExerciseBody(
    BuildContext context,
    GeneratedExercise exercise,
    LessonSession session,
    LessonProvider lessonProvider,
    String locale,
  ) {
    if (exercise.isPairBased) {
      return PairMatchingExercise(
        key: ValueKey('review-pair-${session.currentIndex}'),
        pairs: exercise.pairs,
        onComplete: () => lessonProvider.submitPairMatchingComplete(),
      );
    }

    if (exercise.isChoiceBased) {
      return MultipleChoiceExercise(
        promptText: exercise.promptText,
        options: exercise.options,
        correctAnswer: exercise.correctAnswer,
        selectedOption: _selectedOption,
        answered: session.answered,
        isAudioPrompt: exercise.isAudioPrompt,
        onPlayAudio: () => lessonProvider.playCurrentAudio(),
        onSelect: (value) {
          setState(() => _selectedOption = value);
          lessonProvider.submitChoiceOrBuildAnswer(value);
        },
      );
    }

    if (exercise.isBuildBased) {
      return BuildChunksExercise(
        promptText: exercise.promptText,
        selectedChunks: _selectedChunks,
        availableChunks: _availableChunks,
        answered: session.answered,
        isAudioPrompt: exercise.isAudioPrompt,
        onPlayAudio: () => lessonProvider.playCurrentAudio(),
        onTapAvailable: (index) {
          setState(() {
            _selectedChunks = [..._selectedChunks, _availableChunks[index]];
            _availableChunks = List.of(_availableChunks)..removeAt(index);
          });
        },
        onTapSelected: (index) {
          setState(() {
            _availableChunks = [..._availableChunks, _selectedChunks[index]];
            _selectedChunks = List.of(_selectedChunks)..removeAt(index);
          });
        },
        onSubmit: () => lessonProvider.submitChoiceOrBuildAnswer(_selectedChunks.join(' ')),
      );
    }

    return TypingExercise(
      promptText: exercise.promptText,
      controller: _textController,
      answered: session.answered,
      isAudioPrompt: exercise.isAudioPrompt,
      onPlayAudio: () => lessonProvider.playCurrentAudio(),
      onSubmit: () => lessonProvider.submitTypedAnswer(_textController.text, locale),
    );
  }

  void _handleContinue(LessonSession session, LessonProvider lessonProvider) {
    setState(() {
      final nextIndex = session.currentIndex + 1;
      final next = nextIndex < session.exercises.length ? session.exercises[nextIndex] : null;
      _resetLocalState(next);
    });
    lessonProvider.nextExercise();
  }
}
