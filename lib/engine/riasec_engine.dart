class RiasecEngine {
  static const codes = ['R', 'I', 'A', 'S', 'E', 'C'];

  static const labels = {
    'R': 'Realistic',
    'I': 'Investigative',
    'A': 'Artistic',
    'S': 'Social',
    'E': 'Enterprising',
    'C': 'Conventional',
  };

  static const profileSummaries = {
    'RIA':
        'You may enjoy practical projects, investigating how things work, and expressing ideas creatively.',
    'RIS':
        'You may enjoy hands-on problem-solving, research, and helping people apply useful solutions.',
    'RIE':
        'You may enjoy building or fixing things, solving technical problems, and taking initiative.',
    'RIC':
        'You may enjoy practical systems, technical problem-solving, and organized processes.',
    'RAS':
        'You may enjoy making useful things, creative expression, and helping others.',
    'RAE':
        'You may enjoy creating original work, leading projects, and producing visible results.',
    'RAC':
        'You may enjoy hands-on creativity, practical organization, and improving how things work.',
    'RSE':
        'You may enjoy active work, supporting people, and leading toward concrete outcomes.',
    'RSC':
        'You may enjoy practical service, dependable routines, and helping systems run smoothly.',
    'REC':
        'You may enjoy taking action, managing practical work, and organizing resources effectively.',
    'IAS':
        'You may enjoy discovering ideas, creative expression, and understanding people.',
    'IAE':
        'You may enjoy research, innovation, and turning original ideas into opportunities.',
    'IAC':
        'You may enjoy analysis, creativity, and building organized knowledge or systems.',
    'ISE':
        'You may enjoy learning deeply, helping others, and applying knowledge to meaningful goals.',
    'ISC':
        'You may enjoy research, supporting people, and creating accurate, reliable systems.',
    'IEC':
        'You may enjoy analyzing information, making decisions, and organizing complex work.',
    'ASE':
        'You may enjoy creative expression, connecting with people, and influencing positive change.',
    'ASC':
        'You may enjoy creativity, service, and bringing structure to people-centered work.',
    'AEC':
        'You may enjoy creating ideas, leading projects, and organizing them into practical results.',
    'SEC':
        'You may enjoy helping people, taking responsibility, and creating dependable systems.',
  };

  // Sorts RIASEC types by score and uses the fixed RIASEC order for ties.
  static List<String> topCodes(Map<String, int> scores, {int count = 3}) {
    final sortedCodes = [...codes];

    sortedCodes.sort((codeA, codeB) {
      // Higher scores rank first; missing codes behave as zero.
      final scoreComparison = (scores[codeB] ?? 0).compareTo(
        scores[codeA] ?? 0,
      );

      if (scoreComparison != 0) return scoreComparison;

      // Fixed code order makes equal scores produce the same result every time.
      return codes.indexOf(codeA).compareTo(codes.indexOf(codeB));
    });

    // Return only the requested number of strongest interest types.
    return sortedCodes.take(count).toList();
  }

  // Joins the three strongest RIASEC types into the student's Holland code.
  static String hollandCode(Map<String, int> scores) {
    return topCodes(scores).join();
  }

  // Finds a reusable summary using an order-independent version of the profile.
  static String summary(Map<String, int> scores) {
    final profile = hollandCode(scores);

    // Use a fallback sentence if a future combination is not in the summary map.
    return profileSummaries[canonicalProfile(profile)] ??
        'Your interests combine ${topCodes(scores).map((code) => labels[code]).join(', ')}. Explore careers that include these interests.';
  }

  // Sorts profile letters into standard RIASEC order for map lookup.
  static String canonicalProfile(String profile) {
    final letters = profile.split('')
      ..sort(
        (first, second) =>
            codes.indexOf(first).compareTo(codes.indexOf(second)),
      );
    return letters.join();
  }
}
