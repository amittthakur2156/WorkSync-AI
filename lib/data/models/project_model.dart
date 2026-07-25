import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/constants/enums.dart';
import '../../domain/entities/project_entity.dart';

/// Firestore-facing DTO. Converts between Firestore's `Map<String, dynamic>`
/// and the pure ProjectEntity used by the rest of the app.
class ProjectModel {
  static ProjectEntity fromMap(String id, Map<String, dynamic> map) {
    return ProjectEntity(
      id: id,
      ownerId: map['ownerId'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      status: ProjectStatus.fromValue(map['status'] as String? ?? 'active'),
      color: Color(map['color'] as int? ?? 0xFF6366F1),
      icon: _getIconData(map['iconKey'] as String? ?? 'folder'),
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      coverImageUrl: map['coverImageUrl'] as String?,
      memberIds: List<String>.from(map['memberIds'] as List? ?? []),
      deadline: _parseDateTime(map['deadline']),
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
    );
  }

  static Map<String, dynamic> toMap(ProjectEntity entity) {
    return {
      'ownerId': entity.ownerId,
      'title': entity.title,
      'description': entity.description,
      'status': entity.status.value,
      'color': entity.color.toARGB32(),
      'iconKey': _getIconKey(entity.icon),
      'progress': entity.progress,
      'coverImageUrl': entity.coverImageUrl,
      'memberIds': entity.memberIds,
      'deadline': entity.deadline?.toIso8601String(),
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

  /// Maps a String key to constant IconData. 
  /// This prevents "non-constant IconData" errors during release builds.
  static IconData _getIconData(String key) {
    switch (key) {
      case 'rocket':
        return Icons.rocket_launch;
      case 'computer':
        return Icons.computer;
      case 'brush':
        return Icons.brush;
      case 'money':
        return Icons.attach_money;
      case 'campaign':
        return Icons.campaign;
      case 'note':
        return Icons.event_note;
      case 'magic':
        return Icons.auto_awesome;
      case 'folder':
      default:
        return Icons.folder;
    }
  }

  /// Reverse mapping to save icon keys to Firestore
  static String _getIconKey(IconData icon) {
    if (icon == Icons.rocket_launch) return 'rocket';
    if (icon == Icons.computer) return 'computer';
    if (icon == Icons.brush) return 'brush';
    if (icon == Icons.attach_money) return 'money';
    if (icon == Icons.campaign) return 'campaign';
    if (icon == Icons.event_note) return 'note';
    if (icon == Icons.auto_awesome) return 'magic';
    return 'folder';
  }
}
