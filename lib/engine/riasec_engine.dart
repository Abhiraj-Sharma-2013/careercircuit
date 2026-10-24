import '../models/assessment_result.dart';
import '../models/quiz_question.dart';

class RiasecEngine {
  /// Preferences and AI output are deliberately not inputs to scoring.
  static AssessmentResult score(
    List<QuizQuestion> questions,
    Map<String, QuizResponse> responses,
  ) {
    final counts = {for (final code in codes) code: 0};
    final ids = <String>{};
    for (final question in questions) {
      if (!counts.containsKey(question.riasecType) || !ids.add(question.id)) {
        throw ArgumentError('Invalid category or duplicate item ID.');
      }
      counts[question.riasecType] = counts[question.riasecType]! + 1;
    }
    if (questions.length != 30 || counts.values.any((count) => count != 5)) {
      throw ArgumentError('Expected 30 items, five per RIASEC category.');
    }
    if (responses.length != ids.length || !ids.every(responses.containsKey)) {
      throw StateError('Answer every core item before calculating scores.');
    }
    final scores = {for (final code in codes) code: 0};
    final gaps = {for (final code in codes) code: 0};
    for (final question in questions) {
      final response = responses[question.id]!;
      scores[question.riasecType] =
          scores[question.riasecType]! + response.rating;
      if (response.exposureGap) {
        gaps[question.riasecType] = gaps[question.riasecType]! + 1;
      }
    }
    return AssessmentResult(
      scores: scores,
      exposureGaps: gaps,
      responses: responses,
    );
  }

  static const codes = ['R', 'I', 'A', 'S', 'E', 'C'];

  static const labels = {
    'R': 'Realistic',
    'I': 'Investigative',
    'A': 'Artistic',
    'S': 'Social',
    'E': 'Enterprising',
    'C': 'Conventional',
  };

  // Sorts RIASEC types by score and uses the fixed RIASEC order for ties.
  static List<String> topCodes(Map<String, int> scores, {int count = 3}) {
    final sortedCodes = [...codes];

    sortedCodes.sort((codeA, codeB) {
      // Higher scores rank first; missing codes behave as zero.
      final scoreComparison = (scores[codeB] ?? 0).compareTo(
        scores[codeA] ?? 0,
      );

      if (scoreComparison != 0) return scoreComparison;

      // Fixed code order makes equal scores produce the same result every time.
      return codes.indexOf(codeA).compareTo(codes.indexOf(codeB));
    });

    // Return only the requested number of strongest interest types.
    return sortedCodes.take(count).toList();
  }

  // Joins the three strongest RIASEC types into the student's Holland code.
  static String hollandCode(Map<String, int> scores) {
    return topCodes(scores).join();
  }
}
