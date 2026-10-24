import '../engine/riasec_engine.dart';
import '../models/career_dataset.dart';
import '../view_models/results_view_model.dart';

class CareerFit {
  final Map<String, double> normalizedStudent, normalizedCareer;
  final List<String> overlap, careerTopLetters;
  final String explanation;
  final bool sameOrderedCode;
  CareerFit._(
    Map<String, double> student,
    Map<String, double> career,
    List<String> shared,
    List<String> top,
    this.explanation,
    this.sameOrderedCode,
  ) : normalizedStudent = Map.unmodifiable(student),
      normalizedCareer = Map.unmodifiable(career),
      overlap = List.unmodifiable(shared),
      careerTopLetters = List.unmodifiable(top);

  factory CareerFit.forProfile(ResultsViewModel profile, CareerRecord career) {
    final student = {
      for (final c in RiasecEngine.codes) c: profile.percentScores[c]! / 100.0,
    };
    final occupation = {
      for (final c in RiasecEngine.codes) c: (career.riasec[c]! - 1) / 6.0,
    };
    List<String> rank(Map<String, double> values) =>
        [...RiasecEngine.codes]..sort((a, b) {
          final comparison = values[b]!.compareTo(values[a]!);
          return comparison != 0
              ? comparison
              : RiasecEngine.codes
                    .indexOf(a)
                    .compareTo(RiasecEngine.codes.indexOf(b));
        });
    final studentTop = rank(student).take(3).toList();
    final careerTop = rank(occupation).take(3).toList();
    final overlap = studentTop.where(careerTop.contains).toList();
    final other = careerTop
        .where((letter) => !studentTop.contains(letter))
        .toList();
    final String explanation;
    if (overlap.isEmpty) {
      explanation =
          'This path emphasizes ${interestNames(careerTop)}, which differ from your highest reported interests. It may still be worth exploring.';
    } else if (overlap.length == 1) {
      explanation =
          'Your ${interestNames(overlap)} interest lines up with this path; it leans more toward ${interestNames(other)} than your profile does.';
    } else {
      explanation =
          'Your strong ${interestNames(overlap)} interests line up with this path, which O*NET also rates highest on ${interestNames(careerTop)}.';
    }
    return CareerFit._(
      student,
      occupation,
      overlap,
      careerTop,
      explanation,
      profile.hollandCode == career.topInterests,
    );
  }
}

String interestNames(Iterable<String> letters) {
  final names = letters.map((letter) => RiasecEngine.labels[letter]!).toList();
  if (names.length < 2) return names.join();
  if (names.length == 2) return names.join(' and ');
  return '${names.take(names.length - 1).join(', ')}, and ${names.last}';
}
