import '../engine/riasec_engine.dart';
import '../models/assessment_result.dart';

enum ProfileShape { broad, differentiated }

enum ConfidenceLabel { clear, balanced, needsMoreExploration }

/// Pure interpretation of local quiz responses. No asset or repository access.
class ResultsViewModel {
  final Map<String, int> rawScores, percentScores;
  final List<String> rankedLetters,
      tieNotes,
      alternateCodes,
      exposureGapLetters;
  final String hollandCode;
  final bool thirdLetterIsUncertain, topTwoAreClose;
  final ProfileShape profileShape;
  final ConfidenceLabel confidenceLabel;
  final bool manyUntried, repeatedRatings, completedQuickly;

  ResultsViewModel._({
    required Map<String, int> raw,
    required Map<String, int> percent,
    required List<String> ranked,
    required List<String> notes,
    required List<String> alternates,
    required List<String> exposure,
    required this.hollandCode,
    required this.thirdLetterIsUncertain,
    required this.topTwoAreClose,
    required this.profileShape,
    required this.confidenceLabel,
    required this.manyUntried,
    required this.repeatedRatings,
    required this.completedQuickly,
  }) : rawScores = Map.unmodifiable(raw),
       percentScores = Map.unmodifiable(percent),
       rankedLetters = List.unmodifiable(ranked),
       tieNotes = List.unmodifiable(notes),
       alternateCodes = List.unmodifiable(alternates),
       exposureGapLetters = List.unmodifiable(exposure);

  factory ResultsViewModel.fromAssessment(
    AssessmentResult result, {
    Duration? completionTime,
  }) {
    final raw = result.scores;
    if (raw.length != 6 ||
        RiasecEngine.codes.any(
          (c) => !raw.containsKey(c) || raw[c]! < 5 || raw[c]! > 25,
        )) {
      throw ArgumentError(
        'Results require six completed category totals from 5 to 25.',
      );
    }
    if (completionTime != null && completionTime.isNegative) {
      throw ArgumentError('Invalid completion time.');
    }
    final ranked = RiasecEngine.topCodes(raw, count: 6);
    final closeTop = raw[ranked[0]]! - raw[ranked[1]]! <= 2;
    final closeThird = raw[ranked[2]]! - raw[ranked[3]]! <= 1;
    final broad = raw[ranked.first]! - raw[ranked.last]! <= 3;
    final code = ranked.take(3).join();
    final alternates = <String>{
      if (closeThird) '${ranked[0]}${ranked[1]}${ranked[3]}',
      if (closeTop) '${ranked[1]}${ranked[0]}${ranked[2]}',
    }..remove(code);
    final counts = <int, int>{};
    var untried = 0;
    for (final response in result.responses.values) {
      counts.update(response.rating, (count) => count + 1, ifAbsent: () => 1);
      if (response.exposureGap) untried++;
    }
    final total = result.responses.length;
    final manyUntried = total > 0 && untried / total > 0.4;
    final repeated =
        total > 0 && counts.values.any((count) => count / total >= 0.8);
    // Missing historical timing is unknown, not a zero-second completion.
    final quick =
        completionTime != null && completionTime < const Duration(seconds: 90);
    return ResultsViewModel._(
      raw: raw,
      percent: {
        for (final c in RiasecEngine.codes) c: (raw[c]! / 25 * 100).round(),
      },
      ranked: ranked,
      hollandCode: code,
      topTwoAreClose: closeTop,
      thirdLetterIsUncertain: closeThird,
      notes: [
        if (closeTop) 'You have two nearly equally strong interest areas.',
        if (closeThird) 'Your third and fourth interest areas are close.',
      ],
      alternates: alternates.toList(),
      exposure: [
        for (final c in RiasecEngine.codes)
          if ((result.exposureGaps[c] ?? 0) >= 2) c,
      ],
      profileShape: broad ? ProfileShape.broad : ProfileShape.differentiated,
      confidenceLabel: manyUntried || repeated || quick
          ? ConfidenceLabel.needsMoreExploration
          : broad
          ? ConfidenceLabel.balanced
          : ConfidenceLabel.clear,
      manyUntried: manyUntried,
      repeatedRatings: repeated,
      completedQuickly: quick,
    );
  }

  bool get showUncertainty =>
      confidenceLabel != ConfidenceLabel.clear ||
      tieNotes.isNotEmpty ||
      exposureGapLetters.isNotEmpty;
}
