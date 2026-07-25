import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_assistant_view_model.dart';
import 'ai_assistant_state.dart';
import 'widgets/ai_chat_bubble.dart';
import 'widgets/ai_message_input.dart';
import 'widgets/ai_prompt_card.dart';
import 'widgets/ai_typing_indicator.dart';

class AIAssistantScreen extends ConsumerStatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  ConsumerState<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends ConsumerState<AIAssistantScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiAssistantViewModelProvider);

    ref.listen<AiAssistantState>(aiAssistantViewModelProvider, (previous, next) {
      if (next.messages.length != previous?.messages.length || next.isTyping != previous?.isTyping) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }

      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        title: const Text("AI Assistant"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    "Suggested Prompts",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        AIPromptCard(
                          icon: Icons.task_alt,
                          title: "Summarize today",
                          onTap: () => ref.read(aiAssistantViewModelProvider.notifier).processPrompt("Summarize today's tasks"),
                        ),
                        const SizedBox(width: 10),
                        AIPromptCard(
                          icon: Icons.bar_chart,
                          title: "Project progress",
                          onTap: () => ref.read(aiAssistantViewModelProvider.notifier).processPrompt("Show project progress"),
                        ),
                        const SizedBox(width: 10),
                        AIPromptCard(
                          icon: Icons.help_outline,
                          title: "How to use",
                          onTap: () => ref.read(aiAssistantViewModelProvider.notifier).processPrompt("How can you help me?"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  ...state.messages.map((msg) => AIChatBubble(
                        message: msg.text,
                        isUser: msg.isUser,
                      )),
                  if (state.isTyping) const AITypingIndicator(),
                ],
              ),
            ),
            const AIMessageInput(),
          ],
        ),
      ),
    );
  }
}
