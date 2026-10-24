import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:careercircuit/presentation/results_wording.dart';

void main() {
  test('approved display substitution leaves source untouched', () {
    const source = 'Accuracy matters; check accuracy.';
    expect(
      displayDatasetText(source),
      'Correctness matters; check correctness.',
    );
    expect(source, 'Accuracy matters; check accuracy.');
  });
  test('all displayed dataset strings satisfy wording guardrails', () {
    final source = jsonDecode(
      File('assets/career_dataset.json').readAsStringSync(),
    );
    void visit(dynamic value) {
      if (value is String) {
        final displayed = displayDatasetText(value).toLowerCase();
        for (final phrase in ResultsWording.banned) {
          expect(displayed, isNot(contains(phrase.toLowerCase())));
        }
      } else if (value is List) {
        value.forEach(visit);
      } else if (value is Map) {
        value.values.forEach(visit);
      }
    }

    visit(source);
  });
}
