import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:design_system/design_system.dart';
import 'article_detail.dart';

class _NewsArticle {
  final String title, description, url, source;
  final String? image, publishedAt;
  _NewsArticle({required this.title, required this.description, required this.url, required this.source, this.image, this.publishedAt});
  factory _NewsArticle.fromJson(Map<String, dynamic> j) => _NewsArticle(
    title: j['title'] ?? '', description: j['description'] ?? '',
    url: j['url'] ?? '', source: j['source']?['name'] ?? 'Unknown',
    image: j['image'], publishedAt: j['publishedAt'],
  );
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _categories = const ['general', 'technology', 'science', 'business', 'health', 'sports'];
  String _selectedCat = 'general';
  List<_NewsArticle> _articles = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() { _loading = true; _error = null; });
    try {
      final url = 'https://gnews.io/api/v4/top-headlines?category=$_selectedCat&lang=en&max=10&apikey=demo';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = (data['articles'] as List?) ?? [];
        setState(() { _articles = list.map((j) => _NewsArticle.fromJson(j)).toList(); _loading = false; });
      } else {
        setState(() { _error = 'API error (${res.statusCode})'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = 'Network error. Check connection.'; _loading = false; });
    }
  }

  void _selectCategory(String cat) {
    setState(() => _selectedCat = cat);
    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DISPATCH', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.onSurfaceDim, letterSpacing: 6)),
                  const SizedBox(height: 4),
                  Text('Headlines', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: _categories.length,
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  final active = cat == _selectedCat;
                  return GestureDetector(
                    onTap: () => _selectCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: active ? AppColors.accent : AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat[0].toUpperCase() + cat.substring(1),
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.onSurfaceDim),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading ? _buildShimmer()
                  : _error != null ? _buildError()
                  : _articles.isEmpty ? Center(child: Text('No articles found.', style: GoogleFonts.plusJakartaSans(color: AppColors.onSurfaceDim)))
                  : RefreshIndicator(
                      onRefresh: _fetchNews,
                      color: AppColors.accent,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _articles.length,
                        itemBuilder: (_, i) => _buildArticle(_articles[i], i),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 5,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(height: 110, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)))
            .animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.08)),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.onSurfaceDim),
        const SizedBox(height: 12),
        Text(_error!, style: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppColors.onSurfaceDim)),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: _fetchNews, child: const Text('Retry')),
      ]),
    );
  }

  Widget _buildArticle(_NewsArticle a, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetail(article: a))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.4)),
          boxShadow: AppTokens.subtleShadow,
        ),
        child: Row(
          children: [
            if (a.image != null)
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: SizedBox(
                  width: 110, height: 110,
                  child: Image.network(a.image!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceAlt, child: const Icon(Icons.image_outlined, size: 24))),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.source, style: GoogleFonts.jetBrainsMono(fontSize: 10, color: AppColors.accent, fontWeight: FontWeight.w500, letterSpacing: 1)),
                    const SizedBox(height: 6),
                    Text(a.title, maxLines: 3, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface, height: 1.3)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 60)).slideX(begin: 0.05);
  }
}
