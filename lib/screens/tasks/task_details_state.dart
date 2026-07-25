import 'package:worksync_ai/domain/entities/task_entity.dart';

class TaskDetailsState {
  final bool isLoading;
  final TaskEntity? task;
  final String? errorMessage;
  final bool isDeleted;

  const TaskDetailsState({
    this.isLoading = true,
    this.task,
    this.errorMessage,
    this.isDeleted = false,
  });

  TaskDetailsState copyWith({
    bool? isLoading,
    TaskEntity? task,
    String? errorMessage,
    bool? isDeleted,
    bool clearError = false,
  }) {
    return TaskDetailsState(
      isLoading: isLoading ?? this.isLoading,
      task: task ?? this.task,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
