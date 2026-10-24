import 'package:flutter_test/flutter_test.dart';
import 'package:careercircuit/data/quiz_data.dart';
import 'package:careercircuit/engine/riasec_engine.dart';
import 'package:careercircuit/models/quiz_question.dart';
import 'package:careercircuit/view_models/results_view_model.dart';
import 'results_fixtures.dart';

void main() {
  test('peaked profile preserves totals, percentages and rank', () {
    final vm = ResultsViewModel.fromAssessment(
      resultForCode('RIA'),
      completionTime: const Duration(minutes: 5),
    );
    expect(vm.rawScores['R'], 25);
    expect(vm.percentScores, {
      'R': 100,
      'I': 80,
      'A': 60,
      'S': 40,
      'E': 32,
      'C': 24,
    });
    expect(vm.rankedLetters, ['R', 'I', 'A', 'S', 'E', 'C']);
    expect(vm.hollandCode, 'RIA');
    expect(vm.confidenceLabel, ConfidenceLabel.clear);
    expect(vm.profileShape, ProfileShape.differentiated);
    expect(vm.alternateCodes, isEmpty);
    expect(vm.tieNotes, isEmpty);
  });

  test('exact ties are stable and offer both adjacent alternatives', () {
    final vm = ResultsViewModel.fromAssessment(
      resultForScores({'R': 25, 'I': 25, 'A': 18, 'S': 18, 'E': 10, 'C': 5}),
    );
    expect(vm.hollandCode, 'RIA');
    expect(vm.alternateCodes, ['RIS', 'IRA']);
    expect(vm.thirdLetterIsUncertain, isTrue);
    expect(
      vm.tieNotes,
      contains('You have two nearly equally strong interest areas.'),
    );
    expect(vm.confidenceLabel, ConfidenceLabel.clear);
    expect(vm.showUncertainty, isTrue);
  });

  test('near-tie thresholds are inclusive and alternatives are unique', () {
    final vm = ResultsViewModel.fromAssessment(
      resultForScores({'R': 25, 'I': 23, 'A': 18, 'S': 17, 'E': 10, 'C': 5}),
    );
    expect(vm.topTwoAreClose, isTrue);
    expect(vm.thirdLetterIsUncertain, isTrue);
    expect(vm.alternateCodes, ['RIS', 'IRA']);
    expect(vm.alternateCodes.toSet().length, vm.alternateCodes.length);
    final separated = ResultsViewModel.fromAssessment(
      resultForScores({'R': 25, 'I': 22, 'A': 18, 'S': 16, 'E': 10, 'C': 5}),
    );
    expect(separated.alternateCodes, isEmpty);
  });

  test('all-same ratings require more exploration', () {
    final result = RiasecEngine.score(quizQuestions, {
      for (final q in quizQuestions) q.id: QuizResponse.rated(3),
    });
    final vm = ResultsViewModel.fromAssessment(result);
    expect(vm.confidenceLabel, ConfidenceLabel.needsMoreExploration);
    expect(vm.repeatedRatings, isTrue);
    expect(vm.profileShape, ProfileShape.broad);
    expect(vm.hollandCode, 'RIA');
    expect(vm.alternateCodes, ['RIS', 'IRA']);
  });

  test(
    'all never-tried ratings are midpoint, not low, with all exposure areas',
    () {
      final result = RiasecEngine.score(quizQuestions, {
        for (final q in quizQuestions) q.id: const QuizResponse.notTried(),
      });
      final vm = ResultsViewModel.fromAssessment(result);
      expect(vm.percentScores.values, everyElement(60));
      expect(vm.exposureGapLetters, RiasecEngine.codes);
      expect(vm.confidenceLabel, ConfidenceLabel.needsMoreExploration);
      expect(vm.manyUntried, isTrue);
    },
  );

  test('broad flat totals with varied ratings are balanced', () {
    final result = RiasecEngine.score(quizQuestions, {
      for (final q in quizQuestions)
        q.id: QuizResponse.rated(int.parse(q.id[1])),
    });
    final vm = ResultsViewModel.fromAssessment(result);
    expect(vm.profileShape, ProfileShape.broad);
    expect(vm.confidenceLabel, ConfidenceLabel.balanced);
    expect(vm.repeatedRatings, isFalse);
  });

  test(
    'exposure is over 40 percent, repeated rating is 80 percent or more',
    () {
      final responses = {
        for (final q in quizQuestions)
          q.id: QuizResponse.rated(int.parse(q.id[1])),
      };
      for (final q in quizQuestions.take(12)) {
        responses[q.id] = const QuizResponse.notTried();
      }
      expect(
        ResultsViewModel.fromAssessment(
          RiasecEngine.score(quizQuestions, responses),
        ).manyUntried,
        isFalse,
      );
      responses[quizQuestions[12].id] = const QuizResponse.notTried();
      expect(
        ResultsViewModel.fromAssessment(
          RiasecEngine.score(quizQuestions, responses),
        ).manyUntried,
        isTrue,
      );
      for (var index = 0; index < 30; index++) {
        responses[quizQuestions[index].id] = QuizResponse.rated(
          index < 24 ? 4 : 1,
        );
      }
      expect(
        ResultsViewModel.fromAssessment(
          RiasecEngine.score(quizQuestions, responses),
        ).repeatedRatings,
        isTrue,
      );
      responses[quizQuestions[23].id] = QuizResponse.rated(2);
      expect(
        ResultsViewModel.fromAssessment(
          RiasecEngine.score(quizQuestions, responses),
        ).repeatedRatings,
        isFalse,
      );
    },
  );

  test(
    'quick completion overrides clear; unknown timing is not treated as fast',
    () {
      final result = resultForCode('RIA');
      expect(
        ResultsViewModel.fromAssessment(
          result,
          completionTime: const Duration(seconds: 89),
        ).confidenceLabel,
        ConfidenceLabel.needsMoreExploration,
      );
      expect(
        ResultsViewModel.fromAssessment(
          result,
          completionTime: const Duration(seconds: 90),
        ).confidenceLabel,
        ConfidenceLabel.clear,
      );
      expect(ResultsViewModel.fromAssessment(result).completedQuickly, isFalse);
      expect(
        () => ResultsViewModel.fromAssessment(
          result,
          completionTime: const Duration(seconds: -1),
        ),
        throwsArgumentError,
      );
    },
  );
}
