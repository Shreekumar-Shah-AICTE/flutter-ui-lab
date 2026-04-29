import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';
import 'package:http/http.dart' as http;

class ArticleDetail extends StatelessWidget {
  final dynamic article;
  const ArticleDetail({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
                  const Spacer(),
                  Text(article.source.toString().toUpperCase(), style: GoogleFonts.jetBrainsMono(fontSize: 10, color: AppColors.accent, letterSpacing: 2)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: double.infinity, height: 200,
                          child: Image.network(article.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 200, color: AppColors.surfaceAlt)),
                        ),
                      ).animate().fadeIn(duration: 500.ms),
                    const SizedBox(height: 20),
                    Text(article.title, style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.onSurface, height: 1.3))
                        .animate().fadeIn(duration: 500.ms, delay: 100.ms),
                    const SizedBox(height: 16),
                    Text(article.description, style: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppColors.onSurfaceDim, height: 1.7))
                        .animate().fadeIn(duration: 500.ms, delay: 200.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
