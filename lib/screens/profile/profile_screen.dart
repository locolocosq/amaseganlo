import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/badges.dart';
import '../../l10n/app_localizations.dart';
import '../../state/progress_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = context.watch<ProgressProvider>();
    final p = progress.progress;
    final earned = BadgeCatalog.earnedBadges(p).toSet();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _StatsGrid(
          stats: [
            _Stat(l10n.profileWordsLearned, '${progress.wordsLearned}', Icons.menu_book_outlined),
            _Stat(l10n.profileWordsMastered, '${progress.wordsMastered}', Icons.stars_outlined),
            _Stat(l10n.profileFidelChars, '${progress.fidelCharsLearned}', Icons.abc),
            _Stat(l10n.profileTotalXp, '${p.xpTotal}', Icons.bolt_outlined),
            _Stat(l10n.profileCurrentStreak, '${p.currentStreak}', Icons.local_fire_department_outlined),
            _Stat(l10n.profileLongestStreak, '${p.longestStreak}', Icons.emoji_events_outlined),
            _Stat(l10n.profileDaysLearned, '${progress.daysLearned}', Icons.calendar_month_outlined),
            _Stat(l10n.profileAccuracy, '${(progress.overallAccuracy * 100).round()}%', Icons.track_changes_outlined),
          ],
        ),
        const SizedBox(height: 24),
        Text(l10n.profileLast7Days, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        _LastDaysChart(xp: progress.xpForLastDays(7, DateTime.now())),
        const SizedBox(height: 24),
        Text(l10n.profileBadges, style: Theme.of(context).textTheme.titleMedium),
        if (earned.isEmpty) ...[
          const SizedBox(height: 8),
          Text(
            l10n.profileBadgesEmpty,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final id in BadgeId.values) _BadgeChip(id: id, earned: earned.contains(id)),
          ],
        ),
      ],
    );
  }
}

class _Stat {
  final String label;
  final String value;
  final IconData icon;
  const _Stat(this.label, this.value, this.icon);
}

class _StatsGrid extends StatelessWidget {
  final List<_Stat> stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.4,
      children: [for (final s in stats) _StatCard(stat: s)],
    );
  }
}

class _StatCard extends StatelessWidget {
  final _Stat stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(stat.icon, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stat.value, style: theme.textTheme.titleLarge),
                  Text(
                    stat.label,
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastDaysChart extends StatelessWidget {
  final List<int> xp;
  const _LastDaysChart({required this.xp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxXp = xp.fold(0, (m, v) => v > m ? v : m);
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final value in xp)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Semantics(
                  label: '$value XP',
                  child: Container(
                    height: maxXp == 0 ? 4 : (4 + (value / maxXp) * 60),
                    decoration: BoxDecoration(
                      color: value > 0 ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final BadgeId id;
  final bool earned;

  const _BadgeChip({required this.id, required this.earned});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final color = earned ? theme.colorScheme.primary : theme.colorScheme.outline;

    return Tooltip(
      message: _descFor(id, l10n),
      child: SizedBox(
        width: 96,
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: earned ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
              child: Icon(_iconFor(id), color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              _nameFor(id, l10n),
              style: theme.textTheme.labelSmall?.copyWith(color: earned ? theme.colorScheme.onSurface : theme.colorScheme.outline),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(BadgeId id) {
    switch (id) {
      case BadgeId.firstLesson:
        return Icons.flag_outlined;
      case BadgeId.streak7:
        return Icons.local_fire_department_outlined;
      case BadgeId.streak30:
        return Icons.local_fire_department;
      case BadgeId.words100:
        return Icons.menu_book_outlined;
      case BadgeId.words500:
        return Icons.auto_stories_outlined;
      case BadgeId.fidelMaster:
        return Icons.abc;
      case BadgeId.xp1000:
        return Icons.bolt_outlined;
      case BadgeId.firstCrown:
        return Icons.emoji_events_outlined;
    }
  }

  String _nameFor(BadgeId id, AppLocalizations l10n) {
    switch (id) {
      case BadgeId.firstLesson:
        return l10n.profileBadgeFirstLessonName;
      case BadgeId.streak7:
        return l10n.profileBadgeStreak7Name;
      case BadgeId.streak30:
        return l10n.profileBadgeStreak30Name;
      case BadgeId.words100:
        return l10n.profileBadgeWords100Name;
      case BadgeId.words500:
        return l10n.profileBadgeWords500Name;
      case BadgeId.fidelMaster:
        return l10n.profileBadgeFidelMasterName;
      case BadgeId.xp1000:
        return l10n.profileBadgeXp1000Name;
      case BadgeId.firstCrown:
        return l10n.profileBadgeFirstCrownName;
    }
  }

  String _descFor(BadgeId id, AppLocalizations l10n) {
    switch (id) {
      case BadgeId.firstLesson:
        return l10n.profileBadgeFirstLessonDesc;
      case BadgeId.streak7:
        return l10n.profileBadgeStreak7Desc;
      case BadgeId.streak30:
        return l10n.profileBadgeStreak30Desc;
      case BadgeId.words100:
        return l10n.profileBadgeWords100Desc;
      case BadgeId.words500:
        return l10n.profileBadgeWords500Desc;
      case BadgeId.fidelMaster:
        return l10n.profileBadgeFidelMasterDesc;
      case BadgeId.xp1000:
        return l10n.profileBadgeXp1000Desc;
      case BadgeId.firstCrown:
        return l10n.profileBadgeFirstCrownDesc;
    }
  }
}
