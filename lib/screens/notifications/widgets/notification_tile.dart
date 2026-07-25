import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/enums.dart';
import '../../../domain/entities/notification_entity.dart';
import '../notification_view_model.dart';

class NotificationTile extends ConsumerWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getColor();
    final icon = _getIcon();
    final isInvitation = notification.type == NotificationType.invitation;
    final isPending = notification.status == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : const Color(0xffF0F4FF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color.withValues(alpha: .12),
                    child: Icon(
                      icon,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: notification.isRead
                                ? FontWeight.bold
                                : FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(notification.createdAt),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (isInvitation && isPending) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => ref
                          .read(notificationViewModelProvider.notifier)
                          .rejectInvitation(notification),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text("Reject"),
                    ),
                    const SizedBox(width: 12),
                    // Wrapped in SizedBox to prevent "Infinite Width" crash
                    SizedBox(
                      width: 100,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => ref
                            .read(notificationViewModelProvider.notifier)
                            .acceptInvitation(notification, context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: Size.zero, // Override global theme
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Accept"),
                      ),
                    ),
                  ],
                ),
              ] else if (isInvitation && !isPending) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: notification.status == 'accepted' 
                        ? Colors.green.withValues(alpha: 0.1) 
                        : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Invitation ${notification.status}",
                      style: TextStyle(
                        color: notification.status == 'accepted'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (notification.type) {
      case NotificationType.task:
        return Colors.green;
      case NotificationType.project:
        return Colors.blue;
      case NotificationType.meeting:
        return Colors.orange;
      case NotificationType.comment:
        return Colors.teal;
      case NotificationType.member:
        return Colors.indigo;
      case NotificationType.invitation:
        return Colors.purple;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.task:
        return Icons.task_alt;
      case NotificationType.project:
        return Icons.folder_copy;
      case NotificationType.meeting:
        return Icons.notifications_active;
      case NotificationType.comment:
        return Icons.comment;
      case NotificationType.member:
        return Icons.person_add_alt_1;
      case NotificationType.invitation:
        return Icons.mail_outline;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hr";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}
