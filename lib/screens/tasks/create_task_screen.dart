import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worksync_ai/core/constants/enums.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'package:worksync_ai/screens/tasks/task_form_view_model.dart';
import 'package:worksync_ai/screens/tasks/task_form_state.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectId = GoRouterState.of(context).uri.queryParameters['projectId'];
      ref.read(taskFormViewModelProvider.notifier).initForCreate(projectId);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskFormViewModelProvider);
    final projectsAsync = ref.watch(myProjectsProvider);

    ref.listen<TaskFormState>(taskFormViewModelProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task created successfully!")),
        );
        context.pop();
      } else if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Create Task",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Task Name", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              onChanged: ref.read(taskFormViewModelProvider.notifier).updateTitle,
              decoration: InputDecoration(
                hintText: "Enter task name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Description", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              onChanged: ref.read(taskFormViewModelProvider.notifier).updateDescription,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Task description",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Project", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            projectsAsync.when(
              data: (projects) => DropdownButtonFormField<String>(
                initialValue: state.projectId,
                hint: const Text("Select Project"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
                items: projects.map((p) => DropdownMenuItem(value: p.id, child: Text(p.title))).toList(),
                onChanged: ref.read(taskFormViewModelProvider.notifier).updateProject,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (err, stack) => const Text("Error loading projects. Please try again.", style: TextStyle(color: Colors.red)),
            ),

            const SizedBox(height: 20),

            const Text("Due Date", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2035),
                );
                ref.read(taskFormViewModelProvider.notifier).updateDueDate(date);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(
                      state.dueDate == null
                          ? "Select Due Date"
                          : "${state.dueDate!.day}/${state.dueDate!.month}/${state.dueDate!.year}",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text("Priority", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: TaskPriority.values.map((p) => ChoiceChip(
                label: Text(p.value.toUpperCase()),
                selected: state.priority == p,
                onSelected: (_) => ref.read(taskFormViewModelProvider.notifier).updatePriority(p),
              )).toList(),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : () => ref.read(taskFormViewModelProvider.notifier).saveTask(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1055DC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: state.isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Create Task", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
