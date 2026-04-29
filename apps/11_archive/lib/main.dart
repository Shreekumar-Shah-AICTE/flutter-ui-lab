import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'notes_screen.dart';

void main() => runApp(const ArchiveApp());

class ArchiveApp extends StatelessWidget {
  const ArchiveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Archive', debugShowCheckedModeBanner: false, theme: AppTheme.light(), home: const NotesScreen());
  }
}
