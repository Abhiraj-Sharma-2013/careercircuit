import 'package:flutter/material.dart';
import '../engine/riasec_engine.dart';
import '../models/assessment_result.dart';
import '../models/career_stage.dart';
import '../models/career_dataset.dart';
import '../presentation/results_wording.dart';
import '../presentation/career_fit.dart';
import '../repositories/career_data_repository.dart';
import '../view_models/results_view_model.dart';
import '../widgets/app_chrome.dart';
import '../widgets/pathway_card.dart';
import 'quiz_screen.dart';

class ResultsScreen extends StatefulWidget {
  final AssessmentResult result;
  final CareerStage stage;
  final Duration? completionTime;
  final CareerDataRepository? repository;
  const ResultsScreen({
    super.key,
    required this.result,
    required this.stage,
    this.completionTime,
    this.repository,
  });
  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ResultsViewModel _profile;
  late String _selectedCode;
  late CareerDataRepository _repository;
  late Future<void> _loading;
  String? _expandedCareerId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    _expandedCareerId = null;
    _profile = ResultsViewModel.fromAssessment(
      widget.result,
      completionTime: widget.completionTime,
    );
    _selectedCode = _profile.hollandCode;
    _repository = widget.repository ?? CareerDataRepository.instance;
    _loading = _repository.ensureLoaded();
  }

  @override
  void didUpdateWidget(covariant ResultsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.result != widget.result ||
        oldWidget.repository != widget.repository ||
        oldWidget.completionTime != widget.completionTime) {
      _initialize();
    }
  }

  void _retake() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => QuizScreen(initialStage: widget.stage)),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Your possibilities'),
      actions: const [ThemeToggle()],
    ),
    body: SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: FutureBuilder<void>(
            future: _loading,
            builder: (context, snapshot) {
              final loaded =
                  snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasError;
              final entry = loaded ? _repository.codeFor(_selectedCode) : null;
              final careers = loaded
                  ? _repository.careersFor(_selectedCode)
                  : const <CareerRecord>[];
              return CustomScrollView(
                key: const PageStorageKey('results-scroll'),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _InterestProfile(profile: _profile),
                          if (_profile.showUncertainty) ...[
                            const SizedBox(height: 20),
                            _UncertaintyBanner(
                              profile: _profile,
                              selectedCode: _selectedCode,
                              onCodeSelected: (code) => setState(() {
                                _selectedCode = code;
                                _expandedCareerId = null;
                              }),
                            ),
                          ],
                          const SizedBox(height: 28),
                          Text(
                            'Why these pathways',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          if (_selectedCode != _profile.hollandCode) ...[
                            Text(
                              'Viewing nearby code $_selectedCode. Your calculated code remains ${_profile.hollandCode}.',
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (!loaded && !snapshot.hasError)
                            const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(
                                child: CircularProgressIndicator(
                                  semanticsLabel:
                                      'Loading local career pathways',
                                ),
                              ),
                            )
                          else if (entry == null || careers.length != 3)
                            _LoadFailure(
                              onRetry: () => setState(
                                () => _loading = _repository.ensureLoaded(),
                              ),
                              onRetake: _retake,
                            )
                          else ...[
                            DatasetText(entry.summary),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InfoPill(
                                'Pathway group AI impact: ${entry.codeAiImpactRating}',
                              ),
                            ),
                            const SizedBox(height: 10),
                            DatasetText(entry.codeAiImpactNote),
                            const SizedBox(height: 8),
                            Text(
                              "Mean AI exposure percentile across these three pathways: ${entry.codeAiImpactAverage.toStringAsFixed(1)}. This group average does not replace each career's own rating.",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Three pathways to ${ResultsWording.explore}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'These are ${ResultsWording.startingPoints}, each ${ResultsWording.worthALook}.',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (entry != null && careers.length == 3)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            key: ValueKey(
                              'pathway-$_selectedCode-${careers[index].id}',
                            ),
                            padding: const EdgeInsets.only(bottom: 20),
                            child: PathwayCard(
                              career: careers[index],
                              profile: _profile,
                              position: index + 1,
                              isExpanded:
                                  _expandedCareerId == careers[index].id,
                              onToggle: () => setState(() {
                                _expandedCareerId =
                                    _expandedCareerId == careers[index].id
                                    ? null
                                    : careers[index].id;
                              }),
                            ),
                          ),
                          childCount: careers.length,
                        ),
                      ),
                    ),
                  if (loaded && _repository.dataset != null)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      sliver: SliverToBoxAdapter(
                        child: _SourcesFooter(
                          meta: _repository.dataset!.meta,
                          onRetake: _retake,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}

class _InterestProfile extends StatelessWidget {
  final ResultsViewModel profile;
  const _InterestProfile({required this.profile});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Your interest profile',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 16),
      for (final letter in RiasecEngine.codes)
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Semantics(
            label:
                '${RiasecEngine.labels[letter]} interest level ${profile.percentScores[letter]} percent',
            child: ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${RiasecEngine.labels[letter]}: ${profile.percentScores[letter]}% interest level',
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: profile.percentScores[letter]! / 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      const SizedBox(height: 8),
      Text('Your Holland code', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerLeft,
        child: Chip(
          key: const ValueKey('calculated-code'),
          label: Text(
            profile.hollandCode,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'These are the kinds of activities you said you would enjoy. They are not a score of your ability.',
      ),
    ],
  );
}

class _UncertaintyBanner extends StatelessWidget {
  final ResultsViewModel profile;
  final String selectedCode;
  final ValueChanged<String> onCodeSelected;
  const _UncertaintyBanner({
    required this.profile,
    required this.selectedCode,
    required this.onCodeSelected,
  });
  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.secondaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'A little room to explore',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (profile.confidenceLabel ==
              ConfidenceLabel.needsMoreExploration) ...[
            const SizedBox(height: 10),
            const Text(
              'Your interests are still forming, and that is normal. Try a few activities and consider retaking the quiz later.',
            ),
            if (profile.manyUntried)
              const Text(
                'Many activities were marked Never tried, so this profile is a starting point.',
              ),
            if (profile.repeatedRatings)
              const Text(
                'Most responses used the same rating, which gives us less information to distinguish your interests.',
              ),
            if (profile.completedQuickly)
              const Text(
                'You moved through the quiz quickly. Taking more time later may help you reflect on each activity.',
              ),
          ] else if (profile.profileShape == ProfileShape.broad) ...[
            const SizedBox(height: 10),
            const Text(
              'Your ratings are spread quite evenly across the six areas. Several directions may be worth exploring.',
            ),
          ],
          if (profile.topTwoAreClose) ...[
            const SizedBox(height: 12),
            Text(profile.tieNotes.first),
            Text(
              '${interestNames(profile.rankedLetters.take(2))} are close; their order could easily flip.',
            ),
          ],
          if (profile.thirdLetterIsUncertain) ...[
            const SizedBox(height: 12),
            Text(
              '${interestNames(profile.rankedLetters.skip(2).take(2))} are close, so the third letter is uncertain.',
            ),
          ],
          for (final letter in profile.exposureGapLetters) ...[
            const SizedBox(height: 12),
            Text(
              'You have not had much chance to try activities in the ${RiasecEngine.labels[letter]} area yet, so treat that score as incomplete rather than low.',
            ),
          ],
          if (profile.alternateCodes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Another close match worth seeing',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final code in [
                  profile.hollandCode,
                  ...profile.alternateCodes,
                ])
                  ChoiceChip(
                    key: ValueKey('code-$code'),
                    label: Text(code),
                    selected: selectedCode == code,
                    onSelected: (selected) {
                      if (selected) onCodeSelected(code);
                    },
                  ),
              ],
            ),
            const Text(
              'Changing this view does not change your answers or scores.',
            ),
          ],
        ],
      ),
    ),
  );
}

class _LoadFailure extends StatelessWidget {
  final VoidCallback onRetry, onRetake;
  const _LoadFailure({required this.onRetry, required this.onRetake});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Your interest profile is ready, but the local pathway information could not be loaded. Your scores have not changed.',
      ),
      const SizedBox(height: 12),
      OutlinedButton(
        onPressed: onRetry,
        child: const Text('Try loading again'),
      ),
      TextButton(onPressed: onRetake, child: const Text('Retake the quiz')),
    ],
  );
}

class _SourcesFooter extends StatelessWidget {
  final DatasetMeta meta;
  final VoidCallback onRetake;
  const _SourcesFooter({required this.meta, required this.onRetake});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DatasetText(meta.disclaimer),
      const SizedBox(height: 16),
      ExpansionTile(
        key: const PageStorageKey('dataset-sources'),
        title: const Text('Where this comes from'),
        tilePadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Source and method descriptions supplied with this dataset.',
          ),
          const SizedBox(height: 12),
          Text('Interest data', style: Theme.of(context).textTheme.titleSmall),
          DatasetText(meta.interestDataSource),
          const SizedBox(height: 12),
          Text(
            'AI impact method',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          DatasetText(meta.aiImpactMethod),
          const SizedBox(height: 12),
          Text('Learning data', style: Theme.of(context).textTheme.titleSmall),
          DatasetText(meta.learningDataSource),
          const SizedBox(height: 12),
          for (final band in meta.ratingBands.entries)
            DatasetText('${band.key}: ${band.value}'),
          const SizedBox(height: 12),
          DatasetText('Dataset version: ${meta.version}'),
          const SizedBox(height: 16),
        ],
      ),
      const SizedBox(height: 16),
      FilledButton(onPressed: onRetake, child: const Text('Retake the quiz')),
    ],
  );
}
