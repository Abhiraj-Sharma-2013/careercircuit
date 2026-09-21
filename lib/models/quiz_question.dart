class QuizQuestion {
  final String id;
  final String riasecType;
  final String text;

  const QuizQuestion({
    required this.id,
    required this.riasecType,
    required this.text,
  });

  static const prompt = 'How much would you enjoy doing this?';
  static const responseLabels = [
    'Not at all',
    'Probably not',
    'Not sure yet',
    'Probably yes',
    'Very much',
  ];
  static const neverTriedLabel = 'Never tried';
  static const sliderLabels = [neverTriedLabel, ...responseLabels];

  Map<String, Object> toJson() => {
    'id': id,
    'riasecType': riasecType,
    'text': text,
    'scaleMin': 1,
    'scaleMax': 5,
    'hasNotTriedOption': true,
    'exposureGapNeutralScore': 3,
  };
}

/// Kept in memory on this device for the current assessment session only.
class QuizResponse {
  final int rating;
  final bool exposureGap;

  QuizResponse.rated(this.rating) : exposureGap = false {
    if (rating < 1 || rating > 5) {
      throw RangeError.range(rating, 1, 5, 'rating');
    }
  }

  const QuizResponse.notTried() : rating = 3, exposureGap = true;

  // Position zero is an exposure choice, never a zero interest rating.
  factory QuizResponse.fromSliderPosition(int position) => position == 0
      ? const QuizResponse.notTried()
      : QuizResponse.rated(position);

  int get sliderPosition => exposureGap ? 0 : rating;
}
