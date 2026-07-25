import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/task_providers.dart';
import 'task_state.dart';

class TaskSearchQuery extends Notifier<String> {
  @override
  String build() => '';
  set query(String val) => state = val;
}

final taskSearchQueryProvider = NotifierProvider<TaskSearchQuery, String>(
  TaskSearchQuery.new,
);

class TaskViewModel extends Notifier<TaskState> {
  @override
  TaskState build() {
    final tasksAsync = ref.watch(myTasksProvider);
    final searchQuery = ref.watch(taskSearchQueryProvider);

    final allTasks = tasksAsync.value ?? [];

    final query = searchQuery.toLowerCase();
    final filtered = allTasks.where((t) =>
        t.title.toLowerCase().contains(query) ||
        t.description.toLowerCase().contains(query)).toList();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final todayTasks = filtered.where((t) {
      if (t.dueDate == null) return false;
      final d = t.dueDate!;
      return d.year == today.year && d.month == today.month && d.day == today.day;
    }).toList();

    final upcoming = filtered.where((t) {
      if (t.dueDate == null) return true; // If no due date, consider upcoming for now
      return t.dueDate!.isAfter(today.add(const Duration(days: 1)));
    }).toList();

    return TaskState(
      // Show loading only if NO cached data is available
      isLoading: tasksAsync.isLoading && !tasksAsync.hasValue,
      todaysTasks: todayTasks,
      upcomingTasks: upcoming,
      searchQuery: searchQuery,
      errorMessage: tasksAsync.error?.toString(),
    );
  }

  void updateSearchQuery(String query) {
    ref.read(taskSearchQueryProvider.notifier).query = query;
  }
}

final taskViewModelProvider = NotifierProvider<TaskViewModel, TaskState>(
  TaskViewModel.new,
);
