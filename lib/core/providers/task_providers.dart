import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/task_usecases.dart';
import 'auth_providers.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl();
});

final taskUsecasesProvider = Provider<TaskUsecases>((ref) {
  return TaskUsecases(ref.watch(taskRepositoryProvider));
});

/// Live list of all tasks for the user.
final myTasksProvider = StreamProvider<List<TaskEntity>>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.maybeWhen(
    data: (user) {
      if (user == null) return const Stream.empty();
      return ref.watch(taskUsecasesProvider).watchTasksForUser(user.uid);
    },
    orElse: () => const Stream.empty(),
  );
});

/// Tasks for a project.
final tasksForProjectProvider = StreamProvider.family<List<TaskEntity>, String>((ref, projectId) {
  return ref.watch(taskUsecasesProvider).watchTasksForProject(projectId);
});

/// Single task by ID.
final taskByIdProvider = FutureProvider.family<TaskEntity?, String>((ref, taskId) {
  return ref.watch(taskUsecasesProvider).getTaskById(taskId);
});
