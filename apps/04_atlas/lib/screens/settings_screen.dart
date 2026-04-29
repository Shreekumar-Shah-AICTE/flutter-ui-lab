import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface))
                  .animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 24),
              _settingsTile(Icons.notifications_rounded, 'Notifications', true),
              _settingsTile(Icons.dark_mode_rounded, 'Dark Mode', false),
              _settingsTile(Icons.language_rounded, 'Language', null),
              _settingsTile(Icons.info_outline_rounded, 'About', null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String label, bool? toggle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.onSurfaceDim),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 15, color: AppColors.onSurface))),
            if (toggle != null)
              Switch(value: toggle, onChanged: (_) {}, activeColor: AppColors.accent)
            else
              Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceDim, size: 20),
          ],
        ),
      ),
    );
  }
}
