import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_view_model.dart';
import 'notification_state.dart';
import 'widgets/notification_section.dart';
import 'widgets/notification_tile.dart';
import 'widgets/empty_notification_widget.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: state.notifications.isEmpty
                ? null
                : () => ref
                    .read(notificationViewModelProvider.notifier)
                    .markAllAsRead(),
            icon: const Icon(Icons.done_all, color: Colors.black),
            tooltip: "Mark all as read",
          ),
        ],
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, NotificationState state) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.notifications.isEmpty) {
      return const EmptyNotificationWidget();
    }

    // Flatten the notifications into a list of widgets (sections + tiles)
    final List<Widget> listItems = [];
    final grouped = _groupNotifications(state.notifications);

    for (var entry in grouped.entries) {
      listItems.add(NotificationSection(title: entry.key));
      for (var notification in entry.value) {
        listItems.add(
          NotificationTile(
            key: ValueKey(notification.id),
            notification: notification,
            onTap: () {
              if (!notification.isRead) {
                ref.read(notificationViewModelProvider.notifier).markAsRead(notification.id);
              }
            },
          ),
        );
      }
      listItems.add(const SizedBox(height: 16));
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(notificationViewModelProvider);
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: listItems.length,
        itemBuilder: (context, index) => listItems[index],
      ),
    );
  }

  Map<String, List<NotificationEntity>> _groupNotifications(List<NotificationEntity> notifications) {
    final Map<String, List<NotificationEntity>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var n in notifications) {
      final date = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      String key = (date == today) ? "Today" : (date == yesterday) ? "Yesterday" : "Older";
      grouped.putIfAbsent(key, () => []).add(n);
    }
    return grouped;
  }
}
