import '../../core/constants/enums.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Business-logic entry point for Task features. ViewModels call these
/// methods — never TaskRepository directly.
class TaskUsecases {
  final TaskRepository _repository;

  const TaskUsecases(this._repository);

  Stream<List<TaskEntity>> watchTasksForProject(String projectId) {
    return _repository.watchTasksForProject(projectId);
  }

  Stream<List<TaskEntity>> watchTasksForUser(String ownerId) {
    return _repository.watchTasksForUser(ownerId);
  }

  Future<TaskEntity?> getTaskById(String taskId) {
    return _repository.getTaskById(taskId);
  }

  Future<String> createTask(TaskEntity task) {
    if (task.title.trim().isEmpty) {
      throw ArgumentError('Task title cannot be empty');
    }
    return _repository.createTask(task);
  }

  Future<void> updateTask(TaskEntity task) {
    return _repository.updateTask(task);
  }

  Future<void> markStatus(String taskId, TaskStatus status) {
    return _repository.updateStatus(taskId, status);
  }

  Future<void> deleteTask(String taskId) {
    return _repository.deleteTask(taskId);
  }
}