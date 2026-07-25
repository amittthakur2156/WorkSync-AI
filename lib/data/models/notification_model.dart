import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/enums.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel {
  static NotificationEntity fromMap(String id, Map<String, dynamic> map) {
    return NotificationEntity(
      id: id,
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      type: NotificationType.fromValue(map['type'] as String? ?? 'system'),
      createdAt: _parseDateTime(map['createdAt']),
      isRead: map['isRead'] as bool? ?? false,
      relatedId: map['relatedId'] as String?,
      status: map['status'] as String?,
    );
  }

  static Map<String, dynamic> toMap(NotificationEntity entity) {
    return {
      'userId': entity.userId,
      'title': entity.title,
      'message': entity.message,
      'type': entity.type.value,
      'createdAt': entity.createdAt.toIso8601String(),
      'isRead': entity.isRead,
      'relatedId': entity.relatedId,
      'status': entity.status,
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
