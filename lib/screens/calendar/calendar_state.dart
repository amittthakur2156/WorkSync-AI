import '../../domain/entities/task_entity.dart';

class CalendarState {
  final bool isLoading;
  final DateTime selectedDate;
  final List<DateTime> weekDays;
  final List<TaskEntity> dayTasks;
  final String? errorMessage;

  const CalendarState({
    this.isLoading = true,
    required this.selectedDate,
    this.weekDays = const [],
    this.dayTasks = const [],
    this.errorMessage,
  });

  CalendarState copyWith({
    bool? isLoading,
    DateTime? selectedDate,
    List<DateTime>? weekDays,
    List<TaskEntity>? dayTasks,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      selectedDate: selectedDate ?? this.selectedDate,
      weekDays: weekDays ?? this.weekDays,
      dayTasks: dayTasks ?? this.dayTasks,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
