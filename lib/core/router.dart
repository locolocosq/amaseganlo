import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../screens/fidel/fidel_lesson_complete_screen.dart';
import '../screens/fidel/fidel_lesson_screen.dart';
import '../screens/fidel/fidel_screen.dart';
import '../screens/fidel/fidel_stage_overview_screen.dart';
import '../screens/fidel/fidel_table_screen.dart';
import '../screens/lesson/lesson_complete_screen.dart';
import '../screens/lesson/lesson_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/path/chapter_test_screen.dart';
import '../screens/path/placement_test_screen.dart';
import '../screens/path/region_detail_screen.dart';
import '../screens/path/region_review_screen.dart';
import '../screens/path/unit_overview_screen.dart';
import '../screens/path/world_map_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/review/dictionary_screen.dart';
import '../screens/review/review_screen.dart';
import '../screens/review/review_session_screen.dart';
import '../screens/settings/about_screen.dart';
import '../screens/settings/premium_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/common/app_shell.dart';

/// Builds the app router. [onboardingCompleted] and [refreshListenable] are
/// passed in rather than read from a provider here, so this file has no
/// dependency on `state/` - the caller (normally `main.dart`) owns wiring
/// them to the real [SettingsProvider].
GoRouter buildRouter({
  required bool Function() onboardingCompleted,
  Listenable? refreshListenable,
}) => GoRouter(
  initialLocation: '/learn',
  refreshListenable: refreshListenable,
  redirect: (context, state) {
    final done = onboardingCompleted();
    final atOnboarding = state.matchedLocation == '/onboarding';
    if (!done && !atOnboarding) return '/onboarding';
    if (done && atOnboarding) return '/learn';
    return null;
  },
  // Abschnitt C6: an unknown/invalid URL (bad deep link, back-button edge
  // case) shows a friendly "go home" screen instead of go_router's default
  // error page.
  errorBuilder: (context, state) => _RouteNotFoundScreen(),
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/learn',
              builder: (context, state) => const WorldMapScreen(),
              routes: [
                GoRoute(
                  path: 'region/:regionId',
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: RegionDetailScreen(regionId: state.pathParameters['regionId']!),
                    transitionDuration: _zoomTransitionDuration,
                    reverseTransitionDuration: _zoomTransitionDuration,
                    transitionsBuilder: _zoomTransition,
                  ),
                ),
                GoRoute(
                  path: 'unit/:unitId',
                  builder: (context, state) => UnitOverviewScreen(
                    unitId: state.pathParameters['unitId']!,
                  ),
                ),
                GoRoute(
                  path: 'region/:regionId/review',
                  builder: (context, state) => RegionReviewScreen(
                    sectionIds: (state.extra as List<String>?) ?? const [],
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/fidel',
              builder: (context, state) => const FidelScreen(),
              routes: [
                GoRoute(
                  path: 'stage/:stageId',
                  builder: (context, state) => FidelStageOverviewScreen(
                    stageId: state.pathParameters['stageId']!,
                  ),
                ),
                GoRoute(
                  path: 'table',
                  builder: (context, state) => const FidelTableScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/review',
              builder: (context, state) => const ReviewScreen(),
              routes: [
                GoRoute(
                  path: 'dictionary',
                  builder: (context, state) => const DictionaryScreen(),
                ),
                GoRoute(
                  path: 'session',
                  builder: (context, state) => ReviewSessionScreen(
                    lexemeIds: (state.extra as List<String>?) ?? const [],
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/settings/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/settings/premium',
      builder: (context, state) => const PremiumScreen(),
    ),
    GoRoute(
      path: '/lesson/:unitId/chapter_test',
      builder: (context, state) =>
          ChapterTestScreen(unitId: state.pathParameters['unitId']!),
    ),
    GoRoute(
      path: '/placement-test',
      builder: (context, state) => const PlacementTestScreen(),
    ),
    GoRoute(
      path: '/lesson/:unitId/:lessonId',
      builder: (context, state) => LessonScreen(
        unitId: state.pathParameters['unitId']!,
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
    GoRoute(
      path: '/lesson/:unitId/:lessonId/complete',
      builder: (context, state) => LessonCompleteScreen(
        unitId: state.pathParameters['unitId']!,
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
    GoRoute(
      path: '/fidel/lesson/:stageId/:lessonId',
      builder: (context, state) => FidelLessonScreen(
        stageId: state.pathParameters['stageId']!,
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
    GoRoute(
      path: '/fidel/lesson/:stageId/:lessonId/complete',
      builder: (context, state) => FidelLessonCompleteScreen(
        stageId: state.pathParameters['stageId']!,
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
    GoRoute(
      path: '/fidel/table/practice/:group',
      builder: (context, state) => FidelLessonScreen(
        stageId: 'practice',
        lessonId: 'practice_${state.pathParameters['group']}',
        practiceGroup: state.pathParameters['group'],
      ),
    ),
    GoRoute(
      path: '/fidel/audio-drill',
      builder: (context, state) => const FidelLessonScreen(
        stageId: 'practice',
        lessonId: 'audio_drill',
        audioDrill: true,
      ),
    ),
    GoRoute(
      path: '/fidel/table/audio-drill/:group',
      builder: (context, state) => FidelLessonScreen(
        stageId: 'practice',
        lessonId: 'audio_drill_${state.pathParameters['group']}',
        practiceGroup: state.pathParameters['group'],
        audioDrill: true,
      ),
    ),
  ],
);

/// The Ebene-1-to-Ebene-2 "zoom into the region" transition (Etappe 14):
/// scale up from slightly smaller + fade in, reversed automatically on pop.
const Duration _zoomTransitionDuration = Duration(milliseconds: 380);

Widget _zoomTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
  return FadeTransition(
    opacity: curved,
    child: ScaleTransition(scale: Tween<double>(begin: 0.86, end: 1.0).animate(curved), child: child),
  );
}

class _RouteNotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 56, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 16),
                Text(l10n.errorGenericTitle, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(l10n.errorGenericBody, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.go('/learn'),
                  child: Text(l10n.errorGoHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
