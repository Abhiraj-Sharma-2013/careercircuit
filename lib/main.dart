import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const CareerCircuitApp());

class CareerCircuitApp extends StatefulWidget {
  const CareerCircuitApp({super.key});
  @override
  State<CareerCircuitApp> createState() => _CareerCircuitAppState();
}

class _CareerCircuitAppState extends State<CareerCircuitApp> {
  final _theme = ValueNotifier(ThemeMode.system);
  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ThemePreference(
    notifier: _theme,
    child: ValueListenableBuilder<ThemeMode>(
      valueListenable: _theme,
      builder: (context, mode, child) => MaterialApp(
        title: 'CareerCircuit',
        debugShowCheckedModeBanner: false,
        theme: careerTheme(Brightness.light),
        darkTheme: careerTheme(Brightness.dark),
        themeMode: mode,
        home: const WelcomeScreen(),
      ),
    ),
  );
}
