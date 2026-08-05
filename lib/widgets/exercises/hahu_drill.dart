import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/fidel_char.dart';

/// Stufe 3's signature exercise: the row's 7 signs light up one after
/// another at a steady beat while the learner taps along. Works entirely
/// without sound - two rounds (with transliteration, then signs only).
class HaHuDrill extends StatefulWidget {
  final List<FidelChar> chars;
  final Duration tickDuration;
  final bool reduceMotion;
  final VoidCallback onComplete;

  const HaHuDrill({
    super.key,
    required this.chars,
    required this.tickDuration,
    required this.reduceMotion,
    required this.onComplete,
  });

  @override
  State<HaHuDrill> createState() => _HaHuDrillState();
}

class _HaHuDrillState extends State<HaHuDrill> {
  late List<FidelChar> _sorted;
  int _round = 0; // 0: with transliteration, 1: signs only
  int _beatIndex = 0;
  Timer? _timer;
  bool _tapPulse = false;

  @override
  void initState() {
    super.initState();
    _sorted = List<FidelChar>.from(widget.chars)..sort((a, b) => a.order.compareTo(b.order));
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.tickDuration, (_) => _advanceBeat());
  }

  void _advanceBeat() {
    if (!mounted) return;
    setState(() {
      _beatIndex++;
      if (_beatIndex >= _sorted.length) {
        _beatIndex = 0;
        _round++;
        if (_round >= 2) {
          _timer?.cancel();
          widget.onComplete();
          return;
        }
      }
    });
  }

  void _handleTap() {
    setState(() => _tapPulse = true);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _tapPulse = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final showTr = _round == 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          showTr ? l10n.hahuDrillWithTransliteration : l10n.hahuDrillCharsOnly,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 32),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var i = 0; i < _sorted.length; i++)
              AnimatedContainer(
                duration: widget.reduceMotion ? Duration.zero : const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: i == _beatIndex ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _sorted[i].char,
                      style: TextStyle(
                        fontSize: 32,
                        color: i == _beatIndex ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                      ),
                    ),
                    if (showTr)
                      Text(
                        _sorted[i].tr,
                        style: TextStyle(
                          color: i == _beatIndex ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: _handleTap,
          child: AnimatedScale(
            scale: _tapPulse ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: Icon(Icons.touch_app, color: theme.colorScheme.onSecondaryContainer),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(l10n.hahuDrillTapHint, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
