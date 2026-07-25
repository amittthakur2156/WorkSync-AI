import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login/login_screen.dart';
import '../../screens/auth/register/register_screen.dart';
import '../../screens/auth/forgot_password/forgot_password_screen.dart';

import '../../screens/main/main_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/projects/project_screen.dart';
import '../../screens/projects/create_project_screen.dart';
import '../../screens/projects/project_details_screen.dart';
import '../../screens/projects/edit_project_screen.dart';
import '../../screens/tasks/task_screen.dart';
import '../../screens/tasks/create_task_screen.dart';
import '../../screens/tasks/task_details_screen.dart';
import '../../screens/tasks/edit_task_screen.dart';
import '../../screens/calendar/calendar_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit/edit_profile_screen.dart';
import '../../screens/profile/change_password/change_password_screen.dart';

import '../../screens/notifications/notification_screen.dart';
import '../../screens/ai/ai_assistant_screen.dart';

/// App-wide navigator keys. The root key wraps the whole app; each shell
/// branch gets its own key so each bottom-nav tab keeps an independent
/// navigation stack.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _dashboardNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _projectsNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _tasksNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _calendarNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _profileNavKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return appRouter;
});

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: AppRoutes.aiAssistant,
      builder: (context, state) => const AIAssistantScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _dashboardNavKey,
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => DashboardScreen(
                onTabChange: (index) => context.go(_branchPaths[index]),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _projectsNavKey,
          routes: [
            GoRoute(
              path: AppRoutes.projects,
              builder: (context, state) => const ProjectScreen(),
              routes: [
                GoRoute(
                  path: AppRoutes.projectCreate,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const CreateProjectScreen(),
                ),
                GoRoute(
                  path: AppRoutes.projectDetails,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => ProjectDetailsScreen(
                    projectId: state.pathParameters['projectId']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) => EditProjectScreen(
                        projectId: state.pathParameters['projectId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _tasksNavKey,
          routes: [
            GoRoute(
              path: AppRoutes.tasks,
              builder: (context, state) => const TaskScreen(),
              routes: [
                GoRoute(
                  path: AppRoutes.taskCreate,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const CreateTaskScreen(),
                ),
                GoRoute(
                  path: AppRoutes.taskDetails,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => TaskDetailsScreen(
                    taskId: state.pathParameters['taskId']!,
                  ),
                ),
                GoRoute(
                  path: AppRoutes.taskEdit,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => EditTaskScreen(
                    taskId: state.pathParameters['taskId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _calendarNavKey,
          routes: [
            GoRoute(
              path: AppRoutes.calendar,
              builder: (context, state) => const CalendarScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavKey,
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: AppRoutes.editProfile,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: AppRoutes.changePassword,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const ChangePasswordScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Bottom-nav branch order must match AppBottomNavBar's destination order.
const List<String> _branchPaths = [
  AppRoutes.dashboard,
  AppRoutes.projects,
  AppRoutes.tasks,
  AppRoutes.calendar,
  AppRoutes.profile,
];