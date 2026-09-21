import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careercircuit/models/career_stage.dart';
import 'package:careercircuit/presentation/results_wording.dart';
import 'package:careercircuit/repositories/career_data_repository.dart';
import 'package:careercircuit/screens/results_screen.dart';
import 'package:careercircuit/theme/app_theme.dart';
import 'package:careercircuit/widgets/pathway_card.dart';
import 'results_fixtures.dart';
import 'career_repository_test.dart' show CountingBundle;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repository = CareerDataRepository.instance;
  setUpAll(() => repository.ensureLoaded());

  void checkWordingAndLayout(WidgetTester tester) {
    final rendered = tester
        .widgetList<RichText>(find.byType(RichText))
        .map((widget) => widget.text.toPlainText().toLowerCase())
        .join(' ');
    for (final phrase in ResultsWording.banned) {
      expect(
        rendered,
        isNot(contains(phrase.toLowerCase())),
        reason: 'Banned results wording: $phrase',
      );
    }
    expect(tester.takeException(), isNull);
  }

  for (final code in ['RIA', 'SEC', 'CEI', 'AER']) {
    testWidgets('$code respects source order and wording at 320dp / 2x text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final result = resultForCode(code);
      await tester.pumpWidget(
        MaterialApp(
          theme: careerTheme(
            code == 'RIA' || code == 'CEI' ? Brightness.light : Brightness.dark,
          ),
          home: ResultsScreen(
            result: result,
            stage: CareerStage.highSchool,
            completionTime: const Duration(minutes: 5),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(
        tester.widgetList<PathwayCard>(find.byType(PathwayCard)).length,
        lessThan(3),
      );
      checkWordingAndLayout(tester);
      final scrollable = find.byType(Scrollable).first;
      final seen = <String>[];
      final careers = repository.careersFor(code);
      for (final career in careers) {
        final title = find.byKey(ValueKey('career-title-${career.id}'));
        await tester.scrollUntilVisible(
          title,
          500,
          scrollable: scrollable,
          maxScrolls: 200,
        );
        await tester.pumpAndSettle();
        seen.add(tester.widget<DatasetText>(title).text);
        expect(
          find.text(displayDatasetText(career.aiImpactSummary)),
          findsOneWidget,
        );
        expect(
          find.text(displayDatasetText(career.aiAssistLabel)),
          findsWidgets,
        );
        for (final item in [
          ...career.topicsToExplore,
          ...career.skillsToLearn,
        ]) {
          expect(find.text(displayDatasetText(item.howToStart)), findsWidgets);
        }
        final tasks = find.byKey(PageStorageKey('tasks-${career.id}'));
        expect(tester.widget<ExpansionTile>(tasks).initiallyExpanded, isFalse);
        checkWordingAndLayout(tester);
        await tester.ensureVisible(tasks);
        await tester.pumpAndSettle();
        await tester.tap(tasks);
        await tester.pumpAndSettle();
        for (final task in career.sampleTasks) {
          expect(find.text(displayDatasetText(task)), findsOneWidget);
        }
        checkWordingAndLayout(tester);
      }
      expect(seen, careers.map((c) => c.title).toList());
      await tester.scrollUntilVisible(
        find.text('Where this comes from'),
        500,
        scrollable: scrollable,
        maxScrolls: 200,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Where this comes from'));
      await tester.pumpAndSettle();
      expect(
        find.text(displayDatasetText(repository.dataset!.meta.aiImpactMethod)),
        findsOneWidget,
      );
      checkWordingAndLayout(tester);
    });
  }

  testWidgets(
    'nearby code switches pathways without changing calculated scores',
    (tester) async {
      final result = resultForScores({
        'R': 25,
        'I': 23,
        'A': 18,
        'S': 17,
        'E': 10,
        'C': 5,
      });
      await tester.pumpWidget(
        MaterialApp(
          home: ResultsScreen(result: result, stage: CareerStage.highSchool),
        ),
      );
      await tester.pumpAndSettle();
      final primarySummary = displayDatasetText(
        repository.codeFor('RIA')!.summary,
      );
      expect(find.text(primarySummary), findsOneWidget);
      final alternate = find.byKey(const ValueKey('code-RIS'));
      await tester.ensureVisible(alternate);
      await tester.pumpAndSettle();
      await tester.tap(alternate);
      await tester.pumpAndSettle();
      expect(
        find.text(displayDatasetText(repository.codeFor('RIS')!.summary)),
        findsOneWidget,
      );
      expect(find.text(primarySummary), findsNothing);
      expect(result.scores['R'], 25);
      expect(
        find.text('Viewing nearby code RIS. Your calculated code remains RIA.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('code-RIA')));
      await tester.pumpAndSettle();
      expect(find.text(primarySummary), findsOneWidget);
      checkWordingAndLayout(tester);
    },
  );

  testWidgets('asset failure keeps profile visible and offers recovery', (
    tester,
  ) async {
    final bundle = CountingBundle('')..fail = true;
    final failed = CareerDataRepository.forTesting(bundle: bundle);
    await tester.pumpWidget(
      MaterialApp(
        home: ResultsScreen(
          result: resultForCode('RIA'),
          stage: CareerStage.highSchool,
          repository: failed,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Realistic: 100% interest level'), findsOneWidget);
    expect(find.text('Try loading again'), findsOneWidget);
    expect(find.byType(PathwayCard), findsNothing);
    checkWordingAndLayout(tester);
  });
}
