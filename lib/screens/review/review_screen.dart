import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../content/content_repository.dart';
import '../../core/plural.dart';
import '../../l10n/app_localizations.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';

const int _maxReviewSessionSize = 20;

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = context.watch<ProgressProvider>();
    final content = context.watch<ContentProvider>().repository;

    final dueIds = progress.dueLexemeIds(DateTime.now());
    final difficultIds = progress.difficultLexemeIds();
    final learnedIds = progress.learnedLexemeIds();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _ReviewTile(
          icon: Icons.event_available_outlined,
          title: l10n.reviewDueToday,
          subtitle: wordCountLabel(l10n, dueIds.length),
          enabled: dueIds.isNotEmpty,
          onTap: () => _startSession(context, dueIds),
        ),
        const SizedBox(height: 12),
        _ReviewTile(
          icon: Icons.priority_high_outlined,
          title: l10n.reviewDifficultWords,
          subtitle: wordCountLabel(l10n, difficultIds.length),
          enabled: difficultIds.isNotEmpty,
          onTap: () => _startSession(context, difficultIds),
        ),
        const SizedBox(height: 12),
        _ReviewTile(
          icon: Icons.shuffle_outlined,
          title: l10n.reviewFreePractice,
          subtitle: wordCountLabel(l10n, learnedIds.length),
          enabled: learnedIds.isNotEmpty,
          onTap: () => _openFreePractice(context, learnedIds, content),
        ),
        const SizedBox(height: 12),
        _ReviewTile(
          icon: Icons.menu_book_outlined,
          title: l10n.dictionaryTitle,
          subtitle: wordCountLabel(l10n, learnedIds.length),
          enabled: true,
          onTap: () => context.push('/review/dictionary'),
        ),
        if (dueIds.isEmpty && difficultIds.isEmpty) ...[
          const SizedBox(height: 24),
          Center(
            child: Text(
              l10n.reviewEmpty,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  void _startSession(BuildContext context, List<String> ids) {
    if (ids.isEmpty) return;
    final shuffled = List<String>.from(ids)..shuffle();
    context.push('/review/session', extra: shuffled.take(_maxReviewSessionSize).toList());
  }

  void _openFreePractice(BuildContext context, List<String> learnedIds, ContentRepository content) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => _FreePracticeSheet(learnedIds: learnedIds, content: content),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onTap;

  const _ReviewTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: enabled ? onTap : null,
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: enabled ? theme.colorScheme.primary : theme.colorScheme.outline),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _FreePracticeSheet extends StatefulWidget {
  final List<String> learnedIds;
  final ContentRepository content;

  const _FreePracticeSheet({required this.learnedIds, required this.content});

  @override
  State<_FreePracticeSheet> createState() => _FreePracticeSheetState();
}

class _FreePracticeSheetState extends State<_FreePracticeSheet> {
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final levels = <String>{};
    for (final id in widget.learnedIds) {
      final level = widget.content.lexeme(id)?.level;
      if (level != null && level.isNotEmpty) levels.add(level);
    }
    final sortedLevels = levels.toList()..sort();

    final matching = _selectedLevel == null
        ? widget.learnedIds
        : widget.learnedIds.where((id) => widget.content.lexeme(id)?.level == _selectedLevel).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.reviewFreePracticeChooseLevel, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.reviewFreePracticeAllLevels),
                  selected: _selectedLevel == null,
                  onSelected: (_) => setState(() => _selectedLevel = null),
                ),
                for (final level in sortedLevels)
                  ChoiceChip(
                    label: Text(level),
                    selected: _selectedLevel == level,
                    onSelected: (_) => setState(() => _selectedLevel = level),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: matching.isEmpty
                    ? null
                    : () {
                        final shuffled = List<String>.from(matching)..shuffle();
                        Navigator.of(context).pop();
                        context.push('/review/session', extra: shuffled.take(_maxReviewSessionSize).toList());
                      },
                child: Text(matching.isEmpty ? l10n.reviewNoWordsForSession : l10n.reviewStart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
