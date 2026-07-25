import '../../domain/entities/notification_entity.dart';

class NotificationState {
  final bool isLoading;
  final List<NotificationEntity> notifications;
  final String? errorMessage;

  const NotificationState({
    this.isLoading = true,
    this.notifications = const [],
    this.errorMessage,
  });

  NotificationState copyWith({
    bool? isLoading,
    List<NotificationEntity>? notifications,
    String? errorMessage,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
