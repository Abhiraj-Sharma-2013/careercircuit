import 'package:careercircuit/data/quiz_data.dart';
import 'package:careercircuit/engine/riasec_engine.dart';
import 'package:careercircuit/models/assessment_result.dart';
import 'package:careercircuit/models/quiz_question.dart';

AssessmentResult resultForScores(Map<String, int> scores) {
  final responses = <String, QuizResponse>{};
  for (final code in RiasecEngine.codes) {
    final total = scores[code]!;
    for (var index = 0; index < 5; index++) {
      responses['$code${index + 1}'] = QuizResponse.rated(
        total ~/ 5 + (index < total % 5 ? 1 : 0),
      );
    }
  }
  return RiasecEngine.score(quizQuestions, responses);
}

AssessmentResult resultForCode(String code) {
  final other = RiasecEngine.codes.where((c) => !code.contains(c)).toList();
  return resultForScores({
    code[0]: 25,
    code[1]: 20,
    code[2]: 15,
    other[0]: 10,
    other[1]: 8,
    other[2]: 6,
  });
}
