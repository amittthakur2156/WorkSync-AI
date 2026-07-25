import '../../domain/entities/task_entity.dart';

class TaskState {
  final bool isLoading;
  final List<TaskEntity> todaysTasks;
  final List<TaskEntity> upcomingTasks;
  final String searchQuery;
  final String? errorMessage;

  const TaskState({
    this.isLoading = true,
    this.todaysTasks = const [],
    this.upcomingTasks = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  TaskState copyWith({
    bool? isLoading,
    List<TaskEntity>? todaysTasks,
    List<TaskEntity>? upcomingTasks,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      todaysTasks: todaysTasks ?? this.todaysTasks,
      upcomingTasks: upcomingTasks ?? this.upcomingTasks,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
