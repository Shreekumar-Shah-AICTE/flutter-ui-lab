import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(const AtlasApp());

class AtlasApp extends StatelessWidget {
  const AtlasApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AtlasShell(),
    );
  }
}

class AtlasShell extends StatefulWidget {
  const AtlasShell({super.key});
  @override
  State<AtlasShell> createState() => _AtlasShellState();
}

class _AtlasShellState extends State<AtlasShell> {
  int _currentIndex = 0;
  final _pages = const [HomeScreen(), ExploreScreen(), ProfileScreen(), SettingsScreen()];
  final _labels = const ['Home', 'Explore', 'Profile', 'Settings'];
  final _icons = const [Icons.home_rounded, Icons.explore_rounded, Icons.person_rounded, Icons.settings_rounded];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (i) => _buildNavItem(i)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icons[index], size: 22, color: isActive ? AppColors.accent : AppColors.onSurfaceDim),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(_labels[index], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent)),
            ],
          ],
        ),
      ),
    );
  }
}
