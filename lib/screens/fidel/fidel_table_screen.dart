import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
            child: InteractiveViewer(
              transformationController: _transformController,
              minScale: 0.5,
              maxScale: 3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Table(
                    defaultColumnWidth: const FixedColumnWidth(56),
                    children: [
                      TableRow(children: [
                        const SizedBox(),
                        for (var order = 1; order <= 7; order++)
                          Center(child: Text('$order', style: Theme.of(context).textTheme.labelLarge)),
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
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, FidelChar c, bool learned) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
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
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/fidel/table/practice/${c.group}');
              },
              child: Text(l10n.fidelTableStudyRow),
            ),
          ],
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
