// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';
// Подключение глобальных переменных

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home:  Landing(),
      debugShowCheckedModeBanner: false,
    );
  }
}
