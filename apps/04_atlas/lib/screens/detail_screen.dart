import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';

class DetailScreen extends StatelessWidget {
  final dynamic card;
  const DetailScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Hero(
            tag: 'card_${card.title}',
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: card.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                        const Spacer(),
                        Icon(card.icon, color: Colors.white, size: 36),
                        const SizedBox(height: 12),
                        Text(card.title, style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
                        Text(card.subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 15, color: Colors.white.withOpacity(0.7))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(card.description, style: GoogleFonts.plusJakartaSans(fontSize: 16, height: 1.7, color: AppColors.onSurface)),
            ),
          ),
        ],
      ),
    );
  }
}
