import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worksync_ai/core/routes/app_routes.dart';
import 'package:worksync_ai/widgets/shimmers/project_list_shimmer.dart';
import 'project_view_model.dart';
import 'widgets/project_tile.dart';
import 'widgets/section_title.dart';
import 'widgets/empty_project_widget.dart';

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Projects",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('${AppRoutes.projects}/${AppRoutes.projectCreate}'),
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: state.isLoading
          ? const ProjectListShimmer()
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(projectViewModelProvider);
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
                          .read(projectViewModelProvider.notifier)
                          .updateSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: "Search Projects...",
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

                    if (state.activeProjects.isEmpty && state.completedProjects.isEmpty)
                      const EmptyProjectWidget()
                    else ...[
                      /// Active Projects
                      if (state.activeProjects.isNotEmpty) ...[
                        SectionTitle(
                          title: "Active Projects",
                          onSeeAll: () {},
                        ),
                        const SizedBox(height: 15),
                        ...state.activeProjects.map((project) => ProjectTile(
                              title: project.title,
                              description: project.description,
                              progress: project.progress,
                              tasks: 0, // In a real app, count from tasksForProjectProvider
                              members: project.memberIds.length,
                              color: project.color,
                              icon: project.icon,
                              onTap: () => context.push(AppRoutes.projectDetailsPath(project.id)),
                            )),
                        const SizedBox(height: 30),
                      ],

                      /// Completed Projects
                      if (state.completedProjects.isNotEmpty) ...[
                        SectionTitle(
                          title: "Completed Projects",
                          onSeeAll: () {},
                        ),
                        const SizedBox(height: 15),
                        ...state.completedProjects.map((project) => ProjectTile(
                              title: project.title,
                              description: project.description,
                              progress: project.progress,
                              tasks: 0, 
                              members: project.memberIds.length,
                              color: project.color,
                              icon: project.icon,
                              onTap: () => context.push(AppRoutes.projectDetailsPath(project.id)),
                            )),
                      ],
                    ],

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1055DC),
        onPressed: () => context.push('${AppRoutes.projects}/${AppRoutes.projectCreate}'),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
