import 'package:flutter/material.dart';
import 'package:careercircuit/repositories/career_data_repository.dart';
import 'slider_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careercircuit/main.dart';
import 'package:careercircuit/data/quiz_data.dart';
import 'package:careercircuit/data/stage_question_text.dart';
import 'package:careercircuit/models/career_stage.dart';
import 'package:careercircuit/screens/quiz_screen.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    binding.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
  });
  tearDown(binding.platformDispatcher.clearAccessibilityFeaturesTestValue);
  setUpAll(() => CareerDataRepository.instance.ensureLoaded());
  test('every stable item has wording for every stage', () {
    expect(
      stageQuestionText.keys.toSet(),
      quizQuestions.map((q) => q.id).toSet(),
    );
    for (final q in quizQuestions) {
      expect(stageQuestionText[q.id]!.length, CareerStage.values.length);
      for (final stage in CareerStage.values) {
        expect(questionTextForStage(q, stage).trim(), isNotEmpty);
      }
    }
  });

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'theme persists across routes and stage choice changes only wording',
    (tester) async {
      await tester.pumpWidget(const CareerCircuitApp());
      final toggle = find.byKey(const ValueKey('theme-toggle'));
      final initial = tester.widget<Switch>(toggle).value;
      await tap(tester, toggle);
      expect(tester.widget<Switch>(toggle).value, !initial);
      await tap(tester, find.text('Get Started'));
      expect(tester.widget<Switch>(toggle).value, !initial);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Start quiz'),
            )
            .onPressed,
        isNull,
      );
      await tap(tester, find.byKey(const ValueKey('stage-professional')));
      await tap(tester, find.text('Start quiz'));
      expect(
        find.text(
          questionTextForStage(quizQuestions.first, CareerStage.professional),
        ),
        findsOneWidget,
      );
      await chooseSliderPosition(
        tester,
        find.byKey(const ValueKey('slider-R1')),
        0,
      );
      await tap(tester, toggle);
      expect(tester.widget<Switch>(toggle).value, initial);
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('status-R1'))).data,
        'Never tried',
      );
      await tap(tester, find.byType(BackButton));
      await tap(tester, find.byKey(const ValueKey('stage-middleSchool')));
      await tap(tester, find.text('Start quiz'));
      expect(
        find.text(
          questionTextForStage(quizQuestions.first, CareerStage.middleSchool),
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('status-R1'))).data,
        'Choose your answer',
      );
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('each stage can enter all six sections in dark mode', (
    tester,
  ) async {
    await tester.pumpWidget(const CareerCircuitApp());
    final toggle = find.byKey(const ValueKey('theme-toggle'));
    if (!tester.widget<Switch>(toggle).value) await tap(tester, toggle);
    for (final stage in CareerStage.values) {
      final context = tester.element(find.byType(Scaffold).first);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => QuizScreen(initialStage: stage)),
      );
      await tester.pumpAndSettle();
      await tap(tester, find.text('Start quiz'));
      for (var page = 0; page < 6; page++) {
        for (final q in quizQuestions.skip(page * 5).take(5)) {
          expect(find.text(questionTextForStage(q, stage)), findsOneWidget);
          await chooseSliderPosition(
            tester,
            find.byKey(ValueKey('slider-${q.id}')),
            0,
          );
        }
        await tap(tester, find.byKey(const ValueKey('next')));
      }
      expect(tester.widget<Switch>(toggle).value, isTrue);
      expect(find.text('Your possibilities'), findsOneWidget);
      await tap(tester, find.byType(BackButton));
    }
    expect(tester.takeException(), isNull);
  });
}
