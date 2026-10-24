import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:careercircuit/data/quiz_data.dart';
import 'package:careercircuit/engine/riasec_engine.dart';
import 'package:careercircuit/models/quiz_question.dart';

void main() {
  Map<String, QuizResponse> uniform(int rating) => {
    for (final q in quizQuestions) q.id: QuizResponse.rated(rating),
  };

  test('six slider positions keep exposure distinct from interest', () {
    final untried = QuizResponse.fromSliderPosition(0);
    expect(untried.rating, 3);
    expect(untried.exposureGap, isTrue);
    expect(untried.sliderPosition, 0);
    for (var position = 1; position <= 5; position++) {
      final response = QuizResponse.fromSliderPosition(position);
      expect(response.rating, position);
      expect(response.exposureGap, isFalse);
      expect(response.sliderPosition, position);
    }
    expect(() => QuizResponse.fromSliderPosition(-1), throwsRangeError);
    expect(() => QuizResponse.fromSliderPosition(6), throwsRangeError);
  });

  test('bank is balanced, grouped, unique, and matches JSON export', () {
    expect(quizQuestions.length, 30);
    expect(quizQuestions.map((q) => q.id).toSet().length, 30);
    for (final code in RiasecEngine.codes) {
      expect(quizQuestions.where((q) => q.riasecType == code).length, 5);
      expect(
        quizQuestions
            .where((q) => q.riasecType == code)
            .map((q) => q.id)
            .toSet(),
        {for (var n = 1; n <= 5; n++) '$code$n'},
      );
    }
    expect(quizSections.length, 6);
    for (var page = 0; page < 6; page++) {
      expect(
        quizQuestions.skip(page * 5).take(5).map((q) => q.riasecType),
        everyElement(quizSections.keys.elementAt(page)),
      );
    }
    expect(
      jsonDecode(File('assets/riasec_questions.json').readAsStringSync()),
      quizQuestions.map((q) => q.toJson()).toList(),
    );
  });

  test('category totals span 5 to 25 without cross-category contributions', () {
    expect(
      RiasecEngine.score(quizQuestions, uniform(1)).scores.values,
      everyElement(5),
    );
    expect(
      RiasecEngine.score(quizQuestions, uniform(5)).scores.values,
      everyElement(25),
    );
    final responses = uniform(1);
    for (final q in quizQuestions.where((q) => q.riasecType == 'I')) {
      responses[q.id] = QuizResponse.rated(5);
    }
    final result = RiasecEngine.score(quizQuestions, responses);
    expect(result.scores, {'R': 5, 'I': 25, 'A': 5, 'S': 5, 'E': 5, 'C': 5});
  });

  test('untried uses midpoint, tracks category, and clears when replaced', () {
    final responses = uniform(1)..['I1'] = const QuizResponse.notTried();
    var result = RiasecEngine.score(quizQuestions, responses);
    expect(result.scores['I'], 7);
    expect(result.exposureGaps['I'], 1);
    expect(result.exposureGapCount, 1);
    responses['I1'] = QuizResponse.rated(3);
    result = RiasecEngine.score(quizQuestions, responses);
    expect(result.scores['I'], 7);
    expect(result.exposureGapCount, 0);
  });

  test('missing, extra, invalid ratings and malformed banks are rejected', () {
    expect(() => QuizResponse.rated(0), throwsRangeError);
    expect(() => QuizResponse.rated(6), throwsRangeError);
    expect(
      () => RiasecEngine.score(quizQuestions, uniform(3)..remove('I1')),
      throwsStateError,
    );
    expect(
      () => RiasecEngine.score(
        quizQuestions,
        uniform(3)..['extra'] = QuizResponse.rated(3),
      ),
      throwsStateError,
    );
    expect(
      () => RiasecEngine.score(quizQuestions.sublist(1), uniform(3)),
      throwsArgumentError,
    );
    expect(
      () => RiasecEngine.score([
        quizQuestions[1],
        ...quizQuestions.sublist(1),
      ], uniform(3)),
      throwsArgumentError,
    );
  });

  test('result snapshot is immutable and independent of later edits', () {
    final responses = uniform(3);
    final result = RiasecEngine.score(quizQuestions, responses);
    responses['I1'] = const QuizResponse.notTried();
    expect(result.responses['I1']!.exposureGap, isFalse);
    expect(result.scores.values, everyElement(15));
    expect(() => result.scores['R'] = 25, throwsUnsupportedError);
    expect(() => result.exposureGaps.clear(), throwsUnsupportedError);
    expect(() => result.responses.clear(), throwsUnsupportedError);
  });
}
