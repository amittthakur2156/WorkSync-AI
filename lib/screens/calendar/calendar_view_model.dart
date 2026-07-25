import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/task_providers.dart';
import 'calendar_state.dart';

class CalendarSelectedDate extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
  set date(DateTime val) => state = DateTime(val.year, val.month, val.day);
}

final calendarSelectedDateProvider = NotifierProvider<CalendarSelectedDate, DateTime>(
  CalendarSelectedDate.new,
);

class CalendarViewModel extends Notifier<CalendarState> {
  @override
  CalendarState build() {
    final selectedDate = ref.watch(calendarSelectedDateProvider);
    final tasksAsync = ref.watch(myTasksProvider);

    final tasks = tasksAsync.value ?? [];
    final weekDays = _generateWeekDays(selectedDate);

    final dayTasks = tasks.where((t) {
      if (t.dueDate == null) return false;
      final d = t.dueDate!;
      return d.year == selectedDate.year &&
          d.month == selectedDate.month &&
          d.day == selectedDate.day;
    }).toList();

    return CalendarState(
      // Prevent screen flicker by prioritizing cached schedule
      isLoading: tasksAsync.isLoading && !tasksAsync.hasValue,
      selectedDate: selectedDate,
      weekDays: weekDays,
      dayTasks: dayTasks,
      errorMessage: tasksAsync.error?.toString(),
    );
  }

  List<DateTime> _generateWeekDays(DateTime centerDate) {
    return List.generate(7, (index) {
      return centerDate.add(Duration(days: index - 3));
    });
  }

  void selectDate(DateTime date) {
    ref.read(calendarSelectedDateProvider.notifier).date = date;
  }
}

final calendarViewModelProvider = NotifierProvider<CalendarViewModel, CalendarState>(
  CalendarViewModel.new,
);
