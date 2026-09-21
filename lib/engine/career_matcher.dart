import '../models/career.dart';

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

    sortedCareers.sort((careerA, careerB) {
      // The highest total RIASEC match is always the primary ranking rule.
      final scoreComparison = calculateCareerMatchScore(
        careerB,
        studentScores,
      ).compareTo(calculateCareerMatchScore(careerA, studentScores));

      if (scoreComparison != 0) return scoreComparison;

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
}
