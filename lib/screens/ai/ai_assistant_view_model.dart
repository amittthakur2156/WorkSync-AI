import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:worksync_ai/core/providers/ai_providers.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'package:worksync_ai/core/providers/task_providers.dart';
import 'package:worksync_ai/domain/entities/ai_message_entity.dart';
import 'ai_assistant_state.dart';

class AiAssistantViewModel extends Notifier<AiAssistantState> {
  final _uuid = const Uuid();

  @override
  AiAssistantState build() {
    return AiAssistantState(
      messages: [
        AiMessageEntity(
          id: _uuid.v4(),
          text: 'Hello 👋 I am your WorkSync AI Assistant. How can I help you today?',
          isUser: false,
          timestamp: DateTime.now(),
        )
      ],
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = AiMessageEntity(
      id: _uuid.v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
      clearError: true,
    );

    try {
      final projects = ref.read(myProjectsProvider).value ?? [];
      final tasks = ref.read(myTasksProvider).value ?? [];

      final response = await ref.read(aiServiceProvider).getChatResponse(
            prompt: text,
            projects: projects,
            tasks: tasks,
          );

      final aiMessage = AiMessageEntity(
        id: _uuid.v4(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isTyping: false,
      );
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        errorMessage: e.toString(),
      );
    }
  }

  void processPrompt(String prompt) {
    sendMessage(prompt);
  }
}

final aiAssistantViewModelProvider =
    NotifierProvider<AiAssistantViewModel, AiAssistantState>(
  AiAssistantViewModel.new,
);
