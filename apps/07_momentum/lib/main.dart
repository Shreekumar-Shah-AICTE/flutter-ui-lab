import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'todo_screen.dart';

void main() => runApp(const MomentumApp());

class MomentumApp extends StatelessWidget {
  const MomentumApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Momentum', debugShowCheckedModeBanner: false, theme: AppTheme.light(), home: const TodoScreen());
  }
}
