import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/auth_providers.dart';
import 'package:worksync_ai/core/providers/notification_providers.dart';
import 'package:worksync_ai/domain/entities/app_user_entity.dart';
import 'member_selection_view_model.dart';

class MemberSearchSheet extends ConsumerStatefulWidget {
  final String? projectId;
  final String? projectTitle;
  final ValueChanged<AppUserEntity>? onUserSelected;

  const MemberSearchSheet({
    super.key,
    this.projectId,
    this.projectTitle,
    this.onUserSelected,
  });

  @override
  ConsumerState<MemberSearchSheet> createState() => _MemberSearchSheetState();
}

class _MemberSearchSheetState extends ConsumerState<MemberSearchSheet> {
  final _controller = TextEditingController();
  AppUserEntity? _selectedUser;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePrimaryAction(AppUserEntity user, AppUserEntity? currentUser) async {
    if (widget.onUserSelected != null) {
      widget.onUserSelected!(user);
      Navigator.pop(context);
      return;
    }

    if (currentUser == null || widget.projectId == null) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await ref.read(notificationUsecasesProvider).sendInvitation(
            targetUserId: user.uid,
            projectId: widget.projectId!,
            projectTitle: widget.projectTitle ?? 'Project',
            senderName: currentUser.name,
          );

      if (mounted) {
        navigator.pop();
        messenger.showSnackBar(
          const SnackBar(
            content: Text("Invitation sent! 🎉"),
            backgroundColor: Colors.indigo,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResult = ref.watch(memberSelectionViewModelProvider);
    final currentUser = ref.watch(authStateProvider).value;

    // Auto-select if a user is found
    searchResult.whenData((users) {
      if (users.isNotEmpty && _selectedUser == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedUser = users.first);
        });
      } else if (users.isEmpty && _selectedUser != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedUser = null);
        });
      }
    });

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.onUserSelected != null ? "Add Team Member" : "Invite Member",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Search users by their registered email address.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) {
              ref
                  .read(memberSelectionViewModelProvider.notifier)
                  .onQueryChanged(val.trim());
              // Reset selection while typing new query
              if (_selectedUser != null) setState(() => _selectedUser = null);
            },
            decoration: InputDecoration(
              hintText: "example@gmail.com",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Flexible(
            child: SingleChildScrollView(
              child: searchResult.when(
                data: (users) {
                  if (_controller.text.length < 3) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("Type at least 3 characters to search",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }

                  if (users.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No user exists with this email",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }

                  return Column(
                    children: users.map((user) {
                      final isSelected = _selectedUser?.uid == user.uid;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedUser = user),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.indigo.withValues(alpha: .05) : Colors.white,
                            border: Border.all(
                                color: isSelected ? Colors.indigo : Colors.grey.shade200,
                                width: isSelected ? 2 : 1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.indigo.shade50,
                                backgroundImage: (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                                    ? NetworkImage(user.photoUrl!)
                                    : null,
                                child: (user.photoUrl == null || user.photoUrl!.isEmpty)
                                    ? Text(user.name[0].toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.bold))
                                    : null,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 15),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    Text(user.email,
                                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle, color: Colors.indigo, size: 24),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        CircularProgressIndicator(strokeWidth: 3),
                        SizedBox(height: 16),
                        Text("Searching for users...", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Search error. Try again.",
                        style: TextStyle(color: Colors.red.shade300)),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // The requested "Add/Invite" button that enables only when a user is selected
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _selectedUser == null
                  ? null
                  : () => _handlePrimaryAction(_selectedUser!, currentUser),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                widget.onUserSelected != null ? "Add Member" : "Send Invitation",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
