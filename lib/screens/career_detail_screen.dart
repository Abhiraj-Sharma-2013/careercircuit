import 'package:flutter/material.dart';
import '../models/career.dart';

class CareerDetailScreen extends StatelessWidget {
  final Career career;

  const CareerDetailScreen({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(career.title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            career.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            career.category,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.indigo,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 24),

          _Section(
            title: 'What this career does',
            child: Text(
              career.longDescription,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          _Section(
            title: 'Helpful school subjects',
            child: _BulletList(items: career.schoolSubjects),
          ),

          _Section(
            title: 'Skills to learn',
            child: _BulletList(items: career.skills),
          ),

          _Section(
            title: 'Starter project',
            child: Text(
              career.starterProject,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          _Section(
            title: 'AI Impact',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Risk Level: ${career.aiRiskLevel}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  career.aiImpactSummary,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          _Section(
            title: 'Future-Proof Score',
            child: Text(
              '${career.futureProofScore}/100',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),

          _Section(
            title: 'Alternative Career',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  career.alternativeCareer,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  career.alternativeReason,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${career.title} saved to favorites!')),
              );
            },
            icon: const Icon(Icons.favorite),
            label: const Text('Save Favorite'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;

  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('• $item', style: const TextStyle(fontSize: 16)),
          ),
      ],
    );
  }
}
