import '../models/quiz_question.dart';

const realisticScores = {'R': 1};
const investigativeScores = {'I': 1};
const artisticScores = {'A': 1};
const socialScores = {'S': 1};
const enterprisingScores = {'E': 1};
const conventionalScores = {'C': 1};

const practicalScores = realisticScores;
const analyticalScores = investigativeScores;
const creativeScores = artisticScores;
const helpingScores = socialScores;
const leadershipScores = enterprisingScores;
const organizedScores = conventionalScores;

const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    id: 'interests_1',
    questionText: 'Which activity sounds most enjoyable?',
    answers: [
      QuizAnswer(
        text: 'Building, repairing, or working with tools/equipment',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Investigating how something works or solving a difficult puzzle',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Drawing, writing, performing, or designing something original',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'Helping, teaching, supporting, or caring for someone',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'Leading a group, selling an idea, or starting a project',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'Organizing information, schedules, files, or money',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'interests_2',
    questionText: 'Which school assignment would you most like to receive?',
    answers: [
      QuizAnswer(
        text: 'Create a working model or conduct a hands-on experiment',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Research a question and explain your findings',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Make a video, presentation, story, artwork, or design',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'Tutor another student or plan a community-help project',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'Pitch a product, debate an issue, or lead a campaign',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'Analyze a spreadsheet, create a detailed plan, or organize data',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'interests_3',
    questionText:
        'If you had a free afternoon, what would you most likely choose?',
    answers: [
      QuizAnswer(
        text: 'Make, fix, assemble, cook, garden, or play a sport',
        scores: practicalScores,
      ),
      QuizAnswer(
        text:
            'Code, read about science/history, play strategy games, or solve puzzles',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Create music, art, writing, photography, fashion, or content',
        scores: creativeScores,
      ),
      QuizAnswer(
        text:
            'Spend time helping friends, volunteering, coaching, or mentoring',
        scores: helpingScores,
      ),
      QuizAnswer(
        text:
            'Plan an event, negotiate, compete, fundraise, or build a small business',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text:
            'Sort a collection, budget, plan a trip, or make a checklist/system',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'strengths_1',
    questionText: 'What do people most often ask you for help with?',
    answers: [
      QuizAnswer(
        text: 'Fixing or setting up something practical',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Understanding a hard topic or finding an answer',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Making something look, sound, or feel better',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'Listening, explaining, encouraging, or resolving disagreements',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'Making decisions, motivating others, or presenting an idea',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'Keeping things organized, accurate, and on schedule',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'strengths_2',
    questionText: 'What kind of challenge do you most enjoy?',
    answers: [
      QuizAnswer(
        text: 'A physical or hands-on challenge with a visible result',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'A complex problem with a logical answer',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'An open-ended challenge where I can invent my own answer',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'A challenge involving someone’s feelings or needs',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'A challenge where I persuade people or compete to win',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text:
            'A challenge requiring accuracy, planning, and attention to detail',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'strengths_3',
    questionText: 'In a team project, which role fits you best?',
    answers: [
      QuizAnswer(
        text: 'Builder, tester, or person who makes the project work',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Researcher, analyst, or technical problem-solver',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Idea generator, designer, writer, or presenter',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'Supporter, mediator, teacher, or morale-builder',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'Leader, spokesperson, or decision-maker',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'Planner, note-taker, scheduler, or quality checker',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'work_environment_1',
    questionText: 'Which work setting sounds most appealing?',
    answers: [
      QuizAnswer(
        text:
            'Workshop, construction site, outdoors, kitchen, or equipment room',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Lab, engineering space, research setting, or computer workspace',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text:
            'Studio, media room, theater, design agency, or flexible creative space',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'School, clinic, community center, hospital, or nonprofit',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'Business, courtroom, sales floor, startup, or event venue',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'Office, operations center, bank, library, or records department',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'work_environment_2',
    questionText: 'What balance of structure do you prefer?',
    answers: [
      QuizAnswer(
        text: 'Clear task, then freedom to work hands-on',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'A difficult goal with time to investigate the best solution',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Very open freedom to experiment and create',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'Flexible work centered on people’s changing needs',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'Freedom to take initiative and make big decisions',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'Clear rules, processes, and expectations',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'work_environment_3',
    questionText: 'Which describes your ideal workday?',
    answers: [
      QuizAnswer(
        text: 'Active and physical, with tangible results by the end',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Quiet focus on investigating, analyzing, or solving',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Variety, imagination, and making something new',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'Conversations and direct interaction with people',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'Fast-moving goals, decisions, competition, or influence',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'Organized tasks, reliable routines, and clear completion steps',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'personality_1',
    questionText: 'When you face a problem, what is your first instinct?',
    answers: [
      QuizAnswer(
        text: 'Try it, test it, or take it apart to see what works',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Gather facts and think through the cause',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Imagine unusual possibilities or a new approach',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'Ask who is affected and how I can help',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'Take charge and get people moving toward a solution',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'Break it into steps and make a plan',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'personality_2',
    questionText: 'What type of feedback motivates you most?',
    answers: [
      QuizAnswer(
        text: 'You made that work really well.',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Your reasoning and analysis were excellent.',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Your idea was original and expressive.',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'You made a real difference for someone.',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'You inspired people and achieved a big goal.',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'You were dependable, accurate, and well organized.',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'personality_3',
    questionText: 'Which statement sounds most like you?',
    answers: [
      QuizAnswer(
        text:
            'I like doing practical things rather than only talking about them.',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'I need to understand why something works.',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'I want to express ideas in my own way.',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'I care deeply about people and relationships.',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'I enjoy influencing others and making things happen.',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'I like order, details, and knowing what comes next.',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'values_1',
    questionText: 'Which outcome from a future job would matter most?',
    answers: [
      QuizAnswer(
        text: 'Creating or repairing things people can use',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Discovering knowledge or solving important technical problems',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text:
            'Producing work that people find meaningful, beautiful, or entertaining',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'Improving people’s lives directly',
        scores: helpingScores,
      ),
      QuizAnswer(
        text:
            'Leading change, growing an organization, or earning through results',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'Making an organization run smoothly and reliably',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'values_2',
    questionText:
        'How much education or training would you be comfortable pursuing?',
    answers: [
      QuizAnswer(
        text: 'I would prefer training that gets me working fairly quickly',
        scores: practicalScores,
      ),
      QuizAnswer(
        text:
            'I am comfortable with long, challenging education for a specialized field',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text:
            'It depends on whether I can keep creating and building a portfolio',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'I would train longer if it lets me help people professionally',
        scores: helpingScores,
      ),
      QuizAnswer(
        text:
            'I would invest in education if it helps me lead or build something',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text:
            'I value certifications, clear qualifications, and steady advancement',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'values_3',
    questionText: 'Which trade-off would you most willingly make?',
    answers: [
      QuizAnswer(
        text: 'Physical work in exchange for less screen time and more action',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Hard academic work in exchange for solving difficult problems',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Uncertainty in exchange for creative freedom',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'Emotional challenges in exchange for helping people',
        scores: helpingScores,
      ),
      QuizAnswer(
        text:
            'Pressure and competition in exchange for opportunity and influence',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'Less variety in exchange for stability and predictability',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'direction_1',
    questionText: 'Which career cluster sounds most interesting right now?',
    answers: [
      QuizAnswer(
        text:
            'Skilled trades, manufacturing, agriculture, transportation, or public safety',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'Science, engineering, software, medicine, or research',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'Art, design, media, writing, entertainment, or architecture',
        scores: creativeScores,
      ),
      QuizAnswer(
        text:
            'Education, counseling, healthcare, social work, or community service',
        scores: helpingScores,
      ),
      QuizAnswer(
        text:
            'Business, law, marketing, entrepreneurship, management, or politics',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text:
            'Finance, accounting, logistics, administration, data operations, or IT support',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'direction_2',
    questionText: 'What kind of result would make you proudest?',
    answers: [
      QuizAnswer(
        text: 'I built or fixed something useful.',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'I discovered or solved something difficult.',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'I created something memorable.',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'I helped someone grow, heal, or succeed.',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'I led people toward a successful outcome.',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'I made a complicated system work smoothly.',
        scores: organizedScores,
      ),
    ],
  ),
  QuizQuestion(
    id: 'direction_3',
    questionText: 'What is the biggest reason you might reject a career?',
    answers: [
      QuizAnswer(
        text: 'It is too sedentary or disconnected from real-world work',
        scores: practicalScores,
      ),
      QuizAnswer(
        text: 'It does not challenge me intellectually',
        scores: analyticalScores,
      ),
      QuizAnswer(
        text: 'It gives me little room for imagination or self-expression',
        scores: creativeScores,
      ),
      QuizAnswer(
        text: 'It has little human connection or positive impact',
        scores: helpingScores,
      ),
      QuizAnswer(
        text: 'It offers little influence, growth, or opportunity',
        scores: leadershipScores,
      ),
      QuizAnswer(
        text: 'It is too unpredictable, disorganized, or error-prone',
        scores: organizedScores,
      ),
    ],
  ),
];
