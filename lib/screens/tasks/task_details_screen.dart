import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:worksync_ai/core/constants/enums.dart';
import 'package:worksync_ai/core/routes/app_routes.dart';
import 'package:worksync_ai/screens/tasks/task_details_view_model.dart';
import 'widgets/priority_badge.dart';
import 'widgets/task_status_chip.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskDetailsProvider(taskId));
    final actionsState = ref.watch(taskActionsViewModelProvider);

    ref.listen(taskActionsViewModelProvider, (previous, next) {
      if (next is AsyncData && previous is AsyncLoading) {
        // If we were deleting, we should probably go back
        // For status update, we just stay here
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString()), backgroundColor: Colors.red),
        );
      }
    });

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.task == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(state.errorMessage ?? "Task not found")),
      );
    }

    final task = state.task!;

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Task Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () => context.push(AppRoutes.taskEditPath(taskId)),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriorityBadge(priority: task.priority.value.toUpperCase()),
                    TaskStatusChip(status: task.status.value.toUpperCase().replaceAll('_', ' ')),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  task.title,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  task.description.isEmpty ? "No description provided." : task.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),
                _buildDetailRow(Icons.calendar_today, "Due Date", 
                  task.dueDate != null ? DateFormat('MMM d, yyyy').format(task.dueDate!) : "No due date"),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.folder_outlined, "Project", "Project ID: ${task.projectId}"),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.person_outline, "Assignees", "${task.assigneeIds.length} members"),
                
                const SizedBox(height: 40),
                const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    if (task.status != TaskStatus.done)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => ref.read(taskActionsViewModelProvider.notifier).updateStatus(taskId, TaskStatus.done),
                          icon: const Icon(Icons.check),
                          label: const Text("Mark Done"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    if (task.status == TaskStatus.todo) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => ref.read(taskActionsViewModelProvider.notifier).updateStatus(taskId, TaskStatus.inProgress),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Start"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (actionsState is AsyncLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.indigo, size: 20),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task?"),
        content: const Text("Are you sure you want to delete this task? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              context.pop();
              await ref.read(taskActionsViewModelProvider.notifier).deleteTask(taskId);
              if (context.mounted) context.pop();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
