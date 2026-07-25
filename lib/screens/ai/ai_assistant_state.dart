import 'package:worksync_ai/domain/entities/ai_message_entity.dart';

class AiAssistantState {
  final bool isTyping;
  final List<AiMessageEntity> messages;
  final String? errorMessage;

  const AiAssistantState({
    this.isTyping = false,
    this.messages = const [],
    this.errorMessage,
  });

  AiAssistantState copyWith({
    bool? isTyping,
    List<AiMessageEntity>? messages,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AiAssistantState(
      isTyping: isTyping ?? this.isTyping,
      messages: messages ?? this.messages,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
