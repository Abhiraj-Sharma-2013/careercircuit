# Dataset-backed results integration

## Source and scope

The bundled `assets/career_dataset.json` is byte-for-byte identical to the supplied v1.1 JSON. SHA-256: `5f06f50044400b0c46f37ad89fb5b5241daba4c7a80b9b44aba9e0338cfbac5e`.

It contains all 120 unique ordered three-letter RIASEC permutations and 210 careers. Every code resolves to three distinct careers; each career has exactly three topics and three skills. JSON and CSV shared fields agree. The CSV and Markdown are supporting review material, not duplicate runtime assets or instructions to execute.

The app preserves supplied pathway, topic, skill and task ordering. It does not recompute the dataset's offline ranking algorithm or sort pathways by education or AI exposure. Career stage has no effect on pathway ordering. The former eight-career catalogue and tag-sum matcher are removed.

## Explicit display exception

The user approved replacing the word `accuracy` with `correctness` in displayed source text to satisfy the results-page wording guardrail. The original dataset is unchanged. This affects 10 supplied fields: one career description and nine sample tasks. All other supplied summaries, task prose, labels, hedges, learning notes and metadata are displayed verbatim. Both collapsed and expanded results content are covered by wording tests.

## Interpretation and uncertainty

Raw score = five ratings summed (5 to 25); displayed interest level = raw / 25 * 100. No scoring math was changed. Original responses and exposure flags are retained, and alternate-code selection never recalculates them.

Exact ties retain the existing deterministic RIASEC order. Near ties offer two specific nearby interpretations: swap first/second when within two points, and substitute fourth for third when within one point. This is not an exhaustive set of permutations for a fully flat profile; the banner explains that several directions remain open.

More than 40% untried, 80% repeated numeric ratings (including midpoint exposure substitutions), or under 90 seconds yields a supportive more-exploration message. A max-minus-min spread of three or less otherwise yields a balanced message. These are product heuristics, not calibrated uncertainty statistics. Missing historical timing stays unknown rather than being treated as zero seconds.

The session Stopwatch starts at Start quiz, includes revisiting sections, stops on results, and resets if the stage changes. Nothing is persisted or uploaded.

For explanations, student percentages are divided by 100 and O*NET values normalized with `(value - 1) / 6`. Shared top-three interests are presented in student-score order. Career top-interest differences remain visible. AI percentile ranks and averages are labeled as exposure context, never outcome probabilities.

## Dataset limits and workarounds

- The metadata describes a rule-based AI index with a comparison to published occupation lists. The app displays this as supplied provenance; this integration does not independently validate that method or its forecasts.
- The supplied cluster summaries are generic templates and sometimes describe selected pathways as scoring highest on the code even when their own top-interest codes differ. The runtime fit explanation and explicit career-versus-student codes make this imperfect fit visible without changing the requested summary.
- Some `howToStart` suggestions refer to clubs, classes, care settings, or equipment even though the learning note claims no special access is needed. Those supplied suggestions were not silently rewritten. Learning guidance also remains student-oriented for the graduate/professional stages.
- One career (`29-1022.00`) has no tools. Its tools section is omitted; software examples elsewhere are explicitly examples, not purchase requirements.
- Rating-band metadata uses whole-percentile wording while the supplied values contain decimals. The app preserves the supplied High/Medium/Low labels and cutoffs rather than inferring a new rounding rule.
- The O*NET preparation descriptions are typical pathways, not admission requirements or judgments of a student's capacity.
- Dataset errors fail assertions during development. Release validation rejects inconsistent data and shows the local score profile plus retry/retake actions, never a stale fallback catalogue.
- `compute` performs parsing/model validation in a background isolate on native Flutter targets. Flutter's web implementation of compute runs on the browser event loop; the cache still prevents per-build decoding.

## Changed-file map

Added: bundled dataset; immutable dataset models; repository; results view-model; fit/wording presentation helpers; pathway-card widget; repository, view-model, explanation and responsive results tests.

Changed: asset registration; results screen; quiz session timing; removal of obsolete interpretation helpers; quiz integration tests; README.

Retired: `lib/data/career_data.dart`, `lib/engine/career_matcher.dart`, `lib/models/career.dart`, `lib/screens/career_detail_screen.dart`, `test/career_matcher_test.dart`, and the old static summary table/helper tests. Existing user deletions of category metadata and favorites files were preserved.
