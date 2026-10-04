import 'package:flutter/material.dart';
import '../models/career_dataset.dart';
import '../presentation/career_fit.dart';
import '../presentation/results_wording.dart';
import '../view_models/results_view_model.dart';

/// All source text passes through the one approved display substitution.
class DatasetText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const DatasetText(this.text, {super.key, this.style});
  @override
  Widget build(BuildContext context) =>
      Text(displayDatasetText(text), style: style);
}

class InfoPill extends StatelessWidget {
  final String text;
  final Color? color;
  const InfoPill(this.text, {super.key, this.color});
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color ?? Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: DatasetText(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class PathwayCard extends StatelessWidget {
  final CareerRecord career;
  final ResultsViewModel profile;
  final int position;
  final bool isExpanded;
  final VoidCallback onToggle;
  const PathwayCard({
    super.key,
    required this.career,
    required this.profile,
    required this.position,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fit = CareerFit.forProfile(profile, career);
    return Card(
      color: isExpanded ? null : theme.colorScheme.primaryContainer,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: isExpanded,
            child: InkWell(
              key: ValueKey('pathway-toggle-${career.id}'),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PATHWAY $position',
                            style: theme.textTheme.labelLarge!.copyWith(
                              color: isExpanded
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onPrimaryContainer,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DatasetText(
                            career.title,
                            key: ValueKey('career-title-${career.id}'),
                            style: theme.textTheme.headlineSmall!.copyWith(
                              color: isExpanded
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: isExpanded
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // All preparation levels use the same neutral hue family, not a value judgment.
                  InfoPill(
                    'Preparation: ${career.preparation}',
                    color: Color.lerp(
                      theme.colorScheme.surfaceContainerLow,
                      theme.colorScheme.primaryContainer,
                      career.jobZone / 5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preparation level ${career.jobZone} of 5',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  DatasetText(career.description),
                  const _Heading('Why this fits you'),
                  Text(fit.explanation),
                  if (!fit.sameOrderedCode) ...[
                    const SizedBox(height: 8),
                    Text(
                      "This path's own interest code is ${career.topInterests}; your calculated code is ${profile.hollandCode}. The interest profiles are not identical.",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  const _Heading('AI impact'),
                  Text(ResultsWording.aiFraming),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InfoPill(career.aiImpactRating),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI exposure percentile rank: ${career.aiImpactPercentile.toStringAsFixed(1)} among occupations.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Exposure describes tasks AI may affect, not the chance of losing a job.',
                  ),
                  const SizedBox(height: 12),
                  DatasetText(career.aiImpactSummary),
                  _Heading(career.aiAssistLabel, source: true),
                  _Bullets(career.aiLikelyToAssist),
                  const _Heading('Likely to stay human'),
                  _Bullets(career.aiUnlikelyToReplace),
                  const SizedBox(height: 10),
                  DatasetText(
                    'Durable human skill: ${career.durableHumanSkill}',
                    style: theme.textTheme.titleSmall,
                  ),
                  const _Heading('Topics to learn or explore'),
                  const Text(
                    'The first topic and skill carry the most weight in this learning list.',
                  ),
                  const SizedBox(height: 10),
                  for (final item in career.topicsToExplore) _LearningRow(item),
                  const _Heading('Skills to build'),
                  for (final item in career.skillsToLearn) _LearningRow(item),
                  if (career.toolsToTry.isNotEmpty) ...[
                    const _Heading('Tools used in this field'),
                    const Text(
                      'Examples used in this field, not tools you need to buy or own.',
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tool in career.toolsToTry)
                          InfoPill(
                            '${tool.category} (e.g. ${tool.example})',
                            color: theme.colorScheme.surfaceContainerHigh,
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  DatasetText(
                    career.learningNote,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    key: PageStorageKey('tasks-${career.id}'),
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(bottom: 12),
                    title: const Text('What you would actually do'),
                    children: [_Bullets(career.sampleTasks)],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;
  final bool source;
  const _Heading(this.text, {this.source = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 10),
    child: source
        ? DatasetText(text, style: Theme.of(context).textTheme.titleMedium)
        : Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _LearningRow extends StatelessWidget {
  final LearningItem item;
  const _LearningRow(this.item);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DatasetText(item.name, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        DatasetText(
          item.howToStart,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  );
}

class _Bullets extends StatelessWidget {
  final List<String> items;
  const _Bullets(this.items);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final item in items)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 7, right: 10),
                child: Icon(Icons.circle, size: 5),
              ),
              Expanded(child: DatasetText(item)),
            ],
          ),
        ),
    ],
  );
}
