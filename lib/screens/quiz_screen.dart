import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../data/stage_question_text.dart';
import '../models/career_stage.dart';
import '../widgets/app_chrome.dart';
import '../engine/riasec_engine.dart';
import '../models/quiz_question.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  final CareerStage? initialStage;
  const QuizScreen({super.key, this.initialStage});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late CareerStage? _stage = widget.initialStage;
  int _page = 0;
  bool _started = false;
  bool _finishing = false;
  final _responses = <String, QuizResponse>{};
  final _scrollController = ScrollController();

  List<QuizQuestion> get _questions => quizQuestions
      .where((q) => q.riasecType == quizSections.keys.elementAt(_page))
      .toList();
  bool get _pageComplete =>
      _questions.every((q) => _responses.containsKey(q.id));

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _resetScroll() {
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  void _back() {
    setState(() {
      if (_page > 0) {
        _page--;
      } else {
        _started = false;
      }
    });
    _resetScroll();
  }

  void _next() {
    if (_finishing || !_pageComplete) return;
    if (_page == quizSections.length - 1) {
      final result = RiasecEngine.score(quizQuestions, _responses);
      setState(() => _finishing = true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(result: result, stage: _stage!),
        ),
      );
    } else {
      setState(() => _page++);
      _resetScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_started,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Explore your interests',
            overflow: TextOverflow.ellipsis,
          ),
          actions: const [ThemeToggle()],
          leading: BackButton(
            onPressed: _started ? _back : () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: _started
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quizSections.values.elementAt(_page),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                                letterSpacing: -0.4,
                              ),
                              semanticsLabel:
                                  '${quizSections.values.elementAt(_page)} section',
                            ),
                            Text(
                              'Section ${_page + 1} of ${quizSections.length}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _responses.length / quizQuestions.length,
                              semanticsLabel:
                                  '${_responses.length} of 30 activities answered',
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              QuizQuestion.prompt,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Text(
                                  'Gray: never tried. Red to green: how much you would enjoy it.',
                                ),
                              ),
                              for (final question in _questions)
                                _ActivityCard(
                                  key: ValueKey(question.id),
                                  question: question,
                                  text: questionTextForStage(question, _stage!),
                                  response: _responses[question.id],
                                  onChanged: (response) => setState(() {
                                    _responses[question.id] = response;
                                  }),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 6),
                              FilledButton(
                                key: const ValueKey('next'),
                                onPressed: !_pageComplete || _finishing
                                    ? null
                                    : _next,
                                child: Text(
                                  _page == quizSections.length - 1
                                      ? 'Explore results'
                                      : 'Next section',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const JourneyBanner(
                          eyebrow: 'Your starting point',
                          title: 'Where are you in your journey?',
                          subtitle:
                              'Choose your current stage. We will use examples and wording that feel relevant to you.',
                          icon: Icons.route_rounded,
                        ),
                        const SizedBox(height: 20),
                        for (final stage in CareerStage.values)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Semantics(
                              selected: _stage == stage,
                              child: Card(
                                color: _stage == stage
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer
                                    : null,
                                child: ListTile(
                                  key: ValueKey('stage-${stage.name}'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  leading: Icon(
                                    _stage == stage
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                  ),
                                  title: Text(
                                    stage.label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(stage.description),
                                  onTap: () => setState(() {
                                    if (_stage != stage) {
                                      _stage = stage;
                                      _responses.clear();
                                      _page = 0;
                                    }
                                  }),
                                ),
                              ),
                            ),
                          ),
                        const Text(
                          'Your stage only adjusts the wording. Choose what you would enjoy, whether or not you have tried it. Changing your stage starts a fresh quiz.',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Six sections. About 5 to 8 minutes. No right or wrong answers.',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Picture yourself trying each activity. Move the slider to show how much you would enjoy it. You do not need experience.',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Your answers stay on this device during this session. They are not uploaded or saved after you close the app. Your stage selection stays here too.',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'CareerCircuit suggests career options based on your interests. Explore these ideas to learn what you might enjoy.',
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _stage == null
                              ? null
                              : () {
                                  setState(() => _started = true);
                                  _resetScroll();
                                },
                          child: Text(
                            _responses.isEmpty ? 'Start quiz' : 'Resume quiz',
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final QuizQuestion question;
  final String text;
  final QuizResponse? response;
  final ValueChanged<QuizResponse> onChanged;

  const _ActivityCard({
    super.key,
    required this.question,
    required this.text,
    required this.response,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isUntried = response?.exposureGap ?? false;
    final rated = response != null && !isUntried;
    final value = (response?.sliderPosition ?? 0).toDouble();
    final status = isUntried
        ? QuizQuestion.neverTriedLabel
        : rated
        ? QuizQuestion.responseLabels[response!.rating - 1]
        : 'Choose your answer';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            key: ValueKey('highlight-${question.id}'),
            color: colors.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: rated || isUntried
                    ? colors.primary
                    : colors.outlineVariant,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Semantics(
            label: '$text ${QuizQuestion.prompt}',
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                trackShape: const _InterestTrack(),
                thumbColor: rated ? colors.primary : colors.outline,
                activeTickMarkColor: Colors.white,
                inactiveTickMarkColor: Colors.white,
                showValueIndicator: ShowValueIndicator.never,
              ),
              child: Slider(
                key: ValueKey('slider-${question.id}'),
                value: value,
                min: 0,
                max: 5,
                divisions: 5,
                semanticFormatterCallback: (v) => response == null
                    ? 'Choose your answer'
                    : QuizQuestion.sliderLabels[v.round()],
                onChangeStart: (v) =>
                    onChanged(QuizResponse.fromSliderPosition(v.round())),
                onChanged: (v) =>
                    onChanged(QuizResponse.fromSliderPosition(v.round())),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 12,
                height: 1.2,
                color: colors.onSurfaceVariant,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: Text(QuizQuestion.neverTriedLabel)),
                  Expanded(
                    flex: 2,
                    child: Text(
                      status,
                      key: ValueKey('status-${question.id}'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text('Very much', textAlign: TextAlign.right),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gray exposure stop, followed by the red-to-green enjoyment scale.
class _InterestTrack extends RoundedRectSliderTrackShape {
  const _InterestTrack();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final gradient = LinearGradient(
      begin: textDirection == TextDirection.ltr
          ? Alignment.centerLeft
          : Alignment.centerRight,
      end: textDirection == TextDirection.ltr
          ? Alignment.centerRight
          : Alignment.centerLeft,
      // The gray stop is separate from the five enjoyment ratings.
      stops: const [0, 0.08, 0.12, 0.2, 0.4, 0.6, 0.8, 1],
      colors: const [
        Color(0xFF87919F),
        Color(0xFF87919F),
        Color(0xFF991B1B),
        Color(0xFF991B1B),
        Color(0xFFCA5C35),
        Color(0xFFE0BB60),
        Color(0xFF6A9953),
        Color(0xFF166534),
      ],
    );
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()..shader = gradient.createShader(rect),
    );
  }
}
