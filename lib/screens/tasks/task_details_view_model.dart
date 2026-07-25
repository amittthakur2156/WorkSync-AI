import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/task_providers.dart';
import 'package:worksync_ai/screens/tasks/task_details_state.dart';

final taskDetailsProvider = Provider.family<TaskDetailsState, String>((ref, taskId) {
  final taskAsync = ref.watch(taskByIdProvider(taskId));

  if (taskAsync.isLoading) return const TaskDetailsState(isLoading: true);
  
  return TaskDetailsState(
    isLoading: false, 
    task: taskAsync.value,
    errorMessage: taskAsync.error?.toString(),
  );
});

// A simple notifier for task actions to handle loading/error during mutation
class TaskActionsViewModel extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> updateStatus(String taskId, dynamic status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(taskUsecasesProvider).markStatus(taskId, status);
      ref.invalidate(taskByIdProvider(taskId));
    });
  }

  Future<void> deleteTask(String taskId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(taskUsecasesProvider).deleteTask(taskId);
    });
  }
}

final taskActionsViewModelProvider = NotifierProvider<TaskActionsViewModel, AsyncValue<void>>(
  TaskActionsViewModel.new,
);
