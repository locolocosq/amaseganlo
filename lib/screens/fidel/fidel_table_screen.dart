import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/audio_service.dart';
import '../../l10n/app_localizations.dart';
import '../../models/fidel_char.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';

enum _TableFilter { all, learned, open }

class FidelTableScreen extends StatefulWidget {
  const FidelTableScreen({super.key});

  @override
  State<FidelTableScreen> createState() => _FidelTableScreenState();
}

class _FidelTableScreenState extends State<FidelTableScreen> {
  _TableFilter _filter = _TableFilter.all;
  final TransformationController _transformController = TransformationController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = context.watch<ContentProvider>().repository;
    final progress = context.watch<ProgressProvider>();

    final groups = repo.fidelGroupsInOrder;
    // Etappe 24: column headers show how each order actually sounds (using
    // the well-known "ha" row as the reference), not the bare order number
    // - "1,2,3..." meant nothing to a learner who hasn't memorized which
    // number is which vowel yet, but "he/hu/hi/ha/he/h/ho" is immediately
    // useful even before opening a single lesson.
    final referenceOrder = repo.fidelCharsForGroup('ha');

    bool isLearned(FidelChar c) => progress.progress.fidelCards.containsKey(c.char);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), tooltip: l10n.commonBack, onPressed: () => context.pop()),
        title: Text(l10n.fidelTableTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<_TableFilter>(
              segments: [
                ButtonSegment(value: _TableFilter.all, label: Text(l10n.fidelTableFilterAll)),
                ButtonSegment(value: _TableFilter.learned, label: Text(l10n.fidelTableFilterLearned)),
                ButtonSegment(value: _TableFilter.open, label: Text(l10n.fidelTableFilterOpen)),
              ],
              selected: {_filter},
              onSelectionChanged: (s) => setState(() => _filter = s.first),
            ),
          ),
          Expanded(
            // A bare InteractiveViewer already pans freely in both directions
            // (plus pinch-zoom) - nesting a horizontal-only SingleChildScrollView
            // inside it used to compete with it for vertical drag gestures, which
            // is what made the last row(s) unreachable (reported: "kann nicht
            // runter scrollen"). Removing that inner ScrollView lets
            // InteractiveViewer's own pan handle every direction.
            // `constrained: false` is the other half of that fix: with the
            // (default) `true`, InteractiveViewer forces its child to fit the
            // viewport, so a table taller than the screen was silently
            // shrunk/clipped to the viewport's height instead of being pannable
            // past it - `false` lets the table be its own full natural size and
            // makes InteractiveViewer act purely as the pannable viewport over it.
            child: InteractiveViewer(
              transformationController: _transformController,
              constrained: false,
              minScale: 0.5,
              maxScale: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Table(
                  defaultColumnWidth: const FixedColumnWidth(56),
                  children: [
                    TableRow(children: [
                      const SizedBox(),
                      for (final ref in referenceOrder)
                        Center(child: Text(ref.tr, style: Theme.of(context).textTheme.labelLarge)),
                    ]),
                    for (final group in groups)
                      TableRow(children: [
                        Center(child: Text(repo.fidelCharsForGroup(group).first.base, style: Theme.of(context).textTheme.labelLarge)),
                        for (final c in repo.fidelCharsForGroup(group))
                          _FidelCell(
                            char: c,
                            learned: isLearned(c),
                            visible: switch (_filter) {
                              _TableFilter.all => true,
                              _TableFilter.learned => isLearned(c),
                              _TableFilter.open => !isLearned(c),
                            },
                            onTap: () => _showDetail(context, c, isLearned(c)),
                          ),
                      ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, FidelChar c, bool learned) {
    final l10n = AppLocalizations.of(context);
    final audioService = context.read<AudioService>();
    final audioAvailable = audioService.isAmharicAvailable;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(c.char, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 12),
              Text('${c.tr} · ${c.ipa}', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Ordnung ${c.order} · ${c.group}'),
              const SizedBox(height: 8),
              Text(learned ? l10n.fidelTableDetailLearned : l10n.fidelTableDetailNotLearned),
              const SizedBox(height: 16),
              if (audioAvailable)
                IconButton.filledTonal(
                  iconSize: 28,
                  tooltip: l10n.audioPlayTooltip,
                  onPressed: () => audioService.speakText(id: c.audioId, amharicText: c.char),
                  icon: const Icon(Icons.volume_up),
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/fidel/table/practice/${c.group}');
                },
                child: Text(l10n.fidelTableStudyRow),
              ),
              if (audioAvailable) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/fidel/table/audio-drill/${c.group}');
                  },
                  child: Text(l10n.fidelAudioDrillRowButton),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FidelCell extends StatelessWidget {
  final FidelChar char;
  final bool learned;
  final bool visible;
  final VoidCallback onTap;

  const _FidelCell({required this.char, required this.learned, required this.visible, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        child: Text(
          char.char,
          style: TextStyle(
            fontSize: 26,
            color: !visible
                ? Colors.transparent
                : learned
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}
