import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'calculator_screen.dart';

void main() {
  runApp(const CalcNoirApp());
}

class CalcNoirApp extends StatelessWidget {
  const CalcNoirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calc.Noir',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const CalculatorScreen(),
    );
  }
}
