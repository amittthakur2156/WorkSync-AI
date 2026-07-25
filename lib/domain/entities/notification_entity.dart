import 'package:flutter/foundation.dart';
import '../../core/constants/enums.dart';

@immutable
class NotificationEntity {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? relatedId; // e.g. projectId
  final String? status; // pending, accepted, rejected

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.relatedId,
    this.status,
  });

  NotificationEntity copyWith({
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    String? relatedId,
    String? status,
  }) {
    return NotificationEntity(
      id: id,
      userId: userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId ?? this.relatedId,
      status: status ?? this.status,
    );
  }
}
