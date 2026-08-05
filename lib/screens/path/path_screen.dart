import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/curriculum.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/empty_state.dart';

enum _UnitState { completed, skipped, current, locked }

class PathScreen extends StatelessWidget {
  const PathScreen({super.key});

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

    final curriculum = contentProvider.repository.curriculum;
    if (contentProvider.state == ContentLoadState.error || curriculum.sections.isEmpty) {
      return EmptyState(icon: Icons.error_outline, title: l10n.errorGenericTitle, body: l10n.errorContentUnit);
    }

    final flatUnitIds = [for (final s in curriculum.sections) ...s.unitIds];

    bool isUnitDone(String unitId) {
      final lessons = contentProvider.repository.lessonsForUnit(unitId);
      if (lessons.isEmpty) return false;
      return lessons.every((l) => progressProvider.progress.lessonProgress[l.id]?.completed == true);
    }

    bool isUnitSkipped(String unitId) => progressProvider.progress.skippedUnitIds.contains(unitId);

    _UnitState stateFor(int flatIndex) {
      final unitId = flatUnitIds[flatIndex];
      if (isUnitDone(unitId)) return _UnitState.completed;
      if (isUnitSkipped(unitId)) return _UnitState.skipped;
      if (settings.allLessonsUnlocked || flatIndex == 0) return _UnitState.current;
      final previousId = flatUnitIds[flatIndex - 1];
      if (isUnitDone(previousId) || isUnitSkipped(previousId)) return _UnitState.current;
      return _UnitState.locked;
    }

    var runningIndex = 0;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        for (final section in curriculum.sections) ...[
          _SectionHeader(section: section, locale: locale, contentProvider: contentProvider, progressProvider: progressProvider),
          for (final unitId in section.unitIds)
            _UnitTile(
              unit: contentProvider.repository.unit(unitId)!,
              locale: locale,
              state: stateFor(runningIndex++),
            ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final CurriculumSection section;
  final String locale;
  final ContentProvider contentProvider;
  final ProgressProvider progressProvider;

  const _SectionHeader({
    required this.section,
    required this.locale,
    required this.contentProvider,
    required this.progressProvider,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final done = section.unitIds.where((id) {
      final lessons = contentProvider.repository.lessonsForUnit(id);
      return lessons.isNotEmpty && lessons.every((l) => progressProvider.progress.lessonProgress[l.id]?.completed == true);
    }).length;

    final sectionIndex = contentProvider.repository.curriculum.sections.indexOf(section) + 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pathSectionProgress(sectionIndex, section.title[locale] ?? section.id, done, section.unitIds.length),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: section.unitIds.isEmpty ? 0 : done / section.unitIds.length, minHeight: 6),
          ),
        ],
      ),
    );
  }
}

class _UnitTile extends StatelessWidget {
  final CurriculumUnit unit;
  final String locale;
  final _UnitState state;

  const _UnitTile({required this.unit, required this.locale, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    late final Widget icon;
    late final Color borderColor;
    switch (state) {
      case _UnitState.completed:
        icon = const Icon(Icons.check_circle, color: successColor);
        borderColor = successColor;
        break;
      case _UnitState.skipped:
        icon = const Icon(Icons.fast_forward, color: successColor);
        borderColor = successColor;
        break;
      case _UnitState.current:
        icon = Icon(Icons.play_circle_fill, color: theme.colorScheme.primary);
        borderColor = theme.colorScheme.primary;
        break;
      case _UnitState.locked:
        icon = Icon(Icons.lock, color: theme.colorScheme.outline);
        borderColor = theme.colorScheme.outlineVariant;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Material(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _onTap(context, l10n),
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: state == _UnitState.skipped ? 1.5 : 0),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 16),
                Expanded(child: Text(unit.title[locale] ?? unit.id, style: theme.textTheme.titleMedium)),
                if (state == _UnitState.skipped)
                  Text(l10n.pathSkipped, style: theme.textTheme.labelSmall)
                else if (state == _UnitState.locked)
                  Text(l10n.pathLocked, style: theme.textTheme.labelSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, AppLocalizations l10n) {
    if (state != _UnitState.locked) {
      context.push('/learn/unit/${unit.id}');
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.pathLockedDialogTitle),
        content: Text(l10n.pathLockedDialogBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.pathLockedDialogLater)),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.push('/learn/unit/${unit.id}');
            },
            child: Text(l10n.pathLockedDialogStart),
          ),
        ],
      ),
    );
  }
}
