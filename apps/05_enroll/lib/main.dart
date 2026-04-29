import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'registration_screen.dart';

void main() => runApp(const EnrollApp());

class EnrollApp extends StatelessWidget {
  const EnrollApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enroll',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const RegistrationScreen(),
    );
  }
}
