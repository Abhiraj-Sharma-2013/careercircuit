import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:careercircuit/main.dart';
import 'package:careercircuit/models/student_intake.dart';
import 'package:careercircuit/screens/results_screen.dart';

void main() {
  testWidgets('quiz starts with grade and profile fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CareerCircuitApp());
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Tell us about yourself'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<int>), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    expect(find.text('6th grade'), findsOneWidget);
    expect(find.text('12th grade'), findsOneWidget);
  });

  testWidgets('profile text fields enforce the 50-character limit', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CareerCircuitApp());
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'a' * 60);
    await tester.pump();

    final field = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(field.controller!.text.length, 50);
  });

  testWidgets('results show the exploration disclaimer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ResultsScreen(
          studentScores: const {'Thinker': 2},
          studentIntake: const StudentIntake(
            grade: 10,
            likes: '',
            dislikes: '',
          ),
        ),
      ),
    );

    expect(find.textContaining('For exploration only:'), findsOneWidget);
    expect(
      find.textContaining(
        'AI career suggestions may be incomplete or inaccurate.',
      ),
      findsOneWidget,
    );
  });
}
