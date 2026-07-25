import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worksync_ai/core/routes/app_routes.dart';
import 'package:worksync_ai/widgets/shimmers/task_list_shimmer.dart';
import 'task_view_model.dart';
import 'widgets/task_section_title.dart';
import 'widgets/task_tile.dart';
import 'widgets/empty_task_widget.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Tasks",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('${AppRoutes.tasks}/${AppRoutes.taskCreate}'),
            icon: const Icon(
              Icons.add_task_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1055DC),
        onPressed: () => context.push('${AppRoutes.tasks}/${AppRoutes.taskCreate}'),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: state.isLoading
          ? const TaskListShimmer()
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(taskViewModelProvider);
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Search
                    TextField(
                      onChanged: (val) => ref
                          .read(taskViewModelProvider.notifier)
                          .updateSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: "Search Tasks...",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: const Icon(Icons.tune),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    if (state.todaysTasks.isEmpty && state.upcomingTasks.isEmpty)
                      const EmptyTaskWidget()
                    else ...[
                      /// Today's Tasks
                      if (state.todaysTasks.isNotEmpty) ...[
                        TaskSectionTitle(
                          title: "Today's Tasks",
                          onSeeAll: () {},
                        ),
                        const SizedBox(height: 15),
                        ...state.todaysTasks.map((task) => TaskTile(
                              title: task.title,
                              project: "Project ID: ${task.projectId.length > 5 ? task.projectId.substring(0, 5) : task.projectId}...",
                              dueDate: "Today",
                              priority: task.priority.value.toUpperCase(),
                              status: task.status.value,
                              icon: Icons.task_alt,
                              color: _getPriorityColor(task.priority.value),
                              onTap: () => context.push(AppRoutes.taskDetailsPath(task.id)),
                            )),
                        const SizedBox(height: 30),
                      ],

                      /// Upcoming Tasks
                      if (state.upcomingTasks.isNotEmpty) ...[
                        TaskSectionTitle(
                          title: "Upcoming Tasks",
                          onSeeAll: () {},
                        ),
                        const SizedBox(height: 15),
                        ...state.upcomingTasks.map((task) => TaskTile(
                              title: task.title,
                              project: "Project ID: ${task.projectId.length > 5 ? task.projectId.substring(0, 5) : task.projectId}...",
                              dueDate: task.dueDate != null 
                                  ? "${task.dueDate!.day}/${task.dueDate!.month}"
                                  : "No Date",
                              priority: task.priority.value.toUpperCase(),
                              status: task.status.value,
                              icon: Icons.calendar_today,
                              color: _getPriorityColor(task.priority.value),
                              onTap: () => context.push(AppRoutes.taskDetailsPath(task.id)),
                            )),
                      ],
                    ],

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
