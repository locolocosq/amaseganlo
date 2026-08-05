import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/exercise.dart';
import '../../state/lesson_provider.dart';
import 'dont_know_link.dart';
import 'feedback_bar.dart';
import '../exercises/build_chunks_exercise.dart';
import '../exercises/multiple_choice_exercise.dart';
import '../exercises/pair_matching_exercise.dart';
import '../exercises/typing_exercise.dart';

/// The exercise-answer loop shared by every ad-hoc session screen
/// (Wiederholung, Kapitel-Test): renders the current exercise, tracks its
/// own local answer-in-progress state (typed text, selected option, chunk
/// order), and advances the session on "Weiter". Callers own everything
/// around this - the app bar/progress header and what happens once the
/// session finishes.
///
/// [LessonScreen] keeps its own copy of this loop for now (it additionally
/// handles intro cards and true/false label mapping) - see ENTSCHEIDUNGEN.md
/// Etappe 9 for why unifying all three is deferred to the Etappe 11 cleanup
/// pass instead of risking its already-tested behavior mid-etappe.
class ExercisePlayer extends StatefulWidget {
  final LessonSession session;
  final String locale;
  final String keyPrefix;

  const ExercisePlayer({
    super.key,
    required this.session,
    required this.locale,
    this.keyPrefix = 'exercise',
  });

  @override
  State<ExercisePlayer> createState() => _ExercisePlayerState();
}

class _ExercisePlayerState extends State<ExercisePlayer> {
  String? _selectedOption;
  final TextEditingController _textController = TextEditingController();
  List<String> _selectedChunks = [];
  List<String> _availableChunks = [];

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
    final session = widget.session;
    final exercise = session.currentExercise;
    if (exercise == null) return const SizedBox.shrink();

    if (_availableChunks.isEmpty &&
        exercise.isBuildBased &&
        _selectedChunks.isEmpty &&
        !session.answered) {
      _availableChunks = List.of(exercise.chunks);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: _buildExerciseBody(exercise, session, lessonProvider),
          ),
        ),
        if (!session.answered)
          DontKnowLink(onPressed: () => lessonProvider.skipCurrentExercise()),
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
    GeneratedExercise exercise,
    LessonSession session,
    LessonProvider lessonProvider,
  ) {
    if (exercise.isPairBased) {
      return PairMatchingExercise(
        key: ValueKey('${widget.keyPrefix}-pair-${session.currentIndex}'),
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
        onSubmit: () =>
            lessonProvider.submitChoiceOrBuildAnswer(_selectedChunks.join(' ')),
      );
    }

    return TypingExercise(
      promptText: exercise.promptText,
      controller: _textController,
      answered: session.answered,
      isAudioPrompt: exercise.isAudioPrompt,
      onPlayAudio: () => lessonProvider.playCurrentAudio(),
      onSubmit: () =>
          lessonProvider.submitTypedAnswer(_textController.text, widget.locale),
    );
  }

  void _handleContinue(LessonSession session, LessonProvider lessonProvider) {
    setState(() {
      final nextIndex = session.currentIndex + 1;
      final next = nextIndex < session.exercises.length
          ? session.exercises[nextIndex]
          : null;
      _resetLocalState(next);
    });
    lessonProvider.nextExercise();
  }
}
