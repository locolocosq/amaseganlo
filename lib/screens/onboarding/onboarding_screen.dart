import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/language_names.dart';
import '../../l10n/app_localizations.dart';
import '../../models/settings.dart';
import '../../state/settings_provider.dart';

/// First-run flow (Abschnitt 14, "Onboarding"): language, the two learning
/// paths, a daily goal, and a rough self-assessment. Shown once, gated by
/// `AppSettings.onboardingCompleted` via the router's redirect - see
/// `core/router.dart`.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;
  static const _pageCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_page >= _pageCount - 1) {
      context.read<SettingsProvider>().setOnboardingCompleted(true);
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _back() {
    if (_page == 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                const SizedBox(height: 12),
                _StepDots(current: _page, count: _pageCount),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => setState(() => _page = i),
                    children: const [
                      _WelcomeStep(),
                      _TwoPathsStep(),
                      _DailyGoalStep(),
                      _AssessmentStep(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      if (_page > 0)
                        TextButton(
                          onPressed: _back,
                          child: Text(l10n.commonBack),
                        )
                      else
                        const SizedBox.shrink(),
                      const Spacer(),
                      FilledButton(
                        onPressed: _next,
                        child: Text(
                          _page == _pageCount - 1
                              ? l10n.onboardingStart
                              : l10n.commonNext,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  final int current;
  final int count;
  const _StepDots({required this.current, required this.count});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == current ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == current ? color : color.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}

class _StepScaffold extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  final Widget? child;

  const _StepScaffold({
    required this.icon,
    required this.title,
    this.body,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 20),
          Text(
            title,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          if (body != null) ...[
            const SizedBox(height: 12),
            Text(
              body!,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
          if (child != null) ...[const SizedBox(height: 24), child!],
        ],
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsProvider = context.watch<SettingsProvider>();
    final settings = settingsProvider.settings;

    return _StepScaffold(
      icon: Icons.translate,
      title: l10n.onboardingWelcomeTitle,
      body: l10n.onboardingWelcomeBody,
      child: Column(
        children: [
          Text(
            l10n.onboardingChooseLanguage,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          DropdownButton<String?>(
            value: settings.localeCode,
            hint: Text(l10n.appearanceSystem),
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.appearanceSystem)),
              for (final code in supportedLocaleCodes)
                DropdownMenuItem(
                  value: code,
                  child: Text(languageDisplayName(code)),
                ),
            ],
            onChanged: settingsProvider.setLocaleCode,
          ),
        ],
      ),
    );
  }
}

class _TwoPathsStep extends StatelessWidget {
  const _TwoPathsStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _StepScaffold(
      icon: Icons.alt_route,
      title: l10n.onboardingTwoPathsTitle,
      body: l10n.onboardingTwoPathsBody,
    );
  }
}

class _DailyGoalStep extends StatelessWidget {
  const _DailyGoalStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsProvider = context.watch<SettingsProvider>();
    final settings = settingsProvider.settings;

    return _StepScaffold(
      icon: Icons.flag_outlined,
      title: l10n.onboardingDailyGoalTitle,
      child: SegmentedButton<DailyGoal>(
        segments: [
          ButtonSegment(
            value: DailyGoal.relaxed,
            label: Text(l10n.dailyGoalRelaxed),
          ),
          ButtonSegment(
            value: DailyGoal.normal,
            label: Text(l10n.dailyGoalNormal),
          ),
          ButtonSegment(
            value: DailyGoal.ambitious,
            label: Text(l10n.dailyGoalAmbitious),
          ),
        ],
        selected: {settings.dailyGoal},
        onSelectionChanged: (s) => settingsProvider.setDailyGoal(s.first),
      ),
    );
  }
}

enum _PriorKnowledge { none, some, good }

class _AssessmentStep extends StatefulWidget {
  const _AssessmentStep();

  @override
  State<_AssessmentStep> createState() => _AssessmentStepState();
}

class _AssessmentStepState extends State<_AssessmentStep> {
  _PriorKnowledge? _choice;

  @override
  void initState() {
    super.initState();
    // Best-effort guess from the boolean setting this maps to - there is no
    // dedicated 3-way field, see the class doc below.
    final unlocked = context
        .read<SettingsProvider>()
        .settings
        .allLessonsUnlocked;
    _choice = unlocked ? _PriorKnowledge.some : _PriorKnowledge.none;
  }

  // No adaptive placement test yet (Etappe 9) - "some"/"good" prior
  // knowledge both unlock every unit for now as an honest stand-in, rather
  // than pretending to place the learner at a specific section. The 3-way
  // choice itself only lives in this screen's local state; only its
  // collapsed boolean form is persisted.
  void _choose(_PriorKnowledge choice) {
    setState(() => _choice = choice);
    context.read<SettingsProvider>().setAllLessonsUnlocked(
      choice != _PriorKnowledge.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _StepScaffold(
      icon: Icons.school_outlined,
      title: l10n.onboardingAssessmentQuestion,
      child: RadioGroup<_PriorKnowledge>(
        groupValue: _choice,
        onChanged: (v) {
          if (v != null) _choose(v);
        },
        child: Column(
          children: [
            RadioListTile<_PriorKnowledge>(
              value: _PriorKnowledge.none,
              title: Text(l10n.onboardingAssessmentNone),
            ),
            RadioListTile<_PriorKnowledge>(
              value: _PriorKnowledge.some,
              title: Text(l10n.onboardingAssessmentSome),
            ),
            RadioListTile<_PriorKnowledge>(
              value: _PriorKnowledge.good,
              title: Text(l10n.onboardingAssessmentGood),
            ),
          ],
        ),
      ),
    );
  }
}
