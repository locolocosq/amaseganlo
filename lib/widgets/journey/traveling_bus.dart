import 'dart:ui';

import 'package:flutter/material.dart';

import 'painter_helpers.dart';

/// The bus, drawn at its position along [path] for the current value of
/// [progress] (0..1 of the path's total length) - shared by both map
/// levels so "the bus visibly drives between stops" looks and behaves the
/// same everywhere. Purely a repainting overlay: it owns no animation
/// itself, the caller's [AnimationController] drives [progress].
class TravelingBus extends StatelessWidget {
  final Path path;
  final Animation<double> progress;
  final double scale;

  const TravelingBus({super.key, required this.path, required this.progress, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _TravelingBusPainter(path: path, progress: progress, scale: scale)),
    );
  }
}

class _TravelingBusPainter extends CustomPainter {
  final Path path;
  final Animation<double> progress;
  final double scale;

  _TravelingBusPainter({required this.path, required this.progress, required this.scale}) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final totalLength = metrics.fold<double>(0, (sum, m) => sum + m.length);
    if (totalLength <= 0) return;

    var distance = progress.value.clamp(0.0, 1.0) * totalLength;
    for (final metric in metrics) {
      if (distance <= metric.length) {
        _paintAt(canvas, metric, distance);
        return;
      }
      distance -= metric.length;
    }
    final last = metrics.last;
    _paintAt(canvas, last, last.length);
  }

  void _paintAt(Canvas canvas, PathMetric metric, double distance) {
    final tangent = metric.getTangentForOffset(distance.clamp(0, metric.length));
    if (tangent == null) return;
    Sketch.bus(canvas, tangent.position, scale, tangent.angle);
  }

  @override
  bool shouldRepaint(covariant _TravelingBusPainter oldDelegate) =>
      oldDelegate.path != path || oldDelegate.scale != scale;
}
