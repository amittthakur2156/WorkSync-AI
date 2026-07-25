import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/constants/enums.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'project_state.dart';

class ProjectSearchQuery extends Notifier<String> {
  @override
  String build() => '';
  set query(String val) => state = val;
}

final projectSearchQueryProvider = NotifierProvider<ProjectSearchQuery, String>(
  ProjectSearchQuery.new,
);

class ProjectViewModel extends Notifier<ProjectState> {
  @override
  ProjectState build() {
    final projectsAsync = ref.watch(myProjectsProvider);
    final searchQuery = ref.watch(projectSearchQueryProvider);

    final projects = projectsAsync.value ?? [];
    
    final query = searchQuery.toLowerCase();
    final filtered = projects.where((p) =>
        p.title.toLowerCase().contains(query) ||
        p.description.toLowerCase().contains(query)).toList();

    final active = filtered.where((p) => p.status != ProjectStatus.completed).toList();
    final completed = filtered.where((p) => p.status == ProjectStatus.completed).toList();

    return ProjectState(
      // Only show loading if we are truly loading AND have no data to show yet
      // This ensures cached data remains visible during background updates.
      isLoading: projectsAsync.isLoading && !projectsAsync.hasValue,
      activeProjects: active,
      completedProjects: completed,
      searchQuery: searchQuery,
      errorMessage: projectsAsync.error?.toString(),
    );
  }

  void updateSearchQuery(String query) {
    ref.read(projectSearchQueryProvider.notifier).query = query;
  }
}

final projectViewModelProvider = NotifierProvider<ProjectViewModel, ProjectState>(
  ProjectViewModel.new,
);
