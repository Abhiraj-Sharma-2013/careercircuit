class QuizQuestion {
  final String id;
  final String questionText;
  final List<QuizAnswer> answers;

  const QuizQuestion({
    required this.id,
    required this.questionText,
    required this.answers,
  });
}

class QuizAnswer {
  final String text;

  // Example: {'R': 1}
  final Map<String, int> scores;

  const QuizAnswer({required this.text, required this.scores});
}
