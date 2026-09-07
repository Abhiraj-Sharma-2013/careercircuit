import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> favoriteCareers = [
      'Cybersecurity Analyst',
      'AI Solutions Engineer',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Careers')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Saved Careers',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          for (final career in favoriteCareers)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Color(0xFF123B63)),
                title: Text(career),
                subtitle: const Text('Saved career path'),
              ),
            ),
        ],
      ),
    );
  }
}
