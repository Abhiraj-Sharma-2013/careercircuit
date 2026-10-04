# CareerCircuit

CareerCircuit is a privacy-first Flutter career-exploration app. Results come from a bundled dataset of 120 Holland codes and 210 occupations, with three pathways per code. There are no backend API calls, accounts, analytics, or AI scoring calls. The web version downloads its app files and bundled data from its static host.

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

Use Flutter **3.44.2** (Dart **3.12.2**). CI reads the Flutter version from `environment.flutter` in `pubspec.yaml`; update that value when upgrading the SDK.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

Tests cover actual asset integrity and caching, scoring and uncertainty boundaries, normalized explanations, six-page quiz flows, error recovery, alternate-code switching, and results for RIA, SEC, CEI and AER at 320dp width with 2x text. Rendered source/task text is included in wording guardrails.

## Web installation and GitHub Pages

The existing web manifest provides CareerCircuit branding, standalone display, portrait orientation, and relative app identity/start/scope URLs. Web icons are resized from `assets/career_circuit_logo.png`: 192px and 512px standard icons, padded maskable variants, a 180px Apple touch icon, and a 32px favicon. The maskable versions keep the logo inside the central safe area. Native launcher configuration is separate.

### Enable deployment

1. In the GitHub repository, open **Settings > Pages > Build and deployment** and select **GitHub Actions** as the source. No `gh-pages` branch or custom secrets are needed.
2. Ensure Actions are enabled under **Settings > Actions > General**. If your repository restricts actions, allow the `actions/*` actions and `subosito/flutter-action` used in `.github/workflows/deploy-pages.yml`. If the `github-pages` environment has deployment restrictions, allow the default branch (`main`).
3. Merge/push this setup to `main`. The **Deploy CareerCircuit to GitHub Pages** workflow installs Flutter from `pubspec.yaml`, gets dependencies, analyzes and tests the app, then builds and deploys `build/web`. You can also use **Actions > Deploy CareerCircuit to GitHub Pages > Run workflow** on the default branch. If the default branch is renamed, update the workflow's push branch filter.
4. Open the URL shown by the workflow's `github-pages` deployment or **Settings > Pages**. For this repository, the expected URL is **https://abhiraj-sharma-2013.github.io/careercircuit/**. It becomes available after a successful deployment.

The workflow derives `--base-href "/<repository-name>/"` from `GITHUB_REPOSITORY`, preserving Flutter's `$FLUTTER_BASE_HREF` placeholder in source. Manifest URLs and icon references stay relative to that subpath. `--no-web-resources-cdn` serves the Flutter renderer from the same site. Generated output under `build/` is ignored and uploaded as a Pages artifact, never committed. The workflow uses GitHub's [custom Pages workflow pattern](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages).

### Install on a phone

- **Android (Chrome):** open the deployed HTTPS URL, then choose **Install app** or **Add to Home screen** from the browser menu and confirm.
- **iOS (Safari):** open the deployed URL, tap **Share > Add to Home Screen**, leave **Open as Web App** enabled if offered, then tap **Add**.

Installation provides a home-screen launcher and standalone window. **Offline loading is not configured or guaranteed.** Flutter 3.44.2 deprecates the old `--pwa-strategy` option; this setup uses the standard bootstrap without legacy service-worker registration or caching APIs. A generated cleanup service worker may remove older Flutter caches; that is not offline caching. See Flutter's [web FAQ](https://docs.flutter.dev/platform-integration/web/faq). Keep a network connection when opening or reloading the installed app. Responses and theme selection remain in session memory.

### Test locally

For development, run `flutter run -d chrome`. To check the release app under the same project-site subpath (Python 3 required):

```sh
flutter pub get
flutter analyze
flutter test
flutter build web --release --no-web-resources-cdn --base-href /careercircuit/ --output build/preview/careercircuit
python -m http.server 8080 --bind 127.0.0.1 --directory build/preview
```

Open **http://localhost:8080/careercircuit/** (including the trailing slash). Check the quiz and results, then inspect **DevTools > Application > Manifest** for the name, icons, display mode, start URL, and scope. Confirm there are no missing scripts, renderer files, or dataset requests in the Network panel. Localhost is suitable for browser installability checks; use the deployed HTTPS URL for phone installation. Stop the server with Ctrl+C. Replace `careercircuit` in both the build path and URL if the repository is renamed.
