import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/lesson.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/empty_state.dart';

class UnitOverviewScreen extends StatelessWidget {
  final String unitId;

  const UnitOverviewScreen({super.key, required this.unitId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = context.watch<ContentProvider>().repository;
    final progress = context.watch<ProgressProvider>();
    final settings = context.watch<SettingsProvider>().settings;
    final locale =
        settings.localeCode ?? Localizations.localeOf(context).languageCode;

    final unit = content.unit(unitId);
    final lessons = content.lessonsForUnit(unitId);

    if (unit == null || lessons.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: EmptyState(
          icon: Icons.menu_book_outlined,
          title: l10n.errorContentUnit,
        ),
      );
    }

    final crowns = progress.progress.unitCrowns[unitId] ?? 0;
    final words = content.lexemesForUnit(unitId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(unit.title[locale] ?? unit.id),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 5; i++)
                Icon(
                  Icons.emoji_events,
                  color: i < crowns
                      ? successColor
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
            ],
          ),
          Center(child: Text(l10n.unitOverviewCrowns(crowns))),
          const SizedBox(height: 16),
          Text(
            l10n.unitOverviewLessons,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final lesson in lessons)
            _LessonTile(
              lesson: lesson,
              completed:
                  progress.progress.lessonProgress[lesson.id]?.completed ==
                  true,
              onTap: () => context.push('/lesson/$unitId/${lesson.id}'),
            ),
          ListTile(
            leading: Icon(
              crowns >= 5 ? Icons.check_circle : Icons.quiz_outlined,
              color: crowns >= 5
                  ? successColor
                  : Theme.of(context).colorScheme.outline,
            ),
            title: Text(l10n.pathUnitTest),
            subtitle: Text(l10n.pathUnitTestHint),
            onTap: () => context.push('/lesson/$unitId/chapter_test'),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.unitOverviewWordList,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final w in words)
                Chip(label: Text('${w.tr} · ${w.t[locale] ?? ''}')),
            ],
          ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final bool completed;
  final VoidCallback onTap;

  const _LessonTile({
    required this.lesson,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: Icon(
        completed ? Icons.check_circle : Icons.circle_outlined,
        color: completed ? successColor : Theme.of(context).colorScheme.outline,
      ),
      title: Text(_kindLabel(l10n, lesson.kind)),
      onTap: onTap,
    );
  }

  String _kindLabel(AppLocalizations l10n, LessonKind kind) {
    switch (kind) {
      case LessonKind.intro:
        return l10n.lessonKindIntro;
      case LessonKind.wordPractice:
        return l10n.lessonKindWordPractice;
      case LessonKind.sentenceBuilding:
        return l10n.lessonKindSentenceBuilding;
      case LessonKind.listening:
        return l10n.lessonKindListening;
      case LessonKind.freeApplication:
        return l10n.lessonKindFreeApplication;
      case LessonKind.review:
        return l10n.lessonKindReview;
      case LessonKind.unitTest:
        return l10n.lessonKindUnitTest;
    }
  }
}
