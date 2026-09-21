# CareerCircuit

CareerCircuit is a privacy-first Flutter career-exploration app. Results come from a bundled dataset of 120 Holland codes and 210 occupations, with three pathways per code. There are no runtime network calls, accounts, analytics, or AI scoring calls.

## Assessment and results

- 30 activity ratings, five per RIASEC category, on six compact pages.
- Six slider positions: gray Never tried, then five enjoyment ratings. Never tried stores rating 3 and a separate exposure flag; an untouched slider remains unanswered.
- Local scoring is unchanged: sum five ratings per category (5 to 25). Results display raw / 25 * 100 as reported **interest level**, never ability or a success probability.
- Rank raw totals using RIASEC order for exact ties. Close first/second and third/fourth totals produce alternate codes without changing responses or scores.
- Uncertainty checks cover broad profiles, over 40% untried items, 80% repeated ratings, and completion under 90 seconds. These are supportive UI heuristics, not validated confidence estimates.
- A local Stopwatch starts when the quiz starts and resets with a new stage. Timing, responses, stage, and theme remain in session memory only.
- Results use the dataset's three career IDs in their supplied order. AI exposure, learning lists, tools, sample tasks and source metadata come from the same asset.
- AI numbers are exposure percentile ranks among occupations, not job-loss probabilities. Career fit explanations compare normalized interest profiles without inventing suitability claims.

## Data and architecture

- `assets/career_dataset.json`: unmodified supplied dataset v1.1, registered as a Flutter asset.
- `lib/models/career_dataset.dart`: six immutable JSON model types and structural validation.
- `lib/repositories/career_data_repository.dart`: singleton, concurrent-load caching, compute-based decoding/validation, retry after failure.
- `lib/view_models/results_view_model.dart`: pure interpretation of quiz scores and response metadata, independent of the dataset.
- `lib/presentation/career_fit.dart`: data-derived interest-overlap explanations.
- `lib/presentation/results_wording.dart`: wording policy and approved source-text display substitution.
- `lib/screens/results_screen.dart`: CustomScrollView, six accessible interest bars, uncertainty, alternate codes, lazy pathway cards, and sources.
- `lib/widgets/pathway_card.dart`: full dataset-backed pathway content with expandable sample tasks.
- `lib/data/quiz_data.dart` and `lib/data/stage_question_text.dart`: core activities and stage wording.
- `assets/riasec_questions.json`: portable base-item export; tests enforce parity with the Dart base bank.

The old small catalogue, interest-tag matcher, generic static summaries, obsolete career detail screen and their obsolete tests have been retired. [Dataset integration notes](docs/results_dataset_integration.md) record evidence limitations and display decisions.

## Themes and stages

The top-right switch controls light/dark mode across the app, initially following the device. Stages are Middle school, High school, College student, Graduate, and Working professional. Stage only changes activity wording, never scores or dataset ranking. Changing stages starts a fresh quiz; retaking results preselects the previous stage.

This is a custom draft item bank requiring pilot testing and expert review. Stage wording equivalence and the 5 to 8 minute target are not established. A RIASEC framework alone does not validate these items.

## Development

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

Tests cover actual asset integrity and caching, scoring and uncertainty boundaries, normalized explanations, six-page quiz flows, error recovery, alternate-code switching, and results for RIA, SEC, CEI and AER at 320dp width with 2x text. Rendered source/task text is included in wording guardrails.
