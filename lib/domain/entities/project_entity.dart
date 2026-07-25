import 'package:flutter/material.dart';
import '../../core/constants/enums.dart';

/// Pure business object for a Project — no Firestore/JSON knowledge here.
/// Firestore (de)serialization lives in data/models/project_model.dart (Step 7).
@immutable
class ProjectEntity {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final ProjectStatus status;
  final Color color;
  final IconData icon;
  final double progress;
  final String? coverImageUrl;
  final List<String> memberIds;
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectEntity({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.status,
    required this.color,
    required this.icon,
    required this.progress,
    required this.memberIds,
    required this.createdAt,
    required this.updatedAt,
    this.coverImageUrl,
    this.deadline,
  });

  ProjectEntity copyWith({
    String? title,
    String? description,
    ProjectStatus? status,
    Color? color,
    IconData? icon,
    double? progress,
    String? coverImageUrl,
    List<String>? memberIds,
    DateTime? deadline,
    DateTime? updatedAt,
  }) {
    return ProjectEntity(
      id: id,
      ownerId: ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      progress: progress ?? this.progress,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      memberIds: memberIds ?? this.memberIds,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}