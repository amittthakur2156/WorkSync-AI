import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worksync_ai/core/constants/enums.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'edit_project_view_model.dart';
import 'edit_project_state.dart';

class EditProjectScreen extends ConsumerStatefulWidget {
  final String projectId;
  const EditProjectScreen({super.key, required this.projectId});

  @override
  ConsumerState<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  ProjectStatus _status = ProjectStatus.active;

  final List<Color> _colors = [
    const Color(0xFF6366F1),
    const Color(0xFF0EA5E9),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
    const Color(0xFFEF4444),
    const Color(0xFF8B5CF6),
    const Color(0xFFEC4899),
  ];

  final List<IconData> _icons = [
    Icons.folder,
    Icons.rocket_launch,
    Icons.computer,
    Icons.brush,
    Icons.attach_money,
    Icons.campaign,
    Icons.event_note,
    Icons.auto_awesome,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final project = await ref.read(projectByIdProvider(widget.projectId).future);
      if (project != null) {
        setState(() {
          _titleController.text = project.title;
          _descriptionController.text = project.description;
          _status = project.status;
        });
        ref.read(editProjectViewModelProvider.notifier).init(project);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    
    final project = ref.read(projectByIdProvider(widget.projectId)).value;
    if (project == null) return;

    final state = ref.read(editProjectViewModelProvider);

    ref.read(editProjectViewModelProvider.notifier).updateProject(
      project.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        status: _status,
        color: state.selectedColor,
        icon: state.selectedIcon,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Project?"),
        content: const Text("This will permanently remove the project and all its tasks."),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              context.pop();
              ref.read(editProjectViewModelProvider.notifier).deleteProject(widget.projectId);
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProjectViewModelProvider);

    ref.listen<EditProjectState>(editProjectViewModelProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project updated successfully!")),
        );
        context.pop();
      } else if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Project"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Project Title", border: OutlineInputBorder()),
                validator: (v) => (v?.isEmpty ?? true) ? "Required" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 25),

              const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ProjectStatus.values.map((s) => ChoiceChip(
                  label: Text(s.value.toUpperCase()),
                  selected: _status == s,
                  onSelected: (val) => setState(() => _status = s),
                )).toList(),
              ),
              const SizedBox(height: 30),

              const Text("Project Style", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = state.selectedColor == color;
                    return GestureDetector(
                      onTap: () => ref.read(editProjectViewModelProvider.notifier).updateColor(color),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 50,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
                        ),
                        child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 55,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _icons.length,
                  itemBuilder: (context, index) {
                    final icon = _icons[index];
                    final isSelected = state.selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => ref.read(editProjectViewModelProvider.notifier).updateIcon(icon),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 55,
                        decoration: BoxDecoration(
                          color: isSelected ? state.selectedColor.withValues(alpha: 0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? state.selectedColor : Colors.grey.shade300),
                        ),
                        child: Icon(icon, color: isSelected ? state.selectedColor : Colors.grey),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _handleSave,
                  child: state.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("Update Project"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
