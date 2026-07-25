import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'calendar_view_model.dart';
import 'widgets/calendar_day_card.dart';
import 'widgets/calendar_header.dart';
import 'widgets/task_event_card.dart';
import 'widgets/empty_schedule_widget.dart';
import 'package:worksync_ai/widgets/shimmers/task_list_shimmer.dart';
import 'package:worksync_ai/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  Future<void> _selectDate(BuildContext context, WidgetRef ref, DateTime currentDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      ref.read(calendarViewModelProvider.notifier).selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Calendar",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _selectDate(context, ref, state.selectedDate),
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1055DC),
        onPressed: () => context.push('${AppRoutes.tasks}/${AppRoutes.taskCreate}'),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: state.isLoading && state.dayTasks.isEmpty
          ? const TaskListShimmer()
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(calendarViewModelProvider);
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Month Header
                    CalendarHeader(
                      month: DateFormat('MMMM yyyy').format(state.selectedDate),
                      onPrevious: () => ref.read(calendarViewModelProvider.notifier).selectDate(
                            state.selectedDate.subtract(const Duration(days: 30)),
                          ),
                      onNext: () => ref.read(calendarViewModelProvider.notifier).selectDate(
                            state.selectedDate.add(const Duration(days: 30)),
                          ),
                    ),

                    const SizedBox(height: 20),

                    /// Days
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.weekDays.length,
                        itemBuilder: (context, index) {
                          final date = state.weekDays[index];
                          final isSelected = date.day == state.selectedDate.day &&
                              date.month == state.selectedDate.month &&
                              date.year == state.selectedDate.year;

                          return CalendarDayCard(
                            day: DateFormat('E').format(date),
                            date: date.day.toString(),
                            isSelected: isSelected,
                            onTap: () => ref.read(calendarViewModelProvider.notifier).selectDate(date),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      state.selectedDate.day == DateTime.now().day &&
                              state.selectedDate.month == DateTime.now().month &&
                              state.selectedDate.year == DateTime.now().year
                          ? "Today's Schedule"
                          : "${DateFormat('MMM d').format(state.selectedDate)}'s Schedule",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    if (state.dayTasks.isEmpty)
                      EmptyScheduleWidget(
                        onAddEvent: () => context.push('${AppRoutes.tasks}/${AppRoutes.taskCreate}'),
                      )
                    else
                      ...state.dayTasks.map((task) => TaskEventCard(
                            time: task.dueDate != null 
                                ? DateFormat('hh:mm a').format(task.dueDate!)
                                : "No Time",
                            title: task.title,
                            project: "Project ID: ${task.projectId.length > 5 ? task.projectId.substring(0, 5) : task.projectId}...",
                            color: _getPriorityColor(task.priority.value),
                            icon: Icons.task_alt,
                          )),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
