/// Exploration language prevents dataset rankings from becoming promises about
/// ability, suitability, displacement, or success. Banned phrases are test-only
/// guardrails and must never be shown as a list in the results UI.
abstract final class ResultsWording {
  static const explore = 'explore';
  static const worthALook = 'worth a look';
  static const aiFraming = 'how much AI is likely to change this work';
  static const startingPoints = 'starting points';
  static const allowed = [explore, worthALook, aiFraming, startingPoints];
  static const banned = [
    'your ideal career',
    'you should be',
    'best career for you',
    'match score',
    'accuracy',
    'you are suited to',
    'this job will disappear',
    'AI will replace this job',
  ];
}

/// Explicit user-approved display substitution. The bundled source is unchanged;
/// all other dataset wording, ordering, and hedges are preserved verbatim.
String displayDatasetText(String value) => value.replaceAllMapped(
  RegExp(r'\baccuracy\b', caseSensitive: false),
  (match) => match[0]![0] == 'A' ? 'Correctness' : 'correctness',
);
