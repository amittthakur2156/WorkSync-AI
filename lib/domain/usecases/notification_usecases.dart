import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class NotificationUsecases {
  final NotificationRepository _repository;

  const NotificationUsecases(this._repository);

  Stream<List<NotificationEntity>> watchNotifications(String userId) {
    return _repository.watchNotifications(userId);
  }

  Future<void> markAsRead(String notificationId) {
    return _repository.markAsRead(notificationId);
  }

  Future<void> markAllAsRead(String userId) {
    return _repository.markAllAsRead(userId);
  }

  Future<void> deleteNotification(String notificationId) {
    return _repository.deleteNotification(notificationId);
  }

  Future<void> sendInvitation({
    required String targetUserId,
    required String projectId,
    required String projectTitle,
    required String senderName,
  }) {
    return _repository.sendInvitation(
      targetUserId: targetUserId,
      projectId: projectId,
      projectTitle: projectTitle,
      senderName: senderName,
    );
  }

  Future<void> updateNotificationStatus(String notificationId, String status) {
    return _repository.updateNotificationStatus(notificationId, status);
  }
}
