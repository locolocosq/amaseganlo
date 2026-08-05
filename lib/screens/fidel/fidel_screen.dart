import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/empty_state.dart';

enum _StageState { completed, current, locked }

class FidelScreen extends StatelessWidget {
  const FidelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contentProvider = context.watch<ContentProvider>();
    final progressProvider = context.watch<ProgressProvider>();
    final settings = context.watch<SettingsProvider>().settings;
    final locale = settings.localeCode ?? Localizations.localeOf(context).languageCode;

    if (contentProvider.state == ContentLoadState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final stages = contentProvider.repository.fidelStages;
    if (stages.isEmpty) {
      return EmptyState(icon: Icons.abc_outlined, title: l10n.errorContentUnit);
    }

    bool isStageDone(String stageId) {
      final lessons = contentProvider.repository.fidelLessonsForStage(stageId);
      if (lessons.isEmpty) return false;
      return lessons.every((l) => progressProvider.progress.lessonProgress[l.id]?.completed == true);
    }

    _StageState stateFor(int index) {
      final stage = stages[index];
      if (isStageDone(stage.id)) return _StageState.completed;
      if (settings.allLessonsUnlocked || index == 0) return _StageState.current;
      if (isStageDone(stages[index - 1].id)) return _StageState.current;
      return _StageState.locked;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            children: [
              Expanded(child: Text(l10n.fidelHomeTitle, style: Theme.of(context).textTheme.titleLarge)),
              TextButton.icon(
                onPressed: () => context.push('/fidel/table'),
                icon: const Icon(Icons.grid_on),
                label: Text(l10n.fidelTableTitle),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: stages.length,
            itemBuilder: (context, index) {
              final stage = stages[index];
              return _StageTile(
                title: stage.title[locale] ?? stage.id,
                number: stage.number,
                isBonus: stage.isBonus,
                state: stateFor(index),
                comingSoon: contentProvider.repository.fidelLessonsForStage(stage.id).isEmpty,
                onTap: () => context.push('/fidel/stage/${stage.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StageTile extends StatelessWidget {
  final String title;
  final int number;
  final bool isBonus;
  final bool comingSoon;
  final _StageState state;
  final VoidCallback onTap;

  const _StageTile({
    required this.title,
    required this.number,
    required this.isBonus,
    required this.comingSoon,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    late final Widget icon;
    switch (state) {
      case _StageState.completed:
        icon = const Icon(Icons.check_circle, color: successColor);
        break;
      case _StageState.current:
        icon = Icon(Icons.play_circle_fill, color: theme.colorScheme.primary);
        break;
      case _StageState.locked:
        icon = Icon(Icons.lock, color: theme.colorScheme.outline);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Material(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: comingSoon ? null : () => _handleTap(context, l10n),
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 16),
                Expanded(child: Text(l10n.fidelStageProgress(number, title), style: theme.textTheme.titleMedium)),
                if (comingSoon)
                  Text(l10n.fidelStageComingSoon, style: theme.textTheme.labelSmall)
                else if (isBonus)
                  Text(l10n.fidelStageBonus, style: theme.textTheme.labelSmall)
                else if (state == _StageState.locked)
                  Text(l10n.pathLocked, style: theme.textTheme.labelSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, AppLocalizations l10n) {
    if (state != _StageState.locked) {
      onTap();
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.fidelLockedDialogTitle),
        content: Text(l10n.fidelLockedDialogBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.pathLockedDialogLater)),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onTap();
            },
            child: Text(l10n.pathLockedDialogStart),
          ),
        ],
      ),
    );
  }
}
