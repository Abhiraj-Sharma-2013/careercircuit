import 'package:flutter/material.dart';

ThemeData careerTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF5850D9),
        brightness: brightness,
      ).copyWith(
        secondary: dark ? const Color(0xFF70DCC6) : const Color(0xFF086B5C),
        onSecondary: dark ? const Color(0xFF00382F) : Colors.white,
        secondaryContainer: dark
            ? const Color(0xFF173E43)
            : const Color(0xFFD3F3EE),
        onSecondaryContainer: dark
            ? const Color(0xFFADF2E1)
            : const Color(0xFF073B34),
        surfaceContainerLow: dark ? const Color(0xFF182136) : Colors.white,
        surface: dark ? const Color(0xFF141B2D) : const Color(0xFFFFFFFF),
      );
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  return base.copyWith(
    scaffoldBackgroundColor: dark
        ? const Color(0xFF0D1322)
        : const Color(0xFFF4F6FC),
    textTheme: base.textTheme.copyWith(
      headlineLarge: base.textTheme.headlineLarge!.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        height: 1.12,
      ),
      headlineSmall: base.textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleMedium: base.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: base.textTheme.bodyMedium!.copyWith(height: 1.4),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? const Color(0xFF0D1322) : const Color(0xFFF4F6FC),
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: base.textTheme.titleMedium!.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: base.textTheme.labelLarge!.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: scheme.secondary,
      linearTrackColor: scheme.surfaceContainerHighest,
      linearMinHeight: 5,
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

class ThemePreference extends InheritedNotifier<ValueNotifier<ThemeMode>> {
  const ThemePreference({
    super.key,
    required super.notifier,
    required super.child,
  });
  static ValueNotifier<ThemeMode>? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemePreference>()?.notifier;
}
