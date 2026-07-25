import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/task_providers.dart';
import 'package:worksync_ai/domain/entities/task_entity.dart';
import 'package:worksync_ai/screens/tasks/task_screen.dart';
import 'package:worksync_ai/core/constants/enums.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testTask = TaskEntity(
    id: 't1',
    projectId: 'p1',
    ownerId: 'u1',
    title: 'Test Task',
    description: 'A test task description',
    status: TaskStatus.todo,
    priority: TaskPriority.high,
    assigneeIds: ['u1'],
    dueDate: DateTime.now(), 
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  testWidgets('TaskScreen renders empty state', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myTasksProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(
          home: TaskScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('No Tasks Found'), findsOneWidget);
  });

  testWidgets('TaskScreen renders list with data', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myTasksProvider.overrideWith((ref) => Stream.value([testTask])),
        ],
        child: const MaterialApp(
          home: TaskScreen(),
        ),
      ),
    );

    // Initial pump to start the stream
    await tester.pump();
    // Second pump to let the stream emit its first value
    await tester.pump();
    // Final settle for animations
    await tester.pumpAndSettle();

    expect(find.text('Test Task'), findsOneWidget);
  });
}
