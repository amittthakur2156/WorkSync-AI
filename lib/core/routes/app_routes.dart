/// Centralized route path constants. Always navigate using these
/// constants (context.go(AppRoutes.login)) — never hardcode path strings.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String dashboard = '/dashboard';
  static const String projects = '/projects';
  static const String projectCreate = 'create';
  static const String projectDetails = ':projectId';
  static const String projectEdit = ':projectId/edit';
  static const String tasks = '/tasks';
  static const String taskCreate = 'create';
  static const String taskDetails = ':taskId';
  static const String taskEdit = ':taskId/edit';
  static const String calendar = '/calendar';
  static const String profile = '/profile';
  static const String editProfile = 'edit';
  static const String changePassword = 'change-password';

  static const String editProfilePath = '/profile/edit';
  static const String changePasswordPath = '/profile/change-password';

  static const String notifications = '/notifications';
  static const String aiAssistant = '/ai-assistant';

  static String projectDetailsPath(String id) => '$projects/$id';
  static String taskDetailsPath(String id) => '$tasks/$id';
  static String taskEditPath(String id) => '$tasks/$id/edit';
}