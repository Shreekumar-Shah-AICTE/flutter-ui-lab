import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';

class _Article {
  final String title, description, category;
  final Color color;
  final IconData icon;
  const _Article({required this.title, required this.description, required this.category, required this.color, required this.icon});
}

const _articles = [
  _Article(title: 'The Future of AI in Mobile Development', description: 'How generative AI is transforming the way we build and ship mobile applications at scale.', category: 'Technology', color: Color(0xFF667eea), icon: Icons.smart_toy_rounded),
  _Article(title: 'Designing for Accessibility First', description: 'Why inclusive design patterns lead to better products for everyone, not just users with disabilities.', category: 'Design', color: Color(0xFF11998e), icon: Icons.accessibility_new_rounded),
  _Article(title: 'Flutter vs React Native in 2026', description: 'A comprehensive comparison of the two leading cross-platform frameworks for modern mobile development.', category: 'Development', color: Color(0xFFf2994a), icon: Icons.compare_arrows_rounded),
  _Article(title: 'The Psychology of Dark Mode', description: 'Research shows dark interfaces reduce eye strain and improve focus. But do users actually prefer them?', category: 'UX Research', color: Color(0xFF764ba2), icon: Icons.dark_mode_rounded),
  _Article(title: 'Building Design Systems at Scale', description: 'How top companies maintain visual consistency across hundreds of screens and multiple platforms.', category: 'Systems', color: Color(0xFF2193b0), icon: Icons.design_services_rounded),
  _Article(title: 'State Management Simplified', description: 'From setState to Riverpod: finding the right state management approach for your Flutter app.', category: 'Flutter', color: Color(0xFFe44d26), icon: Icons.account_tree_rounded),
  _Article(title: 'Typography That Converts', description: 'The science behind font choices that improve readability, engagement, and conversion rates.', category: 'Typography', color: Color(0xFF38ef7d), icon: Icons.text_fields_rounded),
];

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool _loading = true;
  List<_Article> _items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() { _items = List.from(_articles); _loading = false; });
  }

  Future<void> _refresh() async {
    await _loadData();
  }

  void _dismiss(int index) {
    setState(() => _items.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CATALOG', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.onSurfaceDim, letterSpacing: 6)),
              const SizedBox(height: 4),
              Text('Reading List', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
              const SizedBox(height: 4),
              Text('${_items.length} articles', style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.onSurfaceDim)),
              const SizedBox(height: 20),
              Expanded(
                child: _loading ? _buildShimmer() : RefreshIndicator(
                  onRefresh: _refresh,
                  color: AppColors.accent,
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, i) => _buildCard(_items[i], i),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 120,
          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
        ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.08)),
      ),
    );
  }

  Widget _buildCard(_Article article, int index) {
    return Dismissible(
      key: ValueKey(article.title),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _dismiss(index),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 24),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: AppTokens.subtleShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: article.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(article.icon, color: article.color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: article.color.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                    child: Text(article.category, style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w500, color: article.color)),
                  ),
                  const SizedBox(height: 8),
                  Text(article.title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                  const SizedBox(height: 4),
                  Text(article.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.onSurfaceDim, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 60)).slideY(begin: 0.08);
  }
}
