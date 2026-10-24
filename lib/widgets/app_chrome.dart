import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});
  @override
  Widget build(BuildContext context) {
    final preference = ThemePreference.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Tooltip(
        message: dark ? 'Switch to light theme' : 'Switch to dark theme',
        child: Switch(
          key: const ValueKey('theme-toggle'),
          value: dark,
          thumbIcon: WidgetStatePropertyAll(
            Icon(
              dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 18,
            ),
          ),
          onChanged: preference == null
              ? null
              : (value) =>
                    preference.value = value ? ThemeMode.dark : ThemeMode.light,
        ),
      ),
    );
  }
}

class JourneyBanner extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  const JourneyBanner({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.icon = Icons.explore_rounded,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.secondaryContainer],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.onPrimaryContainer, size: 32),
          const SizedBox(height: 16),
          Text(
            eyebrow.toUpperCase(),
            style: TextStyle(
              color: scheme.onPrimaryContainer,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(color: scheme.onPrimaryContainer, height: 1.5),
          ),
        ],
      ),
    );
  }
}
