# CareerCircuit

CareerCircuit is a Flutter career discovery app that helps students explore future-focused career paths through a short interactive quiz.

The app asks a series of personal-interest questions, calculates career interest scores, and recommends top career matches along with detailed role information and AI impact insights.

## Features

- Welcome screen with a simple “Get Started” flow
- Multi-question career interest quiz
- Scoring engine that maps quiz answers to career categories
- Results screen with:
  - top matched careers
  - confidence score
  - interest score breakdown
- Career detail pages including:
  - career description
  - recommended school subjects
  - useful skills
  - starter project ideas
  - AI risk / impact
  - future-proof score
  - alternative career suggestions

## Built With

- Flutter
- Dart
- Android Studio

## Project Structure

- `lib/main.dart` — app entry point
- `lib/screens/welcome_screen.dart` — landing screen
- `lib/screens/quiz_screen.dart` — quiz interaction screen
- `lib/screens/results_screen.dart` — career match results
- `lib/screens/career_detail_screen.dart` — detailed career view
- `lib/engine/career_matcher.dart` — matching logic and scoring
- `lib/data/quiz_data.dart` — quiz questions and answer scoring
- `lib/data/career_data.dart` — career definitions
- `lib/data/career_categories.dart` — career category metadata
- `lib/models/quiz_question.dart` — quiz model
- `lib/models/career.dart` — career model
- `lib/models/career_category.dart` — career category model

## Getting Started

### Prerequisites

- Flutter SDK
- A connected device or emulator

### Run Locally

```bash
cd C:\Workspaces\AppdevWorkspace\careercircuit
flutter pub get
flutter run