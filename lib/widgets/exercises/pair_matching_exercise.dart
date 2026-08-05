import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/exercise.dart';

/// Two shuffled columns of 5 words each; tap one from each side to match
/// them. A mismatch just bounces back - there is no wrong answer here, so
/// this exercise is scored as a whole once every pair is matched.
class PairMatchingExercise extends StatefulWidget {
  final List<MatchPair> pairs;
  final VoidCallback onComplete;

  const PairMatchingExercise({super.key, required this.pairs, required this.onComplete});

  @override
  State<PairMatchingExercise> createState() => _PairMatchingExerciseState();
}

class _PairMatchingExerciseState extends State<PairMatchingExercise> {
  late List<MatchPair> _left;
  late List<MatchPair> _right;
  String? _selectedLeftId;
  String? _selectedRightId;
  String? _flashWrongLeftId;
  String? _flashWrongRightId;
  final Set<String> _matchedIds = {};
  bool _completedFired = false;

  @override
  void initState() {
    super.initState();
    _left = List.of(widget.pairs)..shuffle();
    _right = List.of(widget.pairs)..shuffle();
  }

  void _tapLeft(MatchPair pair) {
    if (_matchedIds.contains(pair.id)) return;
    setState(() => _selectedLeftId = pair.id);
    _tryMatch();
  }

  void _tapRight(MatchPair pair) {
    if (_matchedIds.contains(pair.id)) return;
    setState(() => _selectedRightId = pair.id);
    _tryMatch();
  }

  void _tryMatch() {
    if (_selectedLeftId == null || _selectedRightId == null) return;
    if (_selectedLeftId == _selectedRightId) {
      setState(() {
        _matchedIds.add(_selectedLeftId!);
        _selectedLeftId = null;
        _selectedRightId = null;
      });
      if (_matchedIds.length == widget.pairs.length && !_completedFired) {
        _completedFired = true;
        widget.onComplete();
      }
    } else {
      final wrongLeft = _selectedLeftId;
      final wrongRight = _selectedRightId;
      setState(() {
        _flashWrongLeftId = wrongLeft;
        _flashWrongRightId = wrongRight;
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        setState(() {
          _selectedLeftId = null;
          _selectedRightId = null;
          _flashWrongLeftId = null;
          _flashWrongRightId = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(l10n.exercisePairMatchingHint, textAlign: TextAlign.center),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Column(children: [for (final p in _left) _tile(p, isLeft: true)])),
            const SizedBox(width: 12),
            Expanded(child: Column(children: [for (final p in _right) _tile(p, isLeft: false)])),
          ],
        ),
      ],
    );
  }

  Widget _tile(MatchPair pair, {required bool isLeft}) {
    final matched = _matchedIds.contains(pair.id);
    final selected = isLeft ? _selectedLeftId == pair.id : _selectedRightId == pair.id;
    final wrong = isLeft ? _flashWrongLeftId == pair.id : _flashWrongRightId == pair.id;

    Color borderColor = Theme.of(context).colorScheme.outlineVariant;
    Color? fillColor;
    if (matched) {
      borderColor = successColor;
      fillColor = successColor.withValues(alpha: 0.15);
    } else if (wrong) {
      borderColor = errorColor;
      fillColor = errorColor.withValues(alpha: 0.12);
    } else if (selected) {
      borderColor = Theme.of(context).colorScheme.primary;
      fillColor = Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: fillColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: matched ? null : () => isLeft ? _tapLeft(pair) : _tapRight(pair),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(border: Border.all(color: borderColor, width: 2), borderRadius: BorderRadius.circular(14)),
            child: Text(
              isLeft ? pair.left : pair.right,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
