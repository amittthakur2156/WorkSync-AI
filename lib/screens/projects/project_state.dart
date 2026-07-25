import '../../domain/entities/project_entity.dart';

class ProjectState {
  final bool isLoading;
  final List<ProjectEntity> activeProjects;
  final List<ProjectEntity> completedProjects;
  final String searchQuery;
  final String? errorMessage;

  const ProjectState({
    this.isLoading = true,
    this.activeProjects = const [],
    this.completedProjects = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  ProjectState copyWith({
    bool? isLoading,
    List<ProjectEntity>? activeProjects,
    List<ProjectEntity>? completedProjects,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProjectState(
      isLoading: isLoading ?? this.isLoading,
      activeProjects: activeProjects ?? this.activeProjects,
      completedProjects: completedProjects ?? this.completedProjects,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
