import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../state/fidel_lesson_provider.dart';

class FidelLessonCompleteScreen extends StatelessWidget {
  final String stageId;
  final String lessonId;

  const FidelLessonCompleteScreen({super.key, required this.stageId, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = context.read<FidelLessonProvider>().session;

    final xp = session == null ? 0 : (session.isPerfect ? 15 : 10);
    final accuracy = session == null || session.exercises.isEmpty ? 100 : ((session.correctCount / session.exercises.length) * 100).round();
    final minutes = session == null ? 0 : session.elapsed.inSeconds / 60.0;
    final skipped = session?.skippedCount ?? 0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events, size: 72, color: successColor),
                  const SizedBox(height: 16),
                  Text(l10n.lessonCompleteTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Stat(icon: Icons.bolt, label: l10n.lessonCompleteXp(xp)),
                      _Stat(icon: Icons.percent, label: l10n.lessonCompleteAccuracy(accuracy)),
                      _Stat(icon: Icons.timer_outlined, label: l10n.lessonCompleteDuration(minutes.ceil())),
                    ],
                  ),
                  if (skipped > 0) ...[
                    const SizedBox(height: 12),
                    Text(l10n.lessonCompleteSkipped(skipped)),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        context.read<FidelLessonProvider>().endSession();
                        context.go('/fidel/stage/$stageId');
                      },
                      child: Text(l10n.lessonCompleteContinue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Stat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}
