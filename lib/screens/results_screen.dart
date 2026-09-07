import 'package:flutter/material.dart';
import '../data/career_data.dart';
import '../engine/career_matcher.dart';
import '../engine/riasec_engine.dart';
import '../models/career.dart';
import '../models/student_intake.dart';
import 'career_detail_screen.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, int> studentScores;
  final StudentIntake studentIntake;

  const ResultsScreen({
    super.key,
    required this.studentScores,
    required this.studentIntake,
  });

  void _openCareerDetail(BuildContext context, Career career) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CareerDetailScreen(career: career),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Career> matchedCareers = CareerMatcher.getTopCareerMatches(
      careerData,
      studentScores,
    );

    final int confidenceScore = CareerMatcher.calculateConfidenceScore(
      matchedCareers,
      studentScores,
    );
    final String hollandCode = RiasecEngine.hollandCode(studentScores);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Career Matches')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'For exploration only: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'AI career suggestions may be incomplete or inaccurate. '
                      'Do not rely on them alone when making important education '
                      'or career decisions.',
                ),
              ],
            ),
            style: TextStyle(fontSize: 14, color: Color(0xFF123B63)),
          ),

          const SizedBox(height: 20),

          const Text(
            'Your Top Career Matches',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            'Confidence Score: $confidenceScore%',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF123B63),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            studentIntake.grade == null
                ? 'Grade: Not provided'
                : 'Grade: ${studentIntake.grade}th',
          ),
          if (studentIntake.likes.isNotEmpty)
            Text('Strong likes: ${studentIntake.likes}'),
          if (studentIntake.dislikes.isNotEmpty)
            Text('Strong dislikes: ${studentIntake.dislikes}'),

          const SizedBox(height: 16),

          Text(
            'Your RIASEC profile: $hollandCode',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123B63),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            RiasecEngine.summary(studentScores),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),

          const Text(
            'These careers were chosen by comparing your RIASEC interests with career profiles.',
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 24),

          for (int index = 0; index < matchedCareers.length; index++)
            _CareerResultCard(
              rank: index + 1,
              career: matchedCareers[index],
              studentScores: studentScores,
              onTap: () => _openCareerDetail(context, matchedCareers[index]),
            ),

          const SizedBox(height: 24),

          const Text(
            'Your RIASEC Scores',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          for (final entry in studentScores.entries)
            Text(
              '${RiasecEngine.labels[entry.key]} (${entry.key}): ${entry.value}',
              style: const TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }
}

class _CareerResultCard extends StatelessWidget {
  final int rank;
  final Career career;
  final Map<String, int> studentScores;
  final VoidCallback onTap;

  const _CareerResultCard({
    required this.rank,
    required this.career,
    required this.studentScores,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int matchScore = CareerMatcher.calculateCareerMatchScore(
      career,
      studentScores,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(child: Text('$rank')),
        title: Text(
          career.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Match Score: $matchScore • AI Risk: ${career.aiRiskLevel}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
