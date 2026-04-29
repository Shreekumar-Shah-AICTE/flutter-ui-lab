import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'news_screen.dart';

void main() => runApp(const DispatchApp());

class DispatchApp extends StatelessWidget {
  const DispatchApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Dispatch', debugShowCheckedModeBanner: false, theme: AppTheme.light(), home: const NewsScreen());
  }
}
