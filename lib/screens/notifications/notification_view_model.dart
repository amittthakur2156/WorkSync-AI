import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_providers.dart';
import '../../core/providers/notification_providers.dart';
import '../../core/providers/project_providers.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_state.dart';

class NotificationViewModel extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    final notificationsAsync = ref.watch(myNotificationsProvider);

    return notificationsAsync.when(
      data: (notifications) => NotificationState(
        isLoading: false,
        notifications: notifications,
      ),
      loading: () => const NotificationState(isLoading: true),
      error: (error, stack) => NotificationState(
        isLoading: false,
        errorMessage: error.toString(),
      ),
    );
  }

  Future<void> acceptInvitation(NotificationEntity notification, BuildContext context) async {
    if (notification.relatedId == null) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final messenger = ScaffoldMessenger.of(context);

      // 1. Add user to project
      await ref.read(projectUsecasesProvider).addMember(
        notification.relatedId!, 
        notification.userId
      );
      
      // 2. Update notification status to accepted
      await ref.read(notificationUsecasesProvider).updateNotificationStatus(
        notification.id, 
        'accepted'
      );
      
      // 3. Mark as read
      await markAsRead(notification.id);
      
      state = state.copyWith(isLoading: false);

      messenger.showSnackBar(
        const SnackBar(
          content: Text("Successfully joined the project! 🎉"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> rejectInvitation(NotificationEntity notification) async {
    state = state.copyWith(isLoading: true);
    try {
      // Delete the notification entirely when rejected
      await ref.read(notificationUsecasesProvider).deleteNotification(notification.id);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await ref.read(notificationUsecasesProvider).markAsRead(id);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;
    
    try {
      await ref.read(notificationUsecasesProvider).markAllAsRead(user.uid);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await ref.read(notificationUsecasesProvider).deleteNotification(id);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
  NotificationViewModel.new,
);
