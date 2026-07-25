import '../../domain/entities/project_entity.dart';
import '../../domain/entities/task_entity.dart';

class DashboardState {
  final bool isLoading;
  final int projectsCount;
  final int tasksCount;
  final int completedTasksCount;
  final int pendingTasksCount;
  final List<ProjectEntity> recentProjects;
  final List<TaskEntity> todaysTasks;
  final String userName;
  final String searchQuery;
  final String workspaceInsight;

  const DashboardState({
    this.isLoading = true,
    this.projectsCount = 0,
    this.tasksCount = 0,
    this.completedTasksCount = 0,
    this.pendingTasksCount = 0,
    this.recentProjects = const [],
    this.todaysTasks = const [],
    this.userName = '',
    this.searchQuery = '',
    this.workspaceInsight = '',
  });

  DashboardState copyWith({
    bool? isLoading,
    int? projectsCount,
    int? tasksCount,
    int? completedTasksCount,
    int? pendingTasksCount,
    List<ProjectEntity>? recentProjects,
    List<TaskEntity>? todaysTasks,
    String? userName,
    String? searchQuery,
    String? workspaceInsight,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      projectsCount: projectsCount ?? this.projectsCount,
      tasksCount: tasksCount ?? this.tasksCount,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      pendingTasksCount: pendingTasksCount ?? this.pendingTasksCount,
      recentProjects: recentProjects ?? this.recentProjects,
      todaysTasks: todaysTasks ?? this.todaysTasks,
      userName: userName ?? this.userName,
      searchQuery: searchQuery ?? this.searchQuery,
      workspaceInsight: workspaceInsight ?? this.workspaceInsight,
    );
  }
}
