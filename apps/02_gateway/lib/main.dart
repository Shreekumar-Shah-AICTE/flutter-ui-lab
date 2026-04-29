import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'login_screen.dart';

void main() {
  runApp(const GatewayApp());
}

class GatewayApp extends StatelessWidget {
  const GatewayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gateway',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const LoginScreen(),
    );
  }
}
