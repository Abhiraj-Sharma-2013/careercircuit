import '../models/career.dart';

class CareerMatcher {
  static int calculateCareerMatchScore(
    Career career,
    Map<String, int> studentScores,
  ) {
    int totalScore = 0;

    // Compare the student's scores with this career's interest tags.
    for (final tag in career.interestTags) {
      totalScore += studentScores[tag] ?? 0;
    }

    return totalScore;
  }

  static List<Career> getTopCareerMatches(
    List<Career> careers,
    Map<String, int> studentScores,
  ) {
    final List<Career> sortedCareers = List.from(careers);

    sortedCareers.sort((careerA, careerB) {
      final scoreA = calculateCareerMatchScore(careerA, studentScores);
      final scoreB = calculateCareerMatchScore(careerB, studentScores);

      // Higher score should come first.
      return scoreB.compareTo(scoreA);
    });

    // Return top 5 careers.
    return sortedCareers.take(5).toList();
  }

  static int calculateConfidenceScore(
    List<Career> matchedCareers,
    Map<String, int> studentScores,
  ) {
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

    if (topScore == 0) {
      return 0;
    }

    final difference = topScore - secondScore;

    // Simple beginner-friendly confidence formula.
    // Bigger difference means more confidence.
    int confidence = 70 + (difference * 5);

    if (confidence > 95) {
      confidence = 95;
    }

    if (confidence < 60) {
      confidence = 60;
    }

    return confidence;
  }
}
