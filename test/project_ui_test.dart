import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/project_providers.dart';
import 'package:worksync_ai/domain/entities/project_entity.dart';
import 'package:worksync_ai/screens/projects/project_screen.dart';
import 'package:worksync_ai/core/constants/enums.dart';

void main() {
  final testProject = ProjectEntity(
    id: 'p1',
    ownerId: 'u1',
    title: 'Test Project',
    description: 'A test project description',
    status: ProjectStatus.active,
    color: Colors.blue,
    icon: Icons.rocket_launch,
    progress: 0.0,
    memberIds: ['u1'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  testWidgets('ProjectScreen renders list of projects', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myProjectsProvider.overrideWith((ref) => Stream.value([testProject])),
        ],
        child: const MaterialApp(
          home: ProjectScreen(),
        ),
      ),
    );

    // Initial loading or cache display
    await tester.pump();

    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Active Projects'), findsOneWidget);
    expect(find.text('Test Project'), findsOneWidget);
  });
}
