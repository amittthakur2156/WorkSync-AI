import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/enums.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

/// Firestore-backed implementation of TaskRepository.
/// Documents live in the top-level `tasks` collection, referencing
/// their parent project via `projectId`.
class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _tasks => _firestore.collection('tasks');

  @override
  Stream<List<TaskEntity>> watchTasksForProject(String projectId) {
    return _tasks
        .where('projectId', isEqualTo: projectId)
        .snapshots()
        .map((snap) {
      final tasks = snap.docs.map((d) => TaskModel.fromMap(d.id, d.data())).toList();
      // In-memory sort
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return tasks;
    });
  }

  @override
  Stream<List<TaskEntity>> watchTasksForUser(String ownerId) {
    return _tasks
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) {
      final tasks = snap.docs.map((d) => TaskModel.fromMap(d.id, d.data())).toList();
      // In-memory sort
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return tasks;
    });
  }

  @override
  Future<TaskEntity?> getTaskById(String taskId) async {
    final doc = await _tasks.doc(taskId).get();
    if (!doc.exists) return null;
    return TaskModel.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<String> createTask(TaskEntity task) async {
    final docRef = await _tasks.add(TaskModel.toMap(task));
    return docRef.id;
  }

  @override
  Future<void> updateTask(TaskEntity task) {
    return _tasks.doc(task.id).update(TaskModel.toMap(task));
  }

  @override
  Future<void> updateStatus(String taskId, TaskStatus status) {
    return _tasks.doc(taskId).update({
      'status': status.value,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> deleteTask(String taskId) {
    return _tasks.doc(taskId).delete();
  }
}