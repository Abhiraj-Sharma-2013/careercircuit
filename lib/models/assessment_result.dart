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

  bool get mostlyUntried => exposureGapCount > responses.length / 2;
  bool get isFlat => scores.values.toSet().length == 1;
  bool get allLow => scores.values.every((score) => score <= 10);

  // A conservative UX rule, not a validated psychometric cutoff.
  bool get showBroadExploration => mostlyUntried || isFlat || allLow;

  List<String> get highestCodes {
    final highest = scores.values.reduce((a, b) => a > b ? a : b);
    return scores.keys.where((code) => scores[code] == highest).toList();
  }
}
