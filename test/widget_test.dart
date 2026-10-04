import 'package:flutter/material.dart';
import 'package:careercircuit/repositories/career_data_repository.dart';
import 'slider_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careercircuit/main.dart';
import 'package:careercircuit/data/quiz_data.dart';
import 'package:careercircuit/screens/results_screen.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    binding.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
  });
  tearDown(binding.platformDispatcher.clearAccessibilityFeaturesTestValue);
  setUpAll(() => CareerDataRepository.instance.ensureLoaded());
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> start(WidgetTester tester) async {
    await tester.pumpWidget(const CareerCircuitApp());
    await tapVisible(tester, find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.textContaining('draft'), findsNothing);
    expect(find.byType(TextFormField), findsNothing);
    await tapVisible(tester, find.byKey(const ValueKey('stage-highSchool')));
    await tapVisible(tester, find.text('Start quiz'));
  }

  testWidgets('unanswered thumbs pulse and a default-position tap confirms', (
    tester,
  ) async {
    await start(tester);
    final slider = find.byKey(const ValueKey('slider-R1'));
    Color thumbColor() => SliderTheme.of(tester.element(slider)).thumbColor!;
    final colors = Theme.of(tester.element(slider)).colorScheme;
    expect(thumbColor(), colors.outline);
    await tester.pump(const Duration(milliseconds: 400));
    expect(thumbColor(), colors.outline, reason: 'Respect reduced motion');

    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures();
    await tester.pump();
    final initialColor = thumbColor();
    await tester.pump(const Duration(milliseconds: 400));
    expect(thumbColor(), isNot(initialColor));
    expect(tester.widget<Slider>(slider).value, 0);
    expect(find.text('Choose your answer'), findsNWidgets(5));

    await tester.ensureVisible(slider);
    final rect = tester.getRect(slider);
    await tester.tapAt(Offset(rect.left + 24, rect.center.dy));
    await tester.pump();
    expect(tester.widget<Slider>(slider).value, 0);
    expect(thumbColor(), colors.primary);
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('status-R1'))).data,
      'Never tried',
    );
    expect(find.text('Choose your answer'), findsNWidgets(4));
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1 / 30,
    );
    await tester.pump(const Duration(milliseconds: 800));
    expect(thumbColor(), colors.primary, reason: 'Confirmed thumbs stay solid');
    expect(tester.takeException(), isNull);
  });

  testWidgets('five sliders require explicit answers and preserve edits', (
    tester,
  ) async {
    await start(tester);
    expect(find.text('Making'), findsOneWidget);
    expect(find.byType(Slider), findsNWidgets(5));
    expect(find.text('Choose your answer'), findsNWidgets(5));
    expect(
      tester.widget<FilledButton>(find.byKey(const ValueKey('next'))).onPressed,
      isNull,
    );
    for (var n = 1; n <= 5; n++) {
      await chooseSliderPosition(tester, find.byKey(ValueKey('slider-R$n')), 0);
    }
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      5 / 30,
    );
    await tapVisible(tester, find.byKey(const ValueKey('next')));
    expect(find.text('Exploring'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(CheckboxListTile), findsNothing);
    expect(find.byType(Checkbox), findsNothing);
    final slider = find.byKey(const ValueKey('slider-R1'));
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('status-R1'))).data,
      'Never tried',
    );
    await chooseSliderPosition(tester, slider, 1);
    expect(find.text('Not at all'), findsOneWidget);
    await chooseSliderPosition(tester, slider, 2);
    expect(find.text('Probably not'), findsOneWidget);
    await chooseSliderPosition(tester, slider, 3);
    expect(find.text('Not sure yet'), findsOneWidget);
    await chooseSliderPosition(tester, slider, 4);
    expect(find.text('Probably yes'), findsOneWidget);
    await tester.drag(slider, const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(slider).value, 5);
    await tapVisible(tester, find.byKey(const ValueKey('next')));
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(slider).value, 5);
    expect(find.text('5 = Very much'), findsNothing);
    await chooseSliderPosition(tester, slider, 0);
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('status-R1'))).data,
      'Never tried',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('six pages complete on narrow screen with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await start(tester);
    for (var page = 0; page < quizSections.length; page++) {
      expect(find.text('Section ${page + 1} of 6'), findsOneWidget);
      expect(find.text(quizSections.values.elementAt(page)), findsOneWidget);
      expect(find.byType(Slider), findsNWidgets(5));
      for (final q in quizQuestions.skip(page * 5).take(5)) {
        await chooseSliderPosition(
          tester,
          find.byKey(ValueKey('slider-${q.id}')),
          0,
        );
      }
      await tapVisible(tester, find.byKey(const ValueKey('next')));
      expect(tester.takeException(), isNull);
    }
    final screen = tester.widget<ResultsScreen>(find.byType(ResultsScreen));
    expect(screen.result.scores.values, everyElement(15));
    expect(screen.result.exposureGapCount, 30);
    expect(screen.completionTime, isNotNull);
    await tester.scrollUntilVisible(
      find.textContaining('Your interests are still forming'),
      200,
    );
    expect(
      find.textContaining('Your interests are still forming'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
