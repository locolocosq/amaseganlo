import 'package:flutter/material.dart';

/// The thin progress bar at the top of a running lesson.
class LessonProgressBar extends StatelessWidget {
  final double progress;
  final int heartsRemaining;
  final bool showHearts;

  const LessonProgressBar({
    super.key,
    required this.progress,
    this.heartsRemaining = 0,
    this.showHearts = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: progress.clamp(0, 1), minHeight: 10),
          ),
        ),
        if (showHearts) ...[
          const SizedBox(width: 12),
          Icon(Icons.favorite, color: Theme.of(context).colorScheme.error, size: 20),
          const SizedBox(width: 4),
          Text('$heartsRemaining', style: Theme.of(context).textTheme.titleSmall),
        ],
      ],
    );
  }
}
