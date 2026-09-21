import 'package:flutter/material.dart';
import '../widgets/app_chrome.dart';
import 'quiz_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('CareerCircuit'),
      actions: const [ThemeToggle()],
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const JourneyBanner(
                eyebrow: 'Curiosity starts here',
                title: 'Find your next possibility.',
                subtitle:
                    'From your first career ideas to a fresh direction, discover activities you enjoy and paths worth exploring.',
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(
                    avatar: Icon(Icons.tune_rounded, size: 18),
                    label: Text('30 activities'),
                  ),
                  Chip(
                    avatar: Icon(Icons.schedule_rounded, size: 18),
                    label: Text('5 to 8 minutes'),
                  ),
                  Chip(
                    avatar: Icon(Icons.lock_outline_rounded, size: 18),
                    label: Text('Private by design'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Your interests. Your possibilities.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'CareerCircuit suggests career options based on your interests. Explore these ideas to learn what you might enjoy.',
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Get Started'),
              ),
              const SizedBox(height: 12),
              Text(
                'No account. No uploads. Explore at your own pace.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
