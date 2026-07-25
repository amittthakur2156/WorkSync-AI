import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/constants/enums.dart';
import 'package:worksync_ai/core/providers/auth_providers.dart';
import 'package:worksync_ai/core/providers/task_providers.dart';
import 'package:worksync_ai/domain/entities/task_entity.dart';
import 'package:worksync_ai/screens/tasks/task_form_state.dart';

class TaskFormViewModel extends Notifier<TaskFormState> {
  @override
  TaskFormState build() {
    return const TaskFormState();
  }

  void initForCreate(String? projectId) {
    state = state.copyWith(projectId: projectId);
  }

  void initForEdit(TaskEntity task) {
    state = state.copyWith(
      title: task.title,
      description: task.description,
      projectId: task.projectId,
      priority: task.priority,
      status: task.status,
      dueDate: task.dueDate,
      assigneeIds: task.assigneeIds,
    );
  }

  void updateTitle(String value) => state = state.copyWith(title: value, clearError: true);
  void updateDescription(String value) => state = state.copyWith(description: value, clearError: true);
  void updateProject(String? value) => state = state.copyWith(projectId: value);
  void updatePriority(TaskPriority value) => state = state.copyWith(priority: value);
  void updateStatus(TaskStatus value) => state = state.copyWith(status: value);
  void updateDueDate(DateTime? value) => state = state.copyWith(dueDate: value);

  Future<void> saveTask({String? taskId}) async {
    if (state.title.trim().isEmpty) {
      state = state.copyWith(errorMessage: "Task title is required");
      return;
    }
    if (state.projectId == null) {
      state = state.copyWith(errorMessage: "Please select a project");
      return;
    }

    state = state.copyWith(isLoading: true, isSuccess: false, clearError: true);

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception("User not authenticated");

      final task = TaskEntity(
        id: taskId ?? '',
        projectId: state.projectId!,
        ownerId: user.uid,
        title: state.title,
        description: state.description,
        status: state.status,
        priority: state.priority,
        assigneeIds: state.assigneeIds.isEmpty ? [user.uid] : state.assigneeIds,
        dueDate: state.dueDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (taskId == null) {
        await ref.read(taskUsecasesProvider).createTask(task);
      } else {
        await ref.read(taskUsecasesProvider).updateTask(task);
      }

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final taskFormViewModelProvider =
    NotifierProvider.autoDispose<TaskFormViewModel, TaskFormState>(
  TaskFormViewModel.new,
);
