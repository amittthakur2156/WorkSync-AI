import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/enums.dart';
import '../../domain/entities/task_entity.dart';

/// Firestore-facing DTO. Converts between Firestore's `Map<String, dynamic>`
/// and the pure TaskEntity used by the rest of the app.
class TaskModel {
  static TaskEntity fromMap(String id, Map<String, dynamic> map) {
    return TaskEntity(
      id: id,
      projectId: map['projectId'] as String,
      ownerId: map['ownerId'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      status: TaskStatus.fromValue(map['status'] as String? ?? 'todo'),
      priority: TaskPriority.fromValue(map['priority'] as String? ?? 'medium'),
      assigneeIds: List<String>.from(map['assigneeIds'] as List? ?? []),
      dueDate: _parseDateTime(map['dueDate']),
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
    );
  }

  static Map<String, dynamic> toMap(TaskEntity entity) {
    return {
      'projectId': entity.projectId,
      'ownerId': entity.ownerId,
      'title': entity.title,
      'description': entity.description,
      'status': entity.status.value,
      'priority': entity.priority.value,
      'assigneeIds': entity.assigneeIds,
      'dueDate': entity.dueDate?.toIso8601String(),
      'createdAt': entity.createdAt.toIso8601String(),
      'updatedAt': entity.updatedAt.toIso8601String(),
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
