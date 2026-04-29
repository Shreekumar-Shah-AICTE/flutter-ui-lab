import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:design_system/design_system.dart';
import 'vault_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(VaultApp(prefs: prefs));
}

class VaultApp extends StatefulWidget {
  final SharedPreferences prefs;
  const VaultApp({super.key, required this.prefs});
  @override
  State<VaultApp> createState() => VaultAppState();
}

class VaultAppState extends State<VaultApp> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.prefs.getBool('darkMode') ?? false;
  }

  void toggleTheme(bool dark) {
    setState(() => _isDark = dark);
    widget.prefs.setBool('darkMode', dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vault',
      debugShowCheckedModeBanner: false,
      theme: _isDark ? AppTheme.dark() : AppTheme.light(),
      home: VaultScreen(prefs: widget.prefs, isDark: _isDark, onThemeToggle: toggleTheme),
    );
  }
}
