import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/quiz_question.dart';
import '../models/student_intake.dart';
import 'results_screen.dart';

const sectionNames = [
  'Interests',
  'Strengths',
  'Work environment',
  'Personality',
  'Values',
  'Career direction',
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int? selectedGrade;
  bool profileComplete = false;

  final likesController = TextEditingController();
  final dislikesController = TextEditingController();
  final profileFormKey = GlobalKey<FormState>();
  final List<QuizAnswer?> selectedAnswers = List<QuizAnswer?>.filled(
    quizQuestions.length,
    null,
  );

  Map<String, int> get studentScores {
    final scores = <String, int>{};

    for (final answer in selectedAnswers) {
      if (answer == null) continue;
      for (final entry in answer.scores.entries) {
        scores[entry.key] = (scores[entry.key] ?? 0) + entry.value;
      }
    }

    return scores;
  }

  @override
  void dispose() {
    likesController.dispose();
    dislikesController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    setState(() {
      profileComplete = true;
    });
  }

  Future<void> _answerQuestion(QuizAnswer selectedAnswer) async {
    setState(() {
      selectedAnswers[currentQuestionIndex] = selectedAnswer;
    });

    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;

    final bool isLastQuestion =
        currentQuestionIndex == quizQuestions.length - 1;

    if (isLastQuestion) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            studentScores: studentScores,
            studentIntake: StudentIntake(
              grade: selectedGrade,
              likes: likesController.text.trim(),
              dislikes: dislikesController.text.trim(),
            ),
          ),
        ),
      );
    } else {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _goBack() {
    if (!profileComplete) {
      Navigator.pop(context);
      return;
    }

    if (currentQuestionIndex == 0) {
      setState(() {
        profileComplete = false;
      });
      return;
    }

    setState(() {
      currentQuestionIndex--;
    });
  }

  String _gradeLabel(int grade) => '$grade${grade == 6 ? 'th' : 'th'} grade';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Career Quiz'),
          leading: BackButton(onPressed: _goBack),
        ),
        body: profileComplete ? _buildQuestionView() : _buildProfileView(),
      ),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: profileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about yourself',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'These questions are optional, but answering them is encouraged '
              'for more relevant career suggestions.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 28),
            DropdownButtonFormField<int>(
              initialValue: selectedGrade,
              decoration: const InputDecoration(
                labelText: 'Grade',
                border: OutlineInputBorder(),
              ),
              items: [
                for (int grade = 6; grade <= 12; grade++)
                  DropdownMenuItem(
                    value: grade,
                    child: Text(_gradeLabel(grade)),
                  ),
              ],
              onChanged: (value) => setState(() => selectedGrade = value),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: likesController,
              maxLength: 50,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Strong likes',
                hintText: 'Subjects, activities, or topics you enjoy',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: dislikesController,
              maxLength: 50,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Strong dislikes',
                hintText: 'Subjects, activities, or tasks you dislike',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _startQuiz,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Start quiz'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionView() {
    final question = quizQuestions[currentQuestionIndex];
    final currentSectionIndex = currentQuestionIndex ~/ 3;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionProgress(
            selectedAnswers: selectedAnswers,
            currentSectionIndex: currentSectionIndex,
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${sectionNames[currentSectionIndex]} · section ${currentSectionIndex + 1} of ${sectionNames.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Question ${currentQuestionIndex % 3 + 1} of 3',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question.questionText,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 22),
          for (final answer in question.answers)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AnswerButton(
                answer: answer,
                selected: selectedAnswers[currentQuestionIndex] == answer,
                onPressed: () => _answerQuestion(answer),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionProgress extends StatelessWidget {
  final List<QuizAnswer?> selectedAnswers;
  final int currentSectionIndex;

  const _SectionProgress({
    required this.selectedAnswers,
    required this.currentSectionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int section = 0; section < sectionNames.length; section++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: section == 5 ? 0 : 5),
              child: _SectionBar(
                answeredCount: selectedAnswers
                    .sublist(section * 3, section * 3 + 3)
                    .where((answer) => answer != null)
                    .length,
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionBar extends StatelessWidget {
  final int answeredCount;

  const _SectionBar({required this.answeredCount});

  @override
  Widget build(BuildContext context) {
    final Color progressColor = switch (answeredCount) {
      1 => const Color(0xFFB9DDF7),
      2 => const Color(0xFF6F9FC5),
      3 => const Color(0xFF123B63),
      _ => const Color(0xFFFFFFFF),
    };

    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: progressColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final QuizAnswer answer;
  final bool selected;
  final VoidCallback onPressed;

  const _AnswerButton({
    required this.answer,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primary.withValues(alpha: 0.18)
            : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF123B63,
            ).withValues(alpha: selected ? 0.12 : 0.06),
            blurRadius: selected ? 8 : 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: selected
              ? colorScheme.primary
              : colorScheme.onSurface,
          side: BorderSide(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Align(alignment: Alignment.centerLeft, child: Text(answer.text)),
      ),
    );
  }
}
