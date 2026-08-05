import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../screens/fidel/fidel_lesson_complete_screen.dart';
import '../screens/fidel/fidel_lesson_screen.dart';
import '../screens/fidel/fidel_screen.dart';
import '../screens/fidel/fidel_stage_overview_screen.dart';
import '../screens/fidel/fidel_table_screen.dart';
import '../screens/lesson/lesson_complete_screen.dart';
import '../screens/lesson/lesson_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/path/chapter_test_screen.dart';
import '../screens/path/path_screen.dart';
import '../screens/path/placement_test_screen.dart';
import '../screens/path/unit_overview_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/review/dictionary_screen.dart';
import '../screens/review/review_screen.dart';
import '../screens/review/review_session_screen.dart';
import '../screens/settings/about_screen.dart';
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
              builder: (context, state) => const PathScreen(),
              routes: [
                GoRoute(
                  path: 'unit/:unitId',
                  builder: (context, state) => UnitOverviewScreen(
                    unitId: state.pathParameters['unitId']!,
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
  ],
);
