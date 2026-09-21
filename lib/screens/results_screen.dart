import 'package:flutter/material.dart';
import '../data/career_data.dart';
import '../engine/career_matcher.dart';
import '../engine/riasec_engine.dart';
import '../models/assessment_result.dart';
import '../models/career_stage.dart';
import '../widgets/app_chrome.dart';
import 'career_detail_screen.dart';
import 'quiz_screen.dart';

class ResultsScreen extends StatelessWidget {
  final AssessmentResult result;
  final CareerStage stage;

  const ResultsScreen({super.key, required this.result, required this.stage});

  @override
  Widget build(BuildContext context) {
    final broad = result.showBroadExploration;
    final careers = broad
        ? (List.of(careerData)..sort((a, b) => a.title.compareTo(b.title)))
        : CareerMatcher.getTopCareerMatches(careerData, result.scores);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your possibilities'),
        actions: const [ThemeToggle()],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              JourneyBanner(
                eyebrow: stage.label,
                title: 'Follow your curiosity.',
                subtitle:
                    'Your interests are a starting point. Explore a few paths and see what catches your attention.',
                icon: Icons.auto_awesome_rounded,
              ),
              const SizedBox(height: 20),
              const Text(
                'For exploration only: These career ideas are based on your interests. Try activities and learn about different paths to see what you enjoy.',
              ),
              const SizedBox(height: 24),
              Text(
                'Your activity interests',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              if (result.mostlyUntried)
                const Text(
                  'Many activities are new to you. Try a few that spark your curiosity before drawing conclusions about your interests.',
                )
              else if (result.allLow)
                const Text(
                  'These activities received mostly low ratings. Explore other activities too; this short quiz cannot cover every interest.',
                )
              else if (result.isFlat)
                const Text(
                  'Your category scores are equal. There is no single highest interest in these answers.',
                )
              else
                Text(
                  'Highest activity ratings: ${result.highestCodes.map((code) => RiasecEngine.labels[code]).join(', ')}. Equal scores stay tied; they do not show a preference between those categories.',
                ),
              const SizedBox(height: 16),
              const Text(
                'Each category totals five ratings: 5 to 25 points. These are interest ratings, not percentages or measures of skill. Scores are calculated on your device.',
              ),
              const SizedBox(height: 16),
              for (final code in RiasecEngine.codes)
                Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${RiasecEngine.labels[code]}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Text(
                              '${result.scores[code]}/25',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: result.scores[code]! / 25,
                          semanticsLabel:
                              '${RiasecEngine.labels[code]} interest score',
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${result.exposureGaps[code]} of 5 not tried',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              if (result.exposureGapCount > 0) ...[
                Text(
                  '${result.exposureGapCount} of 30 activities marked not tried. Each uses the middle score. This can pull scores toward the middle; it does not mean you dislike those activities.',
                ),
                const SizedBox(height: 16),
              ],
              Text(
                broad ? 'Browse career possibilities' : 'Careers to explore',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                broad
                    ? 'Browse the full catalogue in alphabetical order. These are possibilities, not personalized rankings.'
                    : 'These suggestions compare your local interest totals with career interest tags. They are starting points, not predictions of success. Careers with equal totals are listed alphabetically.',
              ),
              const SizedBox(height: 16),
              for (final career in careers)
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      Icons.explore_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(
                      career.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(career.shortDescription),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CareerDetailScreen(career: career),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(initialStage: stage),
                  ),
                ),
                child: const Text('Explore again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
