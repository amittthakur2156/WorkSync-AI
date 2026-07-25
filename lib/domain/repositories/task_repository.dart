import '../../core/constants/enums.dart';
import '../entities/task_entity.dart';

/// Abstract contract for Task data access. Concrete Firestore implementation
/// arrives in data/repositories/task_repository_impl.dart after Step 8.
abstract class TaskRepository {
  Stream<List<TaskEntity>> watchTasksForProject(String projectId);

  Stream<List<TaskEntity>> watchTasksForUser(String ownerId);

  Future<TaskEntity?> getTaskById(String taskId);

  Future<String> createTask(TaskEntity task);

  Future<void> updateTask(TaskEntity task);

  Future<void> updateStatus(String taskId, TaskStatus status);

  Future<void> deleteTask(String taskId);
}