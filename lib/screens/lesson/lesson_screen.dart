import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/audio_service.dart';
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
import '../../widgets/exercises/intro_card.dart';
import '../../widgets/exercises/multiple_choice_exercise.dart';
import '../../widgets/exercises/pair_matching_exercise.dart';
import '../../widgets/exercises/typing_exercise.dart';

class LessonScreen extends StatefulWidget {
  final String unitId;
  final String lessonId;

  const LessonScreen({super.key, required this.unitId, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

final Map<LogicalKeyboardKey, int> _lessonDigitKeys = {
  LogicalKeyboardKey.digit1: 0,
  LogicalKeyboardKey.digit2: 1,
  LogicalKeyboardKey.digit3: 2,
  LogicalKeyboardKey.digit4: 3,
  LogicalKeyboardKey.numpad1: 0,
  LogicalKeyboardKey.numpad2: 1,
  LogicalKeyboardKey.numpad3: 2,
  LogicalKeyboardKey.numpad4: 3,
};

class _LessonScreenState extends State<LessonScreen> {
  String? _selectedOption;
  final TextEditingController _textController = TextEditingController();
  List<String> _selectedChunks = [];
  List<String> _availableChunks = [];
  bool _started = false;
  bool _finishing = false;
  final FocusNode _exerciseFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      final settings = context.read<SettingsProvider>().settings;
      final locale = _resolveLocale(context, settings);
      // Deferred to after the first frame: calling notifyListeners() here
      // directly would happen while this very widget is still being built.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<LessonProvider>().startLesson(
              unitId: widget.unitId,
              lessonId: widget.lessonId,
              locale: locale,
              useHearts: settings.useHearts,
            );
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _exerciseFocusNode.dispose();
    super.dispose();
  }

  String _resolveLocale(BuildContext context, AppSettings settings) {
    return settings.localeCode ?? Localizations.localeOf(context).languageCode;
  }

  void _resetLocalState(GeneratedExercise? exercise) {
    _selectedOption = null;
    _textController.clear();
    _selectedChunks = [];
    _availableChunks = exercise?.chunks ?? [];
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
    final lessonProvider = context.watch<LessonProvider>();
    final session = lessonProvider.session;
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>().settings;
    final locale = _resolveLocale(context, settings);

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!session.isIntro && session.outOfHearts && !session.isFinished) {
      return _OutOfHeartsView(onGoHome: () => context.go('/learn'));
    }

    if (session.isFinished && !_finishing) {
      _finishing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        if (!session.isIntro) {
          await context.read<ProgressProvider>().completeLesson(
                session.lessonId,
                score: session.scoreRatio,
                perfect: session.isPerfect,
                dailyGoalXp: settings.dailyGoal.xp,
              );
        } else {
          await context.read<ProgressProvider>().completeLesson(
                session.lessonId,
                score: 1,
                perfect: true,
                dailyGoalXp: settings.dailyGoal.xp,
              );
        }
        if (!context.mounted) return;
        context.pushReplacement('/lesson/${widget.unitId}/${widget.lessonId}/complete');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit(context);
        if (shouldExit && context.mounted) {
          context.read<LessonProvider>().endSession();
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
                context.read<LessonProvider>().endSession();
                context.pop();
              }
            },
          ),
          title: LessonProgressBar(
            progress: session.isIntro
                ? (session.introLexemes.isEmpty ? 1 : session.currentIndex / session.introLexemes.length)
                : (session.exercises.isEmpty ? 1 : session.currentIndex / session.exercises.length),
            heartsRemaining: session.heartsRemaining,
            showHearts: settings.useHearts,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: session.isIntro ? _buildIntro(context, session, locale) : _buildExercise(context, session, lessonProvider, locale, l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildIntro(BuildContext context, LessonSession session, String locale) {
    if (session.currentIndex >= session.introLexemes.length) {
      return const SizedBox.shrink();
    }
    final lexeme = session.introLexemes[session.currentIndex];
    final settings = context.read<SettingsProvider>().settings;
    final lessonProvider = context.read<LessonProvider>();
    final audioAvailable = context.read<AudioService>().isAmharicAvailable;
    return IntroCard(
      key: ValueKey('intro-${lexeme.id}'),
      lexeme: lexeme,
      locale: locale,
      showFidel: settings.fidelDisplayMode != FidelDisplayMode.never,
      onPlayAudio: audioAvailable ? () => lessonProvider.playIntroAudio() : null,
      onContinue: () => lessonProvider.nextIntroCard(),
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

    // Choice/build exercises have no naturally focused text input, so this
    // wrapper claims focus itself; typing exercises keep their own
    // autofocus text field instead (avoids fighting over focus).
    final claimsFocus = exercise.isChoiceBased || exercise.isBuildBased;

    return Focus(
      focusNode: _exerciseFocusNode,
      autofocus: claimsFocus,
      onKeyEvent: (node, event) => _handleExerciseKey(context, event, session, lessonProvider, exercise, locale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _buildExerciseBody(context, exercise, session, lessonProvider, locale),
            ),
          ),
          if (!session.answered) DontKnowLink(onPressed: () => _handleDontKnow(context, exercise, locale)),
          FeedbackBar(
            isCorrect: session.answered ? session.lastAnswerCorrect : null,
            isAlmost: session.lastAnswerAlmost,
            isSkipped: session.lastAnswerSkipped,
            correctAnswerText: exercise.correctAnswer,
            onContinue: () => _handleContinue(context, session),
          ),
        ],
      ),
    );
  }

  /// Abschnitt C10: 1-4/Enter/Escape/Space keyboard shortcuts - see the
  /// identical handler on `ExercisePlayer` (used by the other exercise
  /// screens) for why this is a second copy for now.
  KeyEventResult _handleExerciseKey(
    BuildContext context,
    KeyEvent event,
    LessonSession session,
    LessonProvider lessonProvider,
    GeneratedExercise exercise,
    String locale,
  ) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (session.answered) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _handleContinue(context, session);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _handleDontKnow(context, exercise, locale);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.space && exercise.isAudioPrompt) {
      lessonProvider.playCurrentAudio();
      return KeyEventResult.handled;
    }
    if (exercise.isChoiceBased) {
      final index = _lessonDigitKeys[event.logicalKey];
      if (index != null && index < exercise.options.length) {
        final value = _optionLabel(exercise.options[index], exercise, locale);
        setState(() => _selectedOption = value);
        lessonProvider.submitChoiceOrBuildAnswer(_originalFor(value, exercise, locale));
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
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
        key: ValueKey('pair-${session.currentIndex}'),
        pairs: exercise.pairs,
        onComplete: () => lessonProvider.submitPairMatchingComplete(),
      );
    }

    if (exercise.isChoiceBased) {
      return MultipleChoiceExercise(
        promptText: _promptFor(exercise, locale),
        options: exercise.options.map((o) => _optionLabel(o, exercise, locale)).toList(),
        correctAnswer: _optionLabel(exercise.correctAnswer, exercise, locale),
        selectedOption: _selectedOption,
        answered: session.answered,
        isAudioPrompt: exercise.isAudioPrompt,
        onPlayAudio: () => lessonProvider.playCurrentAudio(),
        onSelect: (value) {
          setState(() => _selectedOption = value);
          lessonProvider.submitChoiceOrBuildAnswer(_originalFor(value, exercise, locale));
        },
      );
    }

    if (exercise.isBuildBased) {
      return BuildChunksExercise(
        promptText: _promptFor(exercise, locale),
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
      promptText: _promptFor(exercise, locale),
      controller: _textController,
      answered: session.answered,
      isAudioPrompt: exercise.isAudioPrompt,
      onPlayAudio: () => lessonProvider.playCurrentAudio(),
      onSubmit: () => lessonProvider.submitTypedAnswer(_textController.text, locale),
    );
  }

  String _promptFor(GeneratedExercise exercise, String locale) {
    if (exercise.type == ExerciseType.trueFalse) {
      return exercise.promptText;
    }
    return exercise.promptText;
  }

  String _optionLabel(String option, GeneratedExercise exercise, String locale) {
    final l10n = AppLocalizations.of(context);
    if (exercise.type == ExerciseType.trueFalse) {
      return option == 'true' ? l10n.exerciseTrue : l10n.exerciseFalse;
    }
    return option;
  }

  String _originalFor(String label, GeneratedExercise exercise, String locale) {
    if (exercise.type == ExerciseType.trueFalse) {
      final l10n = AppLocalizations.of(context);
      return label == l10n.exerciseTrue ? 'true' : 'false';
    }
    return label;
  }

  void _handleDontKnow(BuildContext context, GeneratedExercise exercise, String locale) {
    context.read<LessonProvider>().skipCurrentExercise();
  }

  void _handleContinue(BuildContext context, LessonSession session) {
    setState(() {
      final next = session.isIntro ? null : _peekNextExercise(session);
      _resetLocalState(next);
    });
    if (session.isIntro) {
      context.read<LessonProvider>().nextIntroCard();
    } else {
      context.read<LessonProvider>().nextExercise();
    }
  }

  GeneratedExercise? _peekNextExercise(LessonSession session) {
    final nextIndex = session.currentIndex + 1;
    return nextIndex < session.exercises.length ? session.exercises[nextIndex] : null;
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
