# CareerCircuit

CareerCircuit is a Flutter app for students to explore work interests and career possibilities.

## Assessment

- 30 activity ratings, five per Holland RIASEC category, grouped into six themed pages.
- Six-position sliders: gray Never tried, then five red-to-green enjoyment ratings with text labels. The exposure choice stores 3 points and a separate exposure-gap flag, never a zero interest score. Untouched sliders remain unanswered.
- Only a career-stage selection; no free-text collection. Responses and exposure flags stay in memory on the device for the session; there is no upload, analytics, or disk persistence in this assessment flow.
- Back navigation preserves answers; choosing an enjoyment position clears the exposure flag. All items must be answered before scoring.
- Pure Dart scoring sums five ratings per category (5 to 25). AI and preferences do not participate.
- Results show all six totals and exposure counts, preserve highest-score ties, and suggest exploration rather than career prescriptions. No confidence percentage is displayed.
- If over half the items are untried, all totals are equal, or every category totals at most 10, results offer the full catalogue alphabetically. These are conservative UI rules, not validated thresholds.
- Otherwise career suggestions use the existing sum of interest-tag totals, with alphabetical ties. This is a heuristic, not a calibrated match probability. Career profiles with different tag counts can receive different baseline totals.

**Draft item bank:** requires pilot testing and expert review. It is not a validated assessment or ability test. The 5 to 8 minute target requires timing with students, along with comprehension, reliability, category-overlap, and exposure-bias review.

## Structure

- `lib/data/quiz_data.dart`: runtime item bank, source of truth.
- `assets/riasec_questions.json`: portable JSON export (not runtime-loaded); a test enforces equality with the Dart bank.
- `lib/models/quiz_question.dart`: item metadata, exact scale labels, and local responses.
- `lib/models/assessment_result.dart`: immutable result snapshot and exploration rules.
- `lib/engine/riasec_engine.dart`: local scoring and bank/completion validation.
- `lib/screens/quiz_screen.dart`: introduction and mobile questionnaire.
- `lib/screens/results_screen.dart`: transparent scores and career exploration.
- `lib/engine/career_matcher.dart`: local career matching.
- `lib/data/career_data.dart`: existing career catalogue.

Future post-quiz preferences should only filter or contextualize browsing, never alter core scores.

## Development

Requires Flutter with Dart compatible with `pubspec.yaml` and a connected device or emulator.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

Tests cover bank/export integrity, scoring bounds, exposure replacement, missing responses, ties, and a full six-page, 30-item flow on a narrow screen with enlarged text.

## Themes and career stages

The top-right switch changes light/dark mode throughout the app; the initial mode follows the device. Theme and stage choices stay in memory for this session.

Before starting, choose Middle school, High school, College student, Graduate, or Working professional (career change). `lib/data/stage_question_text.dart` supplies all 150 activity wordings. Each wording maps to the same item ID, category, rating scale, and local scoring method. Stage is never an input to scoring or career ranking. Changing stages clears in-progress responses so a new wording set starts fresh; retaking from results preselects the last stage.

These custom wording variants need comprehension and equivalence review across audiences. They are not validated stage-specific assessments or age norms. The base JSON export remains the original common-language bank; stage variants are maintained separately in Dart.

Stage wording progresses from concrete examples for younger learners to direct vocational activities for older audiences. Category and sub-angle remain stable, but broader activity contexts mean cross-stage score equivalence has not been established.
