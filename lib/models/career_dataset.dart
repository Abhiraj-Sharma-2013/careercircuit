// Immutable local dataset records. Source prose is preserved without rewriting.
class CareerDataset {
  final DatasetMeta meta;
  final Map<String, HollandCodeEntry> hollandCodes;
  final Map<String, CareerRecord> careers;

  CareerDataset._(
    this.meta,
    Map<String, HollandCodeEntry> codes,
    Map<String, CareerRecord> records,
  ) : hollandCodes = Map.unmodifiable(codes),
      careers = Map.unmodifiable(records);

  factory CareerDataset.fromJson(Map<String, dynamic> json) => CareerDataset._(
    DatasetMeta.fromJson(_object(json['meta'])),
    _object(json['hollandCodes']).map(
      (key, value) => MapEntry(key, HollandCodeEntry.fromJson(_object(value))),
    ),
    _object(
      json['careers'],
    ).map((key, value) => MapEntry(key, CareerRecord.fromJson(_object(value)))),
  );

  List<String> validate() {
    final errors = <String>[];
    const letters = 'RIASEC';
    final expected = <String>{
      for (final a in letters.split(''))
        for (final b in letters.split(''))
          for (final c in letters.split(''))
            if (a != b && a != c && b != c) '$a$b$c',
    };
    if (hollandCodes.length != 120 ||
        !expected.every(hollandCodes.containsKey)) {
      errors.add('Expected all 120 three-letter Holland code permutations.');
    }
    if (meta.hollandCodeCount != hollandCodes.length ||
        meta.careerCount != careers.length) {
      errors.add('Metadata counts do not match dataset records.');
    }
    for (final entry in hollandCodes.entries) {
      final code = entry.value;
      if (entry.key != code.hollandCode ||
          code.letterNames.length != 3 ||
          code.careerIds.length != 3 ||
          code.careerIds.toSet().length != 3) {
        errors.add('Invalid code entry: ${entry.key}.');
      }
      for (final id in code.careerIds) {
        if (!careers.containsKey(id)) {
          errors.add('${entry.key} references missing career $id.');
        }
      }
      if (!_rating(code.codeAiImpactRating) ||
          !_range(code.codeAiImpactAverage, 0, 100)) {
        errors.add('Invalid cluster impact for ${entry.key}.');
      }
    }
    for (final entry in careers.entries) {
      final c = entry.value;
      if (entry.key != c.id ||
          c.topicsToExplore.length != 3 ||
          c.skillsToLearn.length != 3) {
        errors.add('Invalid identity or learning item count for ${entry.key}.');
      }
      if (c.riasec.length != 6 ||
          !letters.split('').every(c.riasec.containsKey) ||
          c.riasec.values.any((value) => !_range(value, 1, 7))) {
        errors.add('Invalid RIASEC values for ${c.id}.');
      }
      if (!expected.contains(c.topInterests) ||
          c.jobZone < 1 ||
          c.jobZone > 5 ||
          !_range(c.aiImpactPercentile, 0, 100) ||
          !_rating(c.aiImpactRating) ||
          c.toolsToTry.length > 3) {
        errors.add('Invalid career metadata for ${c.id}.');
      }
      for (final item in [...c.topicsToExplore, ...c.skillsToLearn]) {
        if (!_range(item.importance, 1, 5)) {
          errors.add('Invalid learning importance for ${c.id}.');
        }
      }
    }
    return List.unmodifiable(errors);
  }
}

class DatasetMeta {
  final String version,
      interestDataSource,
      aiImpactMethod,
      learningDataSource,
      disclaimer;
  final Map<String, String> ratingBands;
  final int hollandCodeCount, careerCount;
  DatasetMeta._(
    this.version,
    this.interestDataSource,
    this.aiImpactMethod,
    this.learningDataSource,
    this.disclaimer,
    Map<String, String> bands,
    this.hollandCodeCount,
    this.careerCount,
  ) : ratingBands = Map.unmodifiable(bands);
  factory DatasetMeta.fromJson(Map<String, dynamic> j) => DatasetMeta._(
    _text(j, 'version'),
    _text(j, 'interestDataSource'),
    _text(j, 'aiImpactMethod'),
    _text(j, 'learningDataSource'),
    _text(j, 'disclaimer'),
    _object(j['ratingBands']).map((k, v) => MapEntry(k, v as String)),
    j['hollandCodeCount'] as int,
    j['careerCount'] as int,
  );
}

class HollandCodeEntry {
  final String hollandCode, summary, codeAiImpactRating, codeAiImpactNote;
  final List<String> letterNames, careerIds;
  final double codeAiImpactAverage;
  HollandCodeEntry._(
    this.hollandCode,
    List<String> names,
    this.summary,
    List<String> ids,
    this.codeAiImpactAverage,
    this.codeAiImpactRating,
    this.codeAiImpactNote,
  ) : letterNames = List.unmodifiable(names),
      careerIds = List.unmodifiable(ids);
  factory HollandCodeEntry.fromJson(Map<String, dynamic> j) =>
      HollandCodeEntry._(
        _text(j, 'hollandCode'),
        _strings(j, 'letterNames'),
        _text(j, 'summary'),
        _strings(j, 'careerIds'),
        _number(j, 'codeAiImpactAverage'),
        _text(j, 'codeAiImpactRating'),
        _text(j, 'codeAiImpactNote'),
      );
}

class CareerRecord {
  final String id, title, description, topInterests, preparation;
  final Map<String, double> riasec;
  final int jobZone;
  final List<String> sampleTasks, aiLikelyToAssist, aiUnlikelyToReplace;
  final double aiImpactPercentile;
  final String aiImpactRating,
      aiAssistLabel,
      aiImpactSummary,
      durableHumanSkill,
      learningNote;
  final List<LearningItem> topicsToExplore, skillsToLearn;
  final List<ToolItem> toolsToTry;

  CareerRecord._({
    required this.id,
    required this.title,
    required this.description,
    required Map<String, double> interests,
    required this.topInterests,
    required this.jobZone,
    required this.preparation,
    required List<String> tasks,
    required this.aiImpactPercentile,
    required this.aiImpactRating,
    required this.aiAssistLabel,
    required List<String> assisted,
    required List<String> human,
    required this.aiImpactSummary,
    required this.durableHumanSkill,
    required List<LearningItem> topics,
    required List<LearningItem> skills,
    required List<ToolItem> tools,
    required this.learningNote,
  }) : riasec = Map.unmodifiable(interests),
       sampleTasks = List.unmodifiable(tasks),
       aiLikelyToAssist = List.unmodifiable(assisted),
       aiUnlikelyToReplace = List.unmodifiable(human),
       topicsToExplore = List.unmodifiable(topics),
       skillsToLearn = List.unmodifiable(skills),
       toolsToTry = List.unmodifiable(tools);

  factory CareerRecord.fromJson(Map<String, dynamic> j) => CareerRecord._(
    id: _text(j, 'id'),
    title: _text(j, 'title'),
    description: _text(j, 'description'),
    interests: _object(
      j['riasec'],
    ).map((key, value) => MapEntry(key, (value as num).toDouble())),
    topInterests: _text(j, 'topInterests'),
    jobZone: j['jobZone'] as int,
    preparation: _text(j, 'preparation'),
    tasks: _strings(j, 'sampleTasks'),
    aiImpactPercentile: _number(j, 'aiImpactPercentile'),
    aiImpactRating: _text(j, 'aiImpactRating'),
    aiAssistLabel: _text(j, 'aiAssistLabel'),
    assisted: _strings(j, 'aiLikelyToAssist'),
    human: _strings(j, 'aiUnlikelyToReplace'),
    aiImpactSummary: _text(j, 'aiImpactSummary'),
    durableHumanSkill: _text(j, 'durableHumanSkill'),
    topics: (j['topicsToExplore'] as List)
        .map((v) => LearningItem.fromJson(_object(v)))
        .toList(),
    skills: (j['skillsToLearn'] as List)
        .map((v) => LearningItem.fromJson(_object(v)))
        .toList(),
    tools: (j['toolsToTry'] as List)
        .map((v) => ToolItem.fromJson(_object(v)))
        .toList(),
    learningNote: _text(j, 'learningNote'),
  );
}

class LearningItem {
  final String name, onetElement, howToStart;
  final double importance;
  const LearningItem._(
    this.name,
    this.onetElement,
    this.importance,
    this.howToStart,
  );
  factory LearningItem.fromJson(Map<String, dynamic> j) => LearningItem._(
    _text(j, 'name'),
    _text(j, 'onetElement'),
    _number(j, 'importance'),
    _text(j, 'howToStart'),
  );
}

class ToolItem {
  final String category, example;
  const ToolItem._(this.category, this.example);
  factory ToolItem.fromJson(Map<String, dynamic> j) =>
      ToolItem._(_text(j, 'category'), _text(j, 'example'));
}

Map<String, dynamic> _object(Object? value) =>
    (value as Map).cast<String, dynamic>();
String _text(Map<String, dynamic> json, String key) {
  final text = json[key] as String;
  if (text.trim().isEmpty) throw FormatException('Missing text: $key');
  return text;
}

List<String> _strings(Map<String, dynamic> json, String key) =>
    (json[key] as List).cast<String>();
double _number(Map<String, dynamic> json, String key) =>
    (json[key] as num).toDouble();
bool _range(double value, double min, double max) =>
    value.isFinite && value >= min && value <= max;
bool _rating(String value) => const ['High', 'Medium', 'Low'].contains(value);
