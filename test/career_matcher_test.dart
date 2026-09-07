import 'package:flutter_test/flutter_test.dart';
import 'package:careercircuit/data/career_data.dart';
import 'package:careercircuit/engine/career_matcher.dart';

void main() {
  test('calculates a career score from matching RIASEC codes', () {
    final softwareEngineer = careerData.first;

    expect(
      CareerMatcher.calculateCareerMatchScore(softwareEngineer, {
        'R': 6,
        'I': 4,
        'A': 0,
        'S': 0,
        'E': 0,
        'C': 1,
      }),
      11,
    );
  });

  test('returns the same ranking regardless of input order', () {
    const scores = {'R': 3, 'I': 2, 'A': 1, 'S': 0, 'E': 0, 'C': 0};
    final forward = CareerMatcher.getTopCareerMatches(careerData, scores);
    final reversed = CareerMatcher.getTopCareerMatches(
      careerData.reversed.toList(),
      scores,
    );

    expect(
      forward.map((career) => career.id).toList(),
      reversed.map((career) => career.id).toList(),
    );
  });
}
