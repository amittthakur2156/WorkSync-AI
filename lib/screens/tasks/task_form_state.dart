import 'package:worksync_ai/core/constants/enums.dart';

class TaskFormState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  
  final String title;
  final String description;
  final String? projectId;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? dueDate;
  final List<String> assigneeIds;

  const TaskFormState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.title = '',
    this.description = '',
    this.projectId,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    this.dueDate,
    this.assigneeIds = const [],
  });

  TaskFormState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? title,
    String? description,
    String? projectId,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    List<String>? assigneeIds,
    bool clearError = false,
  }) {
    return TaskFormState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      assigneeIds: assigneeIds ?? this.assigneeIds,
    );
  }
}
