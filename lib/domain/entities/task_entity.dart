import 'package:flutter/foundation.dart';
import '../../core/constants/enums.dart';

/// Pure business object for a Task — no Firestore/JSON knowledge here.
/// Firestore (de)serialization lives in data/models/task_model.dart (Step 7).
@immutable
class TaskEntity {
  final String id;
  final String projectId;
  final String ownerId;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final List<String> assigneeIds;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskEntity({
    required this.id,
    required this.projectId,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.assigneeIds,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
  });

  bool get isOverdue =>
      dueDate != null && status != TaskStatus.done && dueDate!.isBefore(DateTime.now());

  TaskEntity copyWith({
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    List<String>? assigneeIds,
    DateTime? dueDate,
    DateTime? updatedAt,
  }) {
    return TaskEntity(
      id: id,
      projectId: projectId,
      ownerId: ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assigneeIds: assigneeIds ?? this.assigneeIds,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}