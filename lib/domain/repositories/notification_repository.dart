import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Stream<List<NotificationEntity>> watchNotifications(String userId);

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead(String userId);

  Future<void> deleteNotification(String notificationId);

  Future<void> sendInvitation({
    required String targetUserId,
    required String projectId,
    required String projectTitle,
    required String senderName,
  });

  Future<void> updateNotificationStatus(String notificationId, String status);
}
