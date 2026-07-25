import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'create_project_view_model.dart';
import 'create_project_state.dart';
import 'widgets/member_search_sheet.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  ConsumerState<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _aiPromptController = TextEditingController();

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
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _aiPromptController.dispose();
    super.dispose();
  }

  void _showAddMemberSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => MemberSearchSheet(
        onUserSelected: (user) {
          ref.read(createProjectViewModelProvider.notifier).addMember(user);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createProjectViewModelProvider);

    ref.listen<CreateProjectState>(createProjectViewModelProvider, (previous, next) {
      if (next.isSuccess && previous?.isSuccess != true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Project created successfully!")));
        context.pop();
      }
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red));
      }
      if (previous?.isLoading == true && !next.isLoading && next.projectName.isNotEmpty && next.projectName != previous?.projectName) {
        _projectNameController.text = next.projectName;
        _descriptionController.text = next.description;
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Create Project", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// AI Project Generator
            _buildAISection(state),
            const SizedBox(height: 30),

            /// Project Name
            const Text("Project Name", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _projectNameController,
              onChanged: (v) => ref.read(createProjectViewModelProvider.notifier).updateProjectName(v),
              decoration: InputDecoration(
                hintText: "Enter project name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            /// Description
            const Text("Description", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              onChanged: (v) => ref.read(createProjectViewModelProvider.notifier).updateDescription(v),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Project description",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 25),

            /// Style Selection
            const Text("Project Style", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  final isSelected = state.selectedColor == color;
                  return GestureDetector(
                    onTap: () => ref.read(createProjectViewModelProvider.notifier).updateColor(color),
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
                    onTap: () => ref.read(createProjectViewModelProvider.notifier).updateIcon(icon),
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
            const SizedBox(height: 25),

            /// Team Members
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Team Members (Max 4)", style: TextStyle(fontWeight: FontWeight.w600)),
                if (state.selectedMembers.length < 4)
                  TextButton.icon(onPressed: _showAddMemberSheet, icon: const Icon(Icons.add, size: 18), label: const Text("Add Member")),
              ],
            ),
            const SizedBox(height: 8),
            if (state.selectedMembers.isEmpty)
              const Text("No members added yet", style: TextStyle(color: Colors.grey, fontSize: 14))
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: state.selectedMembers.map((user) => Chip(
                  avatar: CircleAvatar(
                    backgroundImage: (user.photoUrl != null && user.photoUrl!.isNotEmpty) ? NetworkImage(user.photoUrl!) : null,
                    child: (user.photoUrl == null || user.photoUrl!.isEmpty) ? const Icon(Icons.person, size: 16) : null,
                  ),
                  label: Text(user.name),
                  onDeleted: () => ref.read(createProjectViewModelProvider.notifier).removeMember(user.uid),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
                )).toList(),
              ),
            const SizedBox(height: 40),

            /// Create Button
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : () => ref.read(createProjectViewModelProvider.notifier).createProject(),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff1055DC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: state.isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Create Project", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAISection(CreateProjectState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xff1055DC).withValues(alpha: 0.15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [CircleAvatar(radius: 18, backgroundColor: Color(0xff1055DC), child: Icon(Icons.auto_awesome, color: Colors.white, size: 20)), SizedBox(width: 10), Text("AI Project Generator", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 10),
          const Text("Describe your idea in one sentence and AI will prepare the project for you.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          TextField(
            controller: _aiPromptController,
            onChanged: (v) => ref.read(createProjectViewModelProvider.notifier).updateAiPrompt(v),
            maxLines: 2,
            decoration: InputDecoration(hintText: "Example: Create a Food Delivery App.", filled: true, fillColor: const Color(0xffF7F9FC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: state.isLoading ? null : () => ref.read(createProjectViewModelProvider.notifier).generateWithAI(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff1055DC).withValues(alpha: 0.05), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.auto_awesome, color: Colors.blueAccent),
              label: const Text("Generate with AI", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
