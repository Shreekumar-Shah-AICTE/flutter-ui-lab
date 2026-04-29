import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'counter_screen.dart';

void main() {
  runApp(const PulseApp());
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const CounterScreen(),
    );
  }
}
