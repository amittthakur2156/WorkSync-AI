import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worksync_ai/core/constants/enums.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection('notifications');

  @override
  Stream<List<NotificationEntity>> watchNotifications(String userId) {
    return _notifications
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
      final notifications = snap.docs
          .map((d) => NotificationModel.fromMap(d.id, d.data()))
          .toList();
      // In-memory sort to avoid index requirement
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return notifications;
    });
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _notifications.doc(notificationId).update({'isRead': true});
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final query = await _notifications
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (var doc in query.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    return batch.commit();
  }

  @override
  Future<void> deleteNotification(String notificationId) {
    return _notifications.doc(notificationId).delete();
  }

  @override
  Future<void> sendInvitation({
    required String targetUserId,
    required String projectId,
    required String projectTitle,
    required String senderName,
  }) async {
    final invitation = NotificationEntity(
      id: '', // Firestore auto-id
      userId: targetUserId,
      title: 'Project Invitation',
      message: '$senderName invited you to join "$projectTitle"',
      type: NotificationType.invitation,
      createdAt: DateTime.now(),
      relatedId: projectId,
      status: 'pending',
    );

    await _notifications.add(NotificationModel.toMap(invitation));
  }

  @override
  Future<void> updateNotificationStatus(String notificationId, String status) {
    return _notifications.doc(notificationId).update({'status': status});
  }
}
