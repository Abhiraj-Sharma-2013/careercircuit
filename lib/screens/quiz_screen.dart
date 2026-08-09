import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/quiz_question.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;

  final Map<String, int> studentScores = {};

  void _answerQuestion(QuizAnswer selectedAnswer) {
    // Add selected answer scores to total student scores.
    selectedAnswer.scores.forEach((category, points) {
      studentScores[category] = (studentScores[category] ?? 0) + points;
    });

    final bool isLastQuestion =
        currentQuestionIndex == quizQuestions.length - 1;

    if (isLastQuestion) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(studentScores: studentScores),
        ),
      );
    } else {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final QuizQuestion currentQuestion = quizQuestions[currentQuestionIndex];

    final double progress = (currentQuestionIndex + 1) / quizQuestions.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Career Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: progress),

            const SizedBox(height: 24),

            Text(
              'Question ${currentQuestionIndex + 1} of ${quizQuestions.length}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 12),

            Text(
              currentQuestion.questionText,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            for (final answer in currentQuestion.answers)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _answerQuestion(answer),
                    child: Text(answer.text, textAlign: TextAlign.center),
                  ),
                ),
              ),

            const Spacer(),

            Text(
              'Current scores: $studentScores',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
