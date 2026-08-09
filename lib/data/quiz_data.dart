import '../models/quiz_question.dart';

const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    id: 'discovery_1',
    questionText: 'What kind of challenge sounds most exciting?',
    answers: [
      QuizAnswer(
        text: 'Solving a mystery',
        scores: {'Thinker': 2, 'TechAdapter': 1},
      ),
      QuizAnswer(
        text: 'Helping someone',
        scores: {'Helper': 2, 'Education': 1, 'Healthcare': 1},
      ),
      QuizAnswer(
        text: 'Building something',
        scores: {'Builder': 2, 'Engineering': 2},
      ),
      QuizAnswer(
        text: 'Creating something beautiful',
        scores: {'Creator': 2, 'Design': 2},
      ),
    ],
  ),

  QuizQuestion(
    id: 'discovery_2',
    questionText: 'Which school subject do you enjoy most?',
    answers: [
      QuizAnswer(
        text: 'Math',
        scores: {'Thinker': 2, 'Data': 1, 'Engineering': 1},
      ),
      QuizAnswer(
        text: 'Science',
        scores: {
          'Thinker': 1,
          'Healthcare': 1,
          'Environment': 1,
          'Engineering': 1,
        },
      ),
      QuizAnswer(text: 'Art', scores: {'Creator': 2, 'Design': 2}),
      QuizAnswer(
        text: 'Computer Science',
        scores: {'TechAdapter': 2, 'Software': 2, 'Cybersecurity': 1},
      ),
    ],
  ),

  QuizQuestion(
    id: 'discovery_3',
    questionText: 'What type of project sounds most fun?',
    answers: [
      QuizAnswer(
        text: 'Build an app or game',
        scores: {'Software': 3, 'TechAdapter': 2, 'Creator': 1},
      ),
      QuizAnswer(
        text: 'Protect people from online hackers',
        scores: {'Cybersecurity': 3, 'Thinker': 2, 'Helper': 1},
      ),
      QuizAnswer(
        text: 'Design a poster, logo, or app screen',
        scores: {'Design': 3, 'Creator': 2},
      ),
      QuizAnswer(
        text: 'Help younger students learn',
        scores: {'Teaching': 3, 'Helper': 2, 'Leader': 1},
      ),
    ],
  ),

  QuizQuestion(
    id: 'probe_tech_1',
    questionText: 'When using technology, what problem would you rather solve?',
    answers: [
      QuizAnswer(
        text: 'Make apps easier to use',
        scores: {'Design': 2, 'TechAdapter': 1, 'Helper': 1},
      ),
      QuizAnswer(
        text: 'Find patterns in data',
        scores: {'Data': 3, 'Thinker': 2},
      ),
      QuizAnswer(
        text: 'Stop cyber attacks',
        scores: {'Cybersecurity': 3, 'Thinker': 1, 'TechAdapter': 1},
      ),
      QuizAnswer(
        text: 'Build smart robots',
        scores: {'Engineering': 3, 'Builder': 2, 'TechAdapter': 1},
      ),
    ],
  ),

  QuizQuestion(
    id: 'probe_work_style_1',
    questionText: 'How do you like to work?',
    answers: [
      QuizAnswer(
        text: 'Quietly focusing on a hard problem',
        scores: {'Thinker': 2, 'Software': 1, 'Data': 1},
      ),
      QuizAnswer(
        text: 'Working with a team',
        scores: {'Helper': 1, 'Leader': 1, 'Business': 1},
      ),
      QuizAnswer(
        text: 'Creating and improving ideas',
        scores: {'Creator': 2, 'Design': 1, 'Business': 1},
      ),
      QuizAnswer(
        text: 'Doing hands-on building',
        scores: {'Builder': 2, 'Engineering': 2},
      ),
    ],
  ),

  QuizQuestion(
    id: 'ai_future_1',
    questionText: 'Which future skill sounds most interesting to learn?',
    answers: [
      QuizAnswer(
        text: 'Using AI to build apps',
        scores: {'Software': 2, 'TechAdapter': 2},
      ),
      QuizAnswer(
        text: 'Using AI to protect data',
        scores: {'Cybersecurity': 2, 'TechAdapter': 2},
      ),
      QuizAnswer(
        text: 'Using AI to understand health or science',
        scores: {'Healthcare': 2, 'Data': 1, 'Thinker': 1},
      ),
      QuizAnswer(
        text: 'Using AI to design creative projects',
        scores: {'Design': 2, 'Creator': 2},
      ),
    ],
  ),
];
