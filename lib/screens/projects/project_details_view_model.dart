import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'package:worksync_ai/core/providers/task_providers.dart';
import 'package:worksync_ai/screens/projects/project_details_state.dart';

final projectDetailsProvider = Provider.family<ProjectDetailsState, String>((ref, projectId) {
  final projectAsync = ref.watch(projectByIdProvider(projectId));
  final tasksAsync = ref.watch(tasksForProjectProvider(projectId));

  final project = projectAsync.value;
  final tasks = tasksAsync.value ?? [];

  return ProjectDetailsState(
    // Only show full loading if we don't even have the project info yet
    isLoading: projectAsync.isLoading && project == null,
    project: project,
    tasks: tasks,
    errorMessage: projectAsync.error?.toString() ?? tasksAsync.error?.toString(),
  );
});
