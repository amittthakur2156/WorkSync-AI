import 'package:worksync_ai/domain/entities/project_entity.dart';
import 'package:worksync_ai/domain/entities/task_entity.dart';
import 'package:worksync_ai/core/constants/enums.dart';

/// Service that simulates AI logic by analyzing real workspace data.
class AiService {
  /// Generates a summary for the Dashboard "AI Insights" section.
  String generateWorkspaceInsight({
    required List<ProjectEntity> projects,
    required List<TaskEntity> tasks,
  }) {
    if (projects.isEmpty && tasks.isEmpty) {
      return "Welcome to WorkSync AI! Start by creating a project or task to get personalized insights.";
    }

    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.status == TaskStatus.done).length;
    final efficiency = totalTasks > 0 ? (completedTasks / totalTasks * 100).toInt() : 0;

    final pendingTasks = tasks.where((t) => t.status != TaskStatus.done).toList();
    final highPriority = pendingTasks.where((t) => t.priority == TaskPriority.high).toList();

    if (highPriority.isNotEmpty) {
      return "Critical: You have ${highPriority.length} high-priority tasks pending. focus on '${highPriority.first.title}' to boost your current $efficiency% efficiency.";
    }

    if (pendingTasks.isNotEmpty) {
      return "Your workspace efficiency is at $efficiency%. You have ${pendingTasks.length} tasks across ${projects.length} projects to tackle next.";
    }

    return "Peak Productivity! 🚀 100% of your current tasks are completed. You're ready to start a new project.";
  }

  /// Processes a chat prompt and returns an AI response based on data.
  Future<String> getChatResponse({
    required String prompt,
    required List<ProjectEntity> projects,
    required List<TaskEntity> tasks,
  }) async {
    // Simulate thinking delay
    await Future.delayed(const Duration(milliseconds: 800));

    final query = prompt.toLowerCase();

    // Workload analysis
    if (query.contains('workload') || query.contains('analyze')) {
      final pending = tasks.where((t) => t.status != TaskStatus.done).length;
      if (pending == 0) return "Your workload is light! All tasks are completed.";
      if (pending > 10) return "Your workload is heavy with $pending pending tasks. I recommend delegating or rescheduling low-priority items.";
      return "Your workload is manageable. You have $pending tasks to complete.";
    }

    if (query.contains('summarize') || query.contains('today')) {
      final now = DateTime.now();
      final todayTasks = tasks.where((t) {
        if (t.dueDate == null) return false;
        return t.dueDate!.day == now.day && t.dueDate!.month == now.month && t.dueDate!.year == now.year;
      }).toList();

      if (todayTasks.isEmpty) return "You don't have any specific tasks for today. Why not use this time to organize your upcoming projects?";
      final list = todayTasks.map((t) => "• ${t.title} [${t.priority.value.toUpperCase()}]").join('\n');
      return "Here is your agenda for today:\n$list";
    }

    if (query.contains('progress') || query.contains('status')) {
      if (projects.isEmpty) return "You haven't started any projects yet. Ready to create your first one?";
      final list = projects.map((p) => "• ${p.title}: ${(p.progress * 100).toInt()}% complete").join('\n');
      return "Workspace Health Report:\n$list";
    }

    if (query.contains('help') || query.contains('hi') || query.contains('hello')) {
      return "Hello! I am your WorkSync AI. I can analyze your workload, summarize today's agenda, or check your project health. Try asking 'Analyze my workload'!";
    }

    return "I understood your query, but I need more data to be specific. You can ask me to 'summarize today', 'show progress', or 'analyze my workload'.";
  }
}
