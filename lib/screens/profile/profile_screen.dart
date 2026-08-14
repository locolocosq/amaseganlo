import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../content/content_repository.dart';
import '../../core/badges.dart';
import '../../core/journey_regions.dart';
import '../../core/purchase_service.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/curriculum.dart';
import '../../models/user_progress.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = context.watch<ProgressProvider>();
    final content = context.watch<ContentProvider>().repository;
    final settings = context.watch<SettingsProvider>().settings;
    final isPremium = context.watch<PurchaseService>().isPremium;
    final locale =
        settings.localeCode ?? Localizations.localeOf(context).languageCode;
    final p = progress.progress;
    final earned = BadgeCatalog.earnedBadges(p).toSet();
    final skippedUnitIds = p.skippedUnitIds.toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        OutlinedButton.icon(
          onPressed: () => context.push('/placement-test'),
          icon: const Icon(Icons.assignment_outlined),
          label: Text(l10n.profileAssessmentTest),
        ),
        const SizedBox(height: 24),
        Container(
          padding: isPremium ? const EdgeInsets.all(12) : EdgeInsets.zero,
          decoration: isPremium
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD4A017), width: 1.5),
                  gradient: LinearGradient(
                    colors: [const Color(0xFFD4A017).withValues(alpha: 0.10), Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(l10n.profilePassportTitle, style: Theme.of(context).textTheme.titleMedium),
                  if (isPremium) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.workspace_premium, size: 18, color: Color(0xFFD4A017)),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.profilePassportHint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              _PassportRow(content: content, progress: p, locale: locale),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _StatsGrid(
          stats: [
            _Stat(
              l10n.profileWordsLearned,
              '${progress.wordsLearned}',
              Icons.menu_book_outlined,
            ),
            _Stat(
              l10n.profileWordsMastered,
              '${progress.wordsMastered}',
              Icons.stars_outlined,
            ),
            _Stat(
              l10n.profileFidelChars,
              '${progress.fidelCharsLearned}',
              Icons.abc,
            ),
            _Stat(l10n.profileTotalXp, '${p.xpTotal}', Icons.bolt_outlined),
            _Stat(
              l10n.profileCurrentStreak,
              '${p.currentStreak}',
              Icons.local_fire_department_outlined,
            ),
            _Stat(
              l10n.profileLongestStreak,
              '${p.longestStreak}',
              Icons.emoji_events_outlined,
            ),
            _Stat(
              l10n.profileDaysLearned,
              '${progress.daysLearned}',
              Icons.calendar_month_outlined,
            ),
            _Stat(
              l10n.profileAccuracy,
              '${(progress.overallAccuracy * 100).round()}%',
              Icons.track_changes_outlined,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          l10n.profileLast7Days,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        _LastDaysChart(xp: progress.xpForLastDays(7, DateTime.now())),
        const SizedBox(height: 24),
        Text(
          l10n.profileBadges,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (earned.isEmpty) ...[
          const SizedBox(height: 8),
          Text(
            l10n.profileBadgesEmpty,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final id in BadgeId.values)
              _BadgeChip(id: id, earned: earned.contains(id)),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          l10n.profileSkippedUnits,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (skippedUnitIds.isEmpty)
          Text(
            l10n.profileSkippedUnitsEmpty,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final unitId in skippedUnitIds)
            _SkippedUnitTile(
              title: content.unit(unitId)?.title[locale] ?? unitId,
              onCatchUp: () => context.push('/learn/unit/$unitId'),
              label: l10n.profileCatchUp,
            ),
      ],
    );
  }
}

class _SkippedUnitTile extends StatelessWidget {
  final String title;
  final String label;
  final VoidCallback onCatchUp;

  const _SkippedUnitTile({
    required this.title,
    required this.label,
    required this.onCatchUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          leading: const Icon(Icons.fast_forward),
          title: Text(title),
          trailing: TextButton(onPressed: onCatchUp, child: Text(label)),
        ),
      ),
    );
  }
}

/// The "Reisepass" (Abschnitt Design): one stamp per Äthiopien-Reise stop
/// (curriculum section), filled in once every unit in that section is
/// completed or skipped - computed live from progress, the same "no extra
/// persisted state" approach as `BadgeCatalog`.
class _PassportRow extends StatelessWidget {
  final ContentRepository content;
  final UserProgress progress;
  final String locale;

  const _PassportRow({required this.content, required this.progress, required this.locale});

  @override
  Widget build(BuildContext context) {
    final sections = content.curriculum.sections;
    return Row(
      children: [
        for (final section in sections) ...[
          Expanded(child: _PassportStamp(section: section, earned: _isSectionDone(section), locale: locale)),
          if (section != sections.last) const SizedBox(width: 8),
        ],
      ],
    );
  }

  bool _isSectionDone(CurriculumSection section) {
    if (section.unitIds.isEmpty) return false;
    return section.unitIds.every((id) {
      final lessons = content.lessonsForUnit(id);
      final done = lessons.isNotEmpty && lessons.every((l) => progress.lessonProgress[l.id]?.completed == true);
      return done || progress.skippedUnitIds.contains(id);
    });
  }
}

class _PassportStamp extends StatelessWidget {
  final CurriculumSection section;
  final bool earned;
  final String locale;

  const _PassportStamp({required this.section, required this.earned, required this.locale});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final region = journeyRegionFromId(section.region);
    final color = earned ? _stampColor(region) : theme.colorScheme.outline;
    // Just the place name under the stamp (Etappe 24 Nachtrag) - the full
    // curriculum section title ("Station 1: Addis Abeba — die
    // Hauptstadt-Ankunft") used to run here and didn't fit under a 56px
    // stamp. Falls back to the section's own title only if `region` can't
    // be resolved, which shouldn't happen for a well-formed section.
    final placeName = region != null ? journeyRegionShortLabel(region, l10n) : (section.title[locale] ?? section.id);

    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.5),
            color: earned ? color.withValues(alpha: 0.12) : Colors.transparent,
          ),
          child: Icon(_iconFor(region), color: color, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          placeName,
          style: theme.textTheme.labelSmall?.copyWith(color: earned ? theme.colorScheme.onSurface : theme.colorScheme.outline),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Color _stampColor(JourneyRegion? region) {
    switch (region) {
      case JourneyRegion.addisAbeba:
        return const Color(0xFF6B7A99);
      case JourneyRegion.oromia:
        return const Color(0xFF4A7C43);
      case JourneyRegion.tigray:
        return const Color(0xFF8C6E56);
      case JourneyRegion.sidama:
        return const Color(0xFF3F8FA6);
      case JourneyRegion.harar:
        return const Color(0xFFC9A227);
      case JourneyRegion.safari:
        return const Color(0xFFD9662D);
      case null:
        return successColor;
    }
  }

  IconData _iconFor(JourneyRegion? region) {
    switch (region) {
      case JourneyRegion.addisAbeba:
        return Icons.location_city;
      case JourneyRegion.oromia:
        return Icons.landscape;
      case JourneyRegion.tigray:
        return Icons.account_balance;
      case JourneyRegion.sidama:
        return Icons.water;
      case JourneyRegion.harar:
        return Icons.mosque;
      case JourneyRegion.safari:
        return Icons.wb_twilight;
      case null:
        return Icons.flag_outlined;
    }
  }
}

class _Stat {
  final String label;
  final String value;
  final IconData icon;
  const _Stat(this.label, this.value, this.icon);
}

/// A two-column grid of stat cards (Abschnitt Design) - deliberately built
/// on [Wrap] + a measured half-width instead of `GridView.count`'s fixed
/// `childAspectRatio`: a fixed aspect ratio hands each card a fixed pixel
/// height, and a 2-line label at a larger accessibility font size (see
/// `font_size_setting_test.dart`) could then need more height than that
/// box had - exactly the "RenderFlex overflowed by 11 pixels" bug a real
/// device hit. Sizing each card by its own content instead means no text
/// size can ever overflow it again.
class _StatsGrid extends StatelessWidget {
  final List<_Stat> stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final cardWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          key: const ValueKey('profileStatsGrid'),
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final s in stats) SizedBox(width: cardWidth, child: _StatCard(stat: s)),
          ],
        );
      },
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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
                      color: value > 0
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
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
    final color = earned
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;

    return Tooltip(
      message: _descFor(id, l10n),
      child: SizedBox(
        width: 96,
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: earned
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              child: Icon(_iconFor(id), color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              _nameFor(id, l10n),
              style: theme.textTheme.labelSmall?.copyWith(
                color: earned
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.outline,
              ),
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
