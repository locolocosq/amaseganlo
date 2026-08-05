import 'package:go_router/go_router.dart';

import '../screens/fidel/fidel_lesson_complete_screen.dart';
import '../screens/fidel/fidel_lesson_screen.dart';
import '../screens/fidel/fidel_screen.dart';
import '../screens/fidel/fidel_stage_overview_screen.dart';
import '../screens/fidel/fidel_table_screen.dart';
import '../screens/lesson/lesson_complete_screen.dart';
import '../screens/lesson/lesson_screen.dart';
import '../screens/path/path_screen.dart';
import '../screens/path/unit_overview_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/review/review_screen.dart';
import '../screens/settings/about_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/common/app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/learn',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/learn',
            builder: (context, state) => const PathScreen(),
            routes: [
              GoRoute(
                path: 'unit/:unitId',
                builder: (context, state) => UnitOverviewScreen(unitId: state.pathParameters['unitId']!),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/fidel',
            builder: (context, state) => const FidelScreen(),
            routes: [
              GoRoute(
                path: 'stage/:stageId',
                builder: (context, state) => FidelStageOverviewScreen(stageId: state.pathParameters['stageId']!),
              ),
              GoRoute(
                path: 'table',
                builder: (context, state) => const FidelTableScreen(),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/review', builder: (context, state) => const ReviewScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        ]),
      ],
    ),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/settings/about', builder: (context, state) => const AboutScreen()),
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
