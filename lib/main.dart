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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
