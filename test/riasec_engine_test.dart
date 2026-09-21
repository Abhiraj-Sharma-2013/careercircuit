import 'package:flutter_test/flutter_test.dart';
import 'package:careercircuit/engine/riasec_engine.dart';

void main() {
  test('ranks RIASEC scores deterministically', () {
    expect(
      RiasecEngine.hollandCode({
        'R': 5,
        'I': 4,
        'A': 3,
        'S': 2,
        'E': 1,
        'C': 0,
      }),
      'RIA',
    );
  });

  test('uses RIASEC order to break ties', () {
    expect(RiasecEngine.hollandCode({'R': 1, 'I': 1, 'A': 1}), 'RIA');
  });
}
