import 'package:worksync_ai/domain/entities/project_entity.dart';
import 'package:worksync_ai/domain/entities/task_entity.dart';

class ProjectDetailsState {
  final bool isLoading;
  final ProjectEntity? project;
  final List<TaskEntity> tasks;
  final String? errorMessage;

  const ProjectDetailsState({
    this.isLoading = true,
    this.project,
    this.tasks = const [],
    this.errorMessage,
  });

  double get calculatedProgress {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.status.value == 'done').length;
    return completed / tasks.length;
  }

  ProjectDetailsState copyWith({
    bool? isLoading,
    ProjectEntity? project,
    List<TaskEntity>? tasks,
    String? errorMessage,
  }) {
    return ProjectDetailsState(
      isLoading: isLoading ?? this.isLoading,
      project: project ?? this.project,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
