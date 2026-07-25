import 'package:flutter/foundation.dart';

@immutable
class AiMessageEntity {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const AiMessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
