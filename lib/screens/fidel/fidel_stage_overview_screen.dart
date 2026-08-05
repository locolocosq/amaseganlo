import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/fidel_lesson.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/empty_state.dart';

class FidelStageOverviewScreen extends StatelessWidget {
  final String stageId;

  const FidelStageOverviewScreen({super.key, required this.stageId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = context.watch<ContentProvider>().repository;
    final progress = context.watch<ProgressProvider>();
    final settings = context.watch<SettingsProvider>().settings;
    final locale = settings.localeCode ?? Localizations.localeOf(context).languageCode;

    final stage = content.fidelStages.where((s) => s.id == stageId).firstOrNull;
    final lessons = content.fidelLessonsForStage(stageId);

    if (stage == null || lessons.isEmpty) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
        body: EmptyState(icon: Icons.menu_book_outlined, title: l10n.errorContentUnit),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text(stage.title[locale] ?? stage.id),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(stage.description[locale] ?? '', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Text(l10n.fidelLessonList, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final lesson in lessons)
            _FidelLessonTile(
              lesson: lesson,
              completed: progress.progress.lessonProgress[lesson.id]?.completed == true,
              onTap: () => context.push('/fidel/lesson/$stageId/${lesson.id}'),
            ),
        ],
      ),
    );
  }
}

class _FidelLessonTile extends StatelessWidget {
  final FidelLesson lesson;
  final bool completed;
  final VoidCallback onTap;

  const _FidelLessonTile({required this.lesson, required this.completed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: Icon(
        completed ? Icons.check_circle : Icons.circle_outlined,
        color: completed ? successColor : Theme.of(context).colorScheme.outline,
      ),
      title: Text(_kindLabel(l10n, lesson.kind, lesson.groupIds)),
      onTap: onTap,
    );
  }

  String _kindLabel(AppLocalizations l10n, FidelLessonKind kind, List<String> groupIds) {
    switch (kind) {
      case FidelLessonKind.charIntro:
      case FidelLessonKind.rowLesson:
        return groupIds.join(' / ');
      case FidelLessonKind.review:
        return l10n.lessonKindReview;
      case FidelLessonKind.stageTest:
      case FidelLessonKind.blockTest:
        return l10n.lessonKindUnitTest;
      case FidelLessonKind.vowelExplainer:
        return l10n.fidelVowelExplainerTitle;
      case FidelLessonKind.syllableJoin:
      case FidelLessonKind.wordRead:
      case FidelLessonKind.sentenceRead:
      case FidelLessonKind.numeralsPunctuation:
      case FidelLessonKind.writingPractice:
        return groupIds.join(' / ');
    }
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
