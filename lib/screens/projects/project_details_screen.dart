import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worksync_ai/core/routes/app_routes.dart';
import 'package:worksync_ai/core/providers/auth_providers.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'package:worksync_ai/domain/entities/app_user_entity.dart';
import 'package:worksync_ai/screens/projects/project_details_view_model.dart';
import 'package:worksync_ai/screens/projects/widgets/member_search_sheet.dart';
import '../../widgets/shimmers/task_details_shimmer.dart';

class ProjectDetailsScreen extends ConsumerWidget {
  final String projectId;

  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectDetailsProvider(projectId));
    final currentUser = ref.watch(authStateProvider).value;

    if (state.isLoading && state.project == null) {
      return const Scaffold(
        body: TaskDetailsShimmer(),
      );
    }

    if (state.errorMessage != null || state.project == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(state.errorMessage ?? 'Project not found')),
      );
    }

    final project = state.project!;

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Project Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () => context.push('${AppRoutes.projects}/$projectId/edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              project.description,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),

            /// Tasks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tasks",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    context.push('${AppRoutes.tasks}/${AppRoutes.taskCreate}?projectId=$projectId');
                  },
                  child: const Text("Add Task"),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            if (state.tasks.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("No tasks for this project yet."),
                ),
              )
            else
              ...state.tasks.map((task) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      task.status.value == 'done'
                          ? Icons.check_circle
                          : task.status.value == 'in_progress'
                              ? Icons.autorenew
                              : Icons.circle_outlined,
                      color: task.status.value == 'done'
                          ? Colors.green
                          : task.status.value == 'in_progress'
                              ? Colors.orange
                              : Colors.grey,
                    ),
                    title: Text(task.title),
                    subtitle: Text(task.status.value.toUpperCase().replaceAll('_', ' ')),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push(AppRoutes.taskDetailsPath(task.id)),
                  )),

            const SizedBox(height: 30),

            /// Team Members
            const Text(
              "Team Members",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Consumer(
              builder: (context, ref, _) {
                final membersAsync = ref.watch(projectMembersProvider(project.memberIds));
                return membersAsync.when(
                  data: (members) => Row(
                    children: [
                      ...members.map((user) => _memberAvatar(user)),
                      _addMemberButton(context, ref, currentUser, project.title),
                    ],
                  ),
                  loading: () => const SizedBox(
                    height: 44,
                    width: 44,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (e, _) => Text("Error loading members: $e"),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _memberAvatar(AppUserEntity user) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Tooltip(
        message: user.name,
        child: CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xff1055DC).withValues(alpha: 0.1),
          backgroundImage: (user.photoUrl != null && user.photoUrl!.isNotEmpty)
              ? NetworkImage(user.photoUrl!)
              : null,
          child: (user.photoUrl == null || user.photoUrl!.isEmpty)
              ? Text(
                  user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : '?',
                  style: const TextStyle(
                    color: Color(0xff1055DC),
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _addMemberButton(BuildContext context, WidgetRef ref, dynamic currentUser, String projectTitle) {
    return InkWell(
      onTap: () => _showAddMemberSheet(context, ref, currentUser, projectTitle),
      child: const CircleAvatar(
        radius: 22,
        backgroundColor: Color(0xffE0E0E0),
        child: Icon(Icons.add, color: Colors.black54),
      ),
    );
  }

  void _showAddMemberSheet(BuildContext context, WidgetRef ref, dynamic currentUser, String projectTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MemberSearchSheet(
        projectId: projectId,
        projectTitle: projectTitle,
      ),
    );
  }
}
