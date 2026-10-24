import '../models/quiz_question.dart';

// Custom item bank: requires pilot testing and expert review.
const quizSections = <String, String>{
  'R': 'Making',
  'I': 'Exploring',
  'A': 'Creating',
  'S': 'Helping',
  'E': 'Leading',
  'C': 'Organizing',
};

const quizQuestions = <QuizQuestion>[
  QuizQuestion(
    id: "R1",
    riasecType: "R",
    text: "Put together a small shelf using separate parts.",
  ),
  QuizQuestion(
    id: "R2",
    riasecType: "R",
    text: "Repair a drawer that keeps getting stuck.",
  ),
  QuizQuestion(
    id: "R3",
    riasecType: "R",
    text: "Use a screwdriver to tighten a loose handle.",
  ),
  QuizQuestion(
    id: "R4",
    riasecType: "R",
    text: "Prepare the soil for an outdoor garden.",
  ),
  QuizQuestion(
    id: "R5",
    riasecType: "R",
    text: "Shape clay into a cup or bowl.",
  ),
  QuizQuestion(
    id: "I1",
    riasecType: "I",
    text: "Research a science question you are curious about.",
  ),
  QuizQuestion(
    id: "I2",
    riasecType: "I",
    text: "Look for patterns in the results of a survey.",
  ),
  QuizQuestion(
    id: "I3",
    riasecType: "I",
    text: "Test whether plants grow differently with more light.",
  ),
  QuizQuestion(
    id: "I4",
    riasecType: "I",
    text: "Use clues to find out why a flashlight stopped working.",
  ),
  QuizQuestion(
    id: "I5",
    riasecType: "I",
    text: "Solve a puzzle by finding the right order of steps.",
  ),
  QuizQuestion(
    id: "A1",
    riasecType: "A",
    text: "Design the cover of a book or magazine.",
  ),
  QuizQuestion(
    id: "A2",
    riasecType: "A",
    text: "Write a short story with characters you invent.",
  ),
  QuizQuestion(
    id: "A3",
    riasecType: "A",
    text: "Act out a scene from a story.",
  ),
  QuizQuestion(
    id: "A4",
    riasecType: "A",
    text: "Invent a game with your own rules.",
  ),
  QuizQuestion(
    id: "A5",
    riasecType: "A",
    text: "Draw a comic that helps explain an idea.",
  ),
  QuizQuestion(
    id: "S1",
    riasecType: "S",
    text: "Explain a new task to someone learning it.",
  ),
  QuizQuestion(
    id: "S2",
    riasecType: "S",
    text: "Listen while someone talks through a problem.",
  ),
  QuizQuestion(
    id: "S3",
    riasecType: "S",
    text: "Coach someone as they practice a new skill.",
  ),
  QuizQuestion(
    id: "S4",
    riasecType: "S",
    text: "Hand out supplies at a community donation event.",
  ),
  QuizQuestion(
    id: "S5",
    riasecType: "S",
    text: "Team up with others to help a new student feel welcome.",
  ),
  QuizQuestion(
    id: "E1",
    riasecType: "E",
    text: "Lead a team working on a group project.",
  ),
  QuizQuestion(
    id: "E2",
    riasecType: "E",
    text: "Give reasons why a group should try your idea.",
  ),
  QuizQuestion(
    id: "E3",
    riasecType: "E",
    text: "Start a small event that others can join.",
  ),
  QuizQuestion(
    id: "E4",
    riasecType: "E",
    text: "Decide which idea a team should work on first.",
  ),
  QuizQuestion(
    id: "E5",
    riasecType: "E",
    text: "Sell a product at a small market stand.",
  ),
  QuizQuestion(
    id: "C1",
    riasecType: "C",
    text: "Set dates for each step of a group project.",
  ),
  QuizQuestion(
    id: "C2",
    riasecType: "C",
    text: "Sort project notes into clearly labeled groups.",
  ),
  QuizQuestion(
    id: "C3",
    riasecType: "C",
    text: "Check a list for missing or repeated items.",
  ),
  QuizQuestion(
    id: "C4",
    riasecType: "C",
    text: "Track how many supplies are left after each use.",
  ),
  QuizQuestion(
    id: "C5",
    riasecType: "C",
    text: "Follow a checklist to set up for an activity.",
  ),
];
