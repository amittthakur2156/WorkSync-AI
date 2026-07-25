import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/auth_providers.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'package:worksync_ai/core/providers/task_providers.dart';
import 'package:worksync_ai/core/providers/notification_providers.dart';
import 'package:worksync_ai/domain/entities/app_user_entity.dart';
import 'package:worksync_ai/screens/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard renders statistics and AI insights', (WidgetTester tester) async {
    final mockUser = AppUserEntity(
      uid: 'u1',
      name: 'Test User',
      email: 'test@example.com',
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(mockUser)),
          myProjectsProvider.overrideWith((ref) => Stream.value([])),
          myTasksProvider.overrideWith((ref) => Stream.value([])),
          myNotificationsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          home: DashboardScreen(onTabChange: (_) {}),
        ),
      ),
    );

    // Give it time to resolve all streams and build the UI
    await tester.pumpAndSettle();

    expect(find.text('WorkSync AI'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Projects'), findsWidgets); // Stat card title
    expect(find.text('AI Workspace Insights'), findsOneWidget);
  });
}
