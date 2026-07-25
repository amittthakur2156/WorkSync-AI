import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ai_assistant_view_model.dart';

class AIMessageInput extends ConsumerStatefulWidget {
  const AIMessageInput({super.key});

  @override
  ConsumerState<AIMessageInput> createState() => _AIMessageInputState();
}

class _AIMessageInputState extends ConsumerState<AIMessageInput> {
  final _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      ref.read(aiAssistantViewModelProvider.notifier).sendMessage(text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiAssistantViewModelProvider);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: state.isTyping ? null : (_) => _submit(),
                decoration: InputDecoration(
                  hintText: "Ask about your workspace...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: state.isTyping ? null : _submit,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: state.isTyping 
                  ? Colors.grey 
                  : Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
