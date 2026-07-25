import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worksync_ai/core/constants/enums.dart';
import 'package:worksync_ai/core/providers/task_providers.dart';
import 'package:worksync_ai/screens/tasks/task_form_view_model.dart';
import 'package:worksync_ai/screens/tasks/task_form_state.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final String taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final task = await ref.read(taskByIdProvider(widget.taskId).future);
      if (task != null) {
        _titleController.text = task.title;
        _descriptionController.text = task.description;
        ref.read(taskFormViewModelProvider.notifier).initForEdit(task);
      }
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

    ref.listen<TaskFormState>(taskFormViewModelProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task updated successfully!")),
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
          "Edit Task",
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

            const Text("Status", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: TaskStatus.values.map((s) => ChoiceChip(
                label: Text(s.value.toUpperCase().replaceAll('_', ' ')),
                selected: state.status == s,
                onSelected: (_) => ref.read(taskFormViewModelProvider.notifier).updateStatus(s),
              )).toList(),
            ),

            const SizedBox(height: 20),

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
                onPressed: state.isLoading ? null : () => ref.read(taskFormViewModelProvider.notifier).saveTask(taskId: widget.taskId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1055DC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: state.isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Save Changes", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
