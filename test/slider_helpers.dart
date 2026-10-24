import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> chooseSliderPosition(
  WidgetTester tester,
  Finder finder,
  int position,
) async {
  await tester.ensureVisible(finder);
  final slider = tester.widget<Slider>(finder);
  final rect = tester.getRect(finder);
  final fraction = (position - slider.min) / (slider.max - slider.min);
  // Tap the five visible stops; Material sliders reserve 24px at each edge.
  await tester.tapAt(
    Offset(rect.left + 24 + (rect.width - 48) * fraction, rect.center.dy),
  );
  await tester.pumpAndSettle();
  expect(tester.widget<Slider>(finder).value, position.toDouble());
}
