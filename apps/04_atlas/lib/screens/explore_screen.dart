import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});
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
              Text('Explore', style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface))
                  .animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 8),
              Text('Browse categories and find your next adventure.', style: GoogleFonts.plusJakartaSans(fontSize: 15, color: AppColors.onSurfaceDim))
                  .animate().fadeIn(duration: 500.ms, delay: 50.ms),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _tile(Icons.photo_camera_rounded, 'Photography', const Color(0xFF667eea)),
                    _tile(Icons.music_note_rounded, 'Music', const Color(0xFFf2994a)),
                    _tile(Icons.brush_rounded, 'Art', const Color(0xFF11998e)),
                    _tile(Icons.code_rounded, 'Code', const Color(0xFF764ba2)),
                    _tile(Icons.sports_esports_rounded, 'Gaming', const Color(0xFF2193b0)),
                    _tile(Icons.restaurant_rounded, 'Food', const Color(0xFFf2c94c)),
                  ].asMap().entries.map((e) => e.value.animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: e.key * 60)).scale(begin: const Offset(0.9, 0.9))).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
