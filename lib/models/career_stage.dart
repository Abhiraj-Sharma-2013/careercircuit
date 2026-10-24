enum CareerStage {
  middleSchool('Middle school', 'Discover what sparks your curiosity'),
  highSchool('High school', 'Explore interests and possible next steps'),
  college('College student', 'Connect your interests with future paths'),
  graduate('Graduate', 'Explore directions after your studies'),
  professional(
    'Working professional',
    'Discover possibilities for a career change',
  );

  final String label;
  final String description;
  const CareerStage(this.label, this.description);
}
