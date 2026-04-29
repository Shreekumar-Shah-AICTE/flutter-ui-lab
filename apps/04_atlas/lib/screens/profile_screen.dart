import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              CircleAvatar(radius: 48, backgroundColor: AppColors.accentSoft, child: Text('S', style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.accent)))
                  .animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 16),
              Text('Shreekumar Shah', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.onSurface))
                  .animate().fadeIn(duration: 500.ms, delay: 100.ms),
              Text('Explorer · Developer', style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.onSurfaceDim))
                  .animate().fadeIn(duration: 500.ms, delay: 150.ms),
              const SizedBox(height: 32),
              _statRow('Destinations', '24'),
              _statRow('Countries', '8'),
              _statRow('Photos', '1,240'),
              _statRow('Reviews', '56'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 15, color: AppColors.onSurface)),
            Text(value, style: GoogleFonts.jetBrainsMono(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.accent)),
          ],
        ),
      ),
    );
  }
}
