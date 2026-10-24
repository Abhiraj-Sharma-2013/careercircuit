import 'quiz_question.dart';

class AssessmentResult {
  final Map<String, int> scores;
  final Map<String, int> exposureGaps;
  final Map<String, QuizResponse> responses;

  AssessmentResult({
    required Map<String, int> scores,
    required Map<String, int> exposureGaps,
    required Map<String, QuizResponse> responses,
  }) : scores = Map.unmodifiable(scores),
       exposureGaps = Map.unmodifiable(exposureGaps),
       responses = Map.unmodifiable(responses);

  int get exposureGapCount =>
      exposureGaps.values.fold(0, (total, count) => total + count);
}
