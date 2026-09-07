import '../models/career.dart';
import 'riasec_engine.dart';

class CareerMatcher {
  // Adds the student's points for every RIASEC code in a career profile.
  static int calculateCareerMatchScore(
    Career career,
    Map<String, int> studentScores,
  ) {
    int totalScore = 0;

    // A career can have multiple RIASEC codes, so each matching code contributes
    // its corresponding student score to the total.
    for (final code in career.interestTags) {
      totalScore += studentScores[code] ?? 0;
    }

    return totalScore;
  }

  static List<Career> getTopCareerMatches(
    List<Career> careers,
    Map<String, int> studentScores,
  ) {
    // Copy the input so sorting does not mutate the shared career catalogue.
    final List<Career> sortedCareers = List.from(careers);
    final List<String> rankedCodes = RiasecEngine.topCodes(studentScores);

    sortedCareers.sort((careerA, careerB) {
      // The highest total RIASEC match is always the primary ranking rule.
      final scoreComparison = calculateCareerMatchScore(
        careerB,
        studentScores,
      ).compareTo(calculateCareerMatchScore(careerA, studentScores));

      if (scoreComparison != 0) return scoreComparison;

      // If totals tie, prefer careers matching the student's strongest codes.
      final priorityComparison = _priorityScore(
        careerB,
        rankedCodes,
      ).compareTo(_priorityScore(careerA, rankedCodes));

      if (priorityComparison != 0) return priorityComparison;

      // Title and ID provide stable final tie-breakers independent of input order.
      final titleComparison = careerA.title.toLowerCase().compareTo(
        careerB.title.toLowerCase(),
      );

      return titleComparison != 0
          ? titleComparison
          : careerA.id.compareTo(careerB.id);
    });

    // Keep the result list focused on the five strongest deterministic matches.
    return sortedCareers.take(5).toList();
  }

  // Gives more weight to a career matching the student's first, second, or third code.
  static int _priorityScore(Career career, List<String> rankedCodes) {
    int priorityScore = 0;

    for (int index = 0; index < rankedCodes.length; index++) {
      if (career.interestTags.contains(rankedCodes[index])) {
        priorityScore += 3 - index;
      }
    }

    return priorityScore;
  }

  // Converts the gap between the top two matches into a bounded confidence percentage.
  static int calculateConfidenceScore(
    List<Career> matchedCareers,
    Map<String, int> studentScores,
  ) {
    // A single available match has no competitor, so it receives the maximum score.
    if (matchedCareers.length < 2) {
      return 100;
    }

    final topScore = calculateCareerMatchScore(
      matchedCareers[0],
      studentScores,
    );

    final secondScore = calculateCareerMatchScore(
      matchedCareers[1],
      studentScores,
    );

    // No matching RIASEC points means the result has no meaningful confidence.
    if (topScore == 0) return 0;

    final difference = topScore - secondScore;

    // A larger lead increases confidence, while clamp keeps the value readable.
    return (70 + (difference * 5)).clamp(60, 95);
  }
}
