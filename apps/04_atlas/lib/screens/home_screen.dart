import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
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
              Text('ATLAS', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.onSurfaceDim, letterSpacing: 6))
                  .animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 8),
              Text('Discover', style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface))
                  .animate().fadeIn(duration: 500.ms, delay: 50.ms),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _cards.length,
                  itemBuilder: (context, i) {
                    final card = _cards[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _HeroCard(card: card, index: i),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final _CardData card;
  final int index;
  const _HeroCard({required this.card, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(card: card))),
      child: Hero(
        tag: 'card_${card.title}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: card.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: card.gradient.first.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(card.icon, color: Colors.white.withOpacity(0.9), size: 28),
                const SizedBox(height: 12),
                Text(card.title, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                Text(card.subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white.withOpacity(0.7))),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: Duration(milliseconds: index * 80)).slideY(begin: 0.1);
  }
}

class _CardData {
  final String title, subtitle, description;
  final IconData icon;
  final List<Color> gradient;
  const _CardData({required this.title, required this.subtitle, required this.description, required this.icon, required this.gradient});
}

const _cards = [
  _CardData(title: 'Mountains', subtitle: 'Explore peaks', description: 'Discover the world\'s most breathtaking mountain ranges, from the Himalayas to the Andes. Each summit tells a story of geological wonder and human perseverance.', icon: Icons.landscape_rounded, gradient: [Color(0xFF667eea), Color(0xFF764ba2)]),
  _CardData(title: 'Oceans', subtitle: 'Dive deep', description: 'The ocean covers over 70% of our planet. Explore coral reefs, deep-sea trenches, and the incredible biodiversity that thrives beneath the surface.', icon: Icons.water_rounded, gradient: [Color(0xFF2193b0), Color(0xFF6dd5ed)]),
  _CardData(title: 'Forests', subtitle: 'Into the wild', description: 'From ancient rainforests to boreal woodlands, forests are the lungs of our planet. Discover ecosystems that support millions of species.', icon: Icons.forest_rounded, gradient: [Color(0xFF11998e), Color(0xFF38ef7d)]),
  _CardData(title: 'Deserts', subtitle: 'Golden horizons', description: 'Deserts may seem barren, but they are full of life. From the Sahara to the Atacama, explore the beauty and resilience of arid landscapes.', icon: Icons.wb_sunny_rounded, gradient: [Color(0xFFf2994a), Color(0xFFf2c94c)]),
];
