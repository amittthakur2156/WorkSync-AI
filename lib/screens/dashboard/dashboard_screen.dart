import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worksync_ai/core/constants/enums.dart';
import 'package:worksync_ai/core/routes/app_routes.dart';
import 'package:worksync_ai/core/providers/notification_providers.dart';
import 'package:worksync_ai/widgets/shimmers/dashboard_shimmer.dart';
import 'dashboard_view_model.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/task_card.dart';
import 'widgets/project_card.dart';

class DashboardScreen extends ConsumerWidget {
  final ValueChanged<int> onTabChange;

  const DashboardScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    final notificationsAsync = ref.watch(myNotificationsProvider);

    if (state.isLoading && state.projectsCount == 0 && state.tasksCount == 0) {
      return const Scaffold(
        body: DashboardShimmer(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "WorkSync AI",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    context.push(AppRoutes.notifications);
                  },
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
                notificationsAsync.when(
                  data: (notifications) {
                    final unreadCount =
                        notifications.where((n) => !n.isRead).length;
                    if (unreadCount == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardViewModelProvider);
          // Wait a bit for the animation to look smooth
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
                    .read(dashboardViewModelProvider.notifier)
                    .updateSearchQuery(val),
                decoration: InputDecoration(
                  hintText: "Search projects, tasks...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// AI Insights Section
              _buildAIInsightsSection(context, state.workspaceInsight),

              const SizedBox(height: 30),

              /// Overview Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Overview",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () => onTabChange(1),
                      child: const Text("See All")),
                ],
              ),

              const SizedBox(height: 15),

              /// Statistics Cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  DashboardCard(
                    title: "Projects",
                    value: state.projectsCount.toString(),
                    icon: Icons.folder_copy_outlined,
                    color: Colors.blue,
                    onTap: () => onTabChange(1),
                  ),
                  DashboardCard(
                    title: "Tasks",
                    value: state.tasksCount.toString(),
                    icon: Icons.task_alt,
                    color: Colors.orange,
                    onTap: () => onTabChange(2),
                  ),
                  DashboardCard(
                    title: "Completed",
                    value: state.completedTasksCount.toString(),
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                    onTap: () => onTabChange(2),
                  ),
                  DashboardCard(
                    title: "Pending",
                    value: state.pendingTasksCount.toString(),
                    icon: Icons.pending_actions,
                    color: Colors.red,
                    onTap: () => onTabChange(2),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Today's Tasks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Tasks",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () => onTabChange(2),
                      child: const Text("See All")),
                ],
              ),

              const SizedBox(height: 15),

              if (state.todaysTasks.isEmpty)
                _buildEmptyState("No tasks for today! Reach for the stars 🚀")
              else
                ...state.todaysTasks.map((task) => TaskCard(
                      title: task.title,
                      project: task.projectId.length > 8
                          ? "Project: ${task.projectId.substring(0, 8)}..."
                          : "Project: ${task.projectId}",
                      status: task.status == TaskStatus.done
                          ? "Done"
                          : task.status == TaskStatus.inProgress
                              ? "In Progress"
                              : "To Do",
                      statusColor: task.status == TaskStatus.done
                          ? Colors.green
                          : task.status == TaskStatus.inProgress
                              ? Colors.orange
                              : Colors.grey,
                      icon: task.status == TaskStatus.done
                          ? Icons.check_circle
                          : task.status == TaskStatus.inProgress
                              ? Icons.autorenew
                              : Icons.circle_outlined,
                      onTap: () => context.push(AppRoutes.taskDetailsPath(task.id)),
                    )),

              const SizedBox(height: 30),

              /// Recent Projects
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Projects",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () => onTabChange(1),
                      child: const Text("See All")),
                ],
              ),

              const SizedBox(height: 15),

              if (state.recentProjects.isEmpty)
                _buildEmptyState("No projects yet. Start something amazing! ✨")
              else
                ...state.recentProjects.map((project) => ProjectCard(
                      icon: project.icon,
                      color: project.color,
                      title: project.title,
                      subtitle: project.description.length > 30
                          ? "${project.description.substring(0, 30)}..."
                          : project.description,
                      progress: project.progress,
                      onTap: () => context.push(AppRoutes.projectDetailsPath(project.id)),
                    )),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('${AppRoutes.projects}/${AppRoutes.projectCreate}');
        },
        backgroundColor: const Color(0xff1055DC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAIInsightsSection(BuildContext context, String insight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff1055DC), Color(0xff642AFB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1055DC).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                "AI Workspace Insights",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            insight,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.push(AppRoutes.aiAssistant),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xff1055DC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text("View All Insights"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Icon(Icons.auto_awesome_motion_outlined, 
              size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
