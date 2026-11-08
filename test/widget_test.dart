// Experiment 10(a): Unit and Widget Tests for UI Components
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:student_study_hub/main.dart';

void main() {
  group('Experiment 10: Unit & Widget Tests', () {
    test('Unit Test: TaskProvider adds, toggles, and deletes tasks', () {
      final provider = TaskProvider();
      final initialCount = provider.tasks.length;

      provider.addTask(
        title: 'Prepare Viva Notes',
        subject: 'Flutter Lab',
        priority: 'High',
        email: 'test@college.edu',
      );
      expect(provider.tasks.length, initialCount + 1);
      expect(provider.tasks.first.title, 'Prepare Viva Notes');

      final addedTaskId = provider.tasks.first.id;
      expect(provider.tasks.first.isCompleted, false);

      provider.toggleTaskStatus(addedTaskId);
      expect(provider.tasks.first.isCompleted, true);

      provider.deleteTask(addedTaskId);
      expect(provider.tasks.length, initialCount);
    });

    testWidgets('Widget Test: HomeScreen renders header and tasks',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
          child: const StudyHubApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Student Study & Task Hub'), findsOneWidget);
      expect(find.text('Academic Study Planner'), findsOneWidget);
      expect(find.text('Add New Task (Form)'), findsOneWidget);
    });

    testWidgets('Widget Test: Form validation shows error messages on empty submit',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
          child: const MaterialApp(
            home: AddTaskScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Validate & Save Task'));
      await tester.pump();

      expect(find.text('Task title is required'), findsOneWidget);
      expect(find.text('Subject name is required'), findsOneWidget);
      expect(find.text('Email address is required'), findsOneWidget);
    });
  });
}
