import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/enums.dart';
import '../../core/providers/ai_providers.dart';
import '../../core/providers/auth_providers.dart';
import '../../core/providers/project_providers.dart';
import '../../core/providers/task_providers.dart';
import 'dashboard_state.dart';

class DashboardSearchQuery extends Notifier<String> {
  @override
  String build() => '';
  set query(String val) => state = val;
}

final dashboardSearchQueryProvider = NotifierProvider<DashboardSearchQuery, String>(
  DashboardSearchQuery.new,
);

class DashboardViewModel extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    final userAsync = ref.watch(authStateProvider);
    final projectsAsync = ref.watch(myProjectsProvider);
    final tasksAsync = ref.watch(myTasksProvider);
    final searchQuery = ref.watch(dashboardSearchQueryProvider);

    final user = userAsync.value;
    final userName = user?.name ?? '';
    
    // Only block the UI completely if we don't even have a user identity yet
    if (userAsync.isLoading && user == null) {
      return DashboardState(userName: userName, isLoading: true, searchQuery: searchQuery);
    }

    final allProjects = projectsAsync.value ?? [];
    final allTasks = tasksAsync.value ?? [];

    // Generate real workspace insight using AiService
    final insight = ref.read(aiServiceProvider).generateWorkspaceInsight(
      projects: allProjects,
      tasks: allTasks,
    );

    final completedTasksCount = allTasks.where((t) => t.status == TaskStatus.done).length;
    final pendingTasksCount = allTasks.where((t) => t.status != TaskStatus.done).length;

    var filteredProjects = allProjects;
    var filteredTasks = allTasks;

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filteredProjects = allProjects.where((p) => 
        p.title.toLowerCase().contains(query) || 
        p.description.toLowerCase().contains(query)
      ).toList();
      
      filteredTasks = allTasks.where((t) => 
        t.title.toLowerCase().contains(query) || 
        t.description.toLowerCase().contains(query)
      ).toList();
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final todaysTasks = filteredTasks.where((t) {
      if (t.dueDate != null) {
        final d = t.dueDate!;
        return d.year == today.year && d.month == today.month && d.day == today.day;
      }
      return t.createdAt.isAfter(today.subtract(const Duration(days: 1)));
    }).take(3).toList();

    final recentProjects = filteredProjects.take(3).toList();

    return DashboardState(
      // isLoading is true if we are still fetching projects or tasks, 
      // but the UI will decide whether to show a full spinner or shimmers.
      isLoading: projectsAsync.isLoading || tasksAsync.isLoading,
      projectsCount: allProjects.length,
      tasksCount: allTasks.length,
      completedTasksCount: completedTasksCount,
      pendingTasksCount: pendingTasksCount,
      recentProjects: recentProjects,
      todaysTasks: todaysTasks,
      userName: userName,
      searchQuery: searchQuery,
      workspaceInsight: insight,
    );
  }

  void updateSearchQuery(String query) {
    ref.read(dashboardSearchQueryProvider.notifier).query = query;
  }
}

final dashboardViewModelProvider = NotifierProvider<DashboardViewModel, DashboardState>(
  DashboardViewModel.new,
);
