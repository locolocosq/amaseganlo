import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../content/content_repository.dart';
import '../../core/journey_progress.dart';
import '../../core/purchase_service.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/fidel_lesson.dart';
import '../../models/settings.dart';
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
    final lessons = _orderedLessons(content, stageId, settings.fidelLearningPath);

    if (stage == null || lessons.isEmpty) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), tooltip: l10n.commonBack, onPressed: () => context.pop())),
        body: EmptyState(icon: Icons.menu_book_outlined, title: l10n.errorContentUnit),
      );
    }

    // Defensive re-check (Etappe 24 Nachtrag 5), same reasoning as
    // unit_overview_screen.dart's own: the stage list never lets a
    // Premium-gated stage's tile navigate here in the first place, but this
    // route is still reachable directly (a deep link, a saved/restored
    // navigation stack), so the paywall has to hold here too.
    final isPremium = context.watch<PurchaseService>().isPremium;
    if (isFidelStagePremiumLocked(stage.number, isPremium)) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), tooltip: l10n.commonBack, onPressed: () => context.pop()),
          title: Text(stage.title[locale] ?? stage.id),
        ),
        body: EmptyState(
          icon: Icons.workspace_premium,
          title: l10n.premiumLockedDialogTitle,
          body: l10n.premiumLockedDialogBody,
          action: FilledButton(
            onPressed: () => context.push('/settings/premium'),
            child: Text(l10n.premiumLockedDialogAction),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), tooltip: l10n.commonBack, onPressed: () => context.pop()),
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

  /// Stufe 3's row lessons can be presented in traditional or frequency
  /// ("Schnell lesen") order - progress is keyed by lesson id either way, so
  /// switching paths never loses anything already learned. Block tests are
  /// kept right after the last of their own 3 rows, whichever order that
  /// ends up being.
  List<FidelLesson> _orderedLessons(ContentRepository content, String stageId, FidelLearningPath path) {
    final lessons = content.fidelLessonsForStage(stageId);
    if (stageId != 'stufe3' || path != FidelLearningPath.fast) return lessons;

    final frequencyOrder = content.fidelGroupsByFrequency();
    int rankOf(String group) => frequencyOrder.indexOf(group);

    final sorted = List<FidelLesson>.from(lessons);
    sorted.sort((a, b) {
      final rankA = a.groupIds.map(rankOf).fold(0, (m, r) => r > m ? r : m);
      final rankB = b.groupIds.map(rankOf).fold(0, (m, r) => r > m ? r : m);
      return rankA.compareTo(rankB);
    });
    return sorted;
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
