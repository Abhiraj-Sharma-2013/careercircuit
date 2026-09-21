import 'package:flutter_test/flutter_test.dart';
import 'package:careercircuit/presentation/career_fit.dart';
import 'package:careercircuit/repositories/career_data_repository.dart';
import 'package:careercircuit/view_models/results_view_model.dart';
import 'results_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => CareerDataRepository.instance.ensureLoaded());
  test('normalizes the two scales before finding shared top interests', () {
    final career = CareerDataRepository.instance.careerById('17-2021.00')!;
    final fit = CareerFit.forProfile(
      ResultsViewModel.fromAssessment(resultForCode('RIA')),
      career,
    );
    expect(fit.normalizedStudent['R'], 1);
    expect(fit.normalizedCareer['R'], closeTo((6.65 - 1) / 6, 0.0001));
    expect(fit.overlap, ['R', 'I']);
    expect(fit.sameOrderedCode, isFalse);
    expect(fit.explanation, contains('Realistic and Investigative'));
    expect(fit.explanation, contains('Conventional'));
  });
  test('one shared letter makes the imperfect fit explicit', () {
    final career = CareerDataRepository.instance.careerById('17-2021.00')!;
    final fit = CareerFit.forProfile(
      ResultsViewModel.fromAssessment(resultForCode('SAI')),
      career,
    );
    expect(fit.overlap, ['I']);
    expect(fit.explanation, contains('Your Investigative interest'));
    expect(
      fit.explanation,
      contains('leans more toward Realistic and Conventional'),
    );
  });
  test('no overlap never invents a shared interest', () {
    final career = CareerDataRepository.instance.careerById('17-2021.00')!;
    final fit = CareerFit.forProfile(
      ResultsViewModel.fromAssessment(resultForCode('SAE')),
      career,
    );
    expect(fit.overlap, isEmpty);
    expect(
      fit.explanation,
      contains('differ from your highest reported interests'),
    );
  });
}
