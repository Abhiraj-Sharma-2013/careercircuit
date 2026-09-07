import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const CareerCircuitApp());
}

class CareerCircuitApp extends StatelessWidget {
  const CareerCircuitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareerCircuit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF123B63),
          onPrimary: Colors.white,
          secondary: Color(0xFFB9DDF7),
          onSecondary: Color(0xFF123B63),
          surface: Colors.white,
          onSurface: Color(0xFF123B63),
          outline: Color(0xFF6F9FC5),
          outlineVariant: Color(0xFFB9DDF7),
        ),
        scaffoldBackgroundColor: const Color(0xFFEAF5FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFEAF5FF),
          foregroundColor: Color(0xFF123B63),
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 5,
          color: Colors.white,
          shadowColor: Color(0x33123B63),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF123B63),
            foregroundColor: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF123B63),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
