class Career {
  final String id;
  final String title;
  final String category;
  final String shortDescription;
  final String longDescription;
  final List<String> schoolSubjects;
  final List<String> skills;
  final String starterProject;
  final List<String> interestTags;
  final String aiRiskLevel;
  final int futureProofScore;
  final String aiImpactSummary;
  final String alternativeCareer;
  final String alternativeReason;

  const Career({
    required this.id,
    required this.title,
    required this.category,
    required this.shortDescription,
    required this.longDescription,
    required this.schoolSubjects,
    required this.skills,
    required this.starterProject,
    required this.interestTags,
    required this.aiRiskLevel,
    required this.futureProofScore,
    required this.aiImpactSummary,
    required this.alternativeCareer,
    required this.alternativeReason,
  });
}
