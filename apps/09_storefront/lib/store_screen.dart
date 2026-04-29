import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:design_system/design_system.dart';
import 'product_detail.dart';

class _Product {
  final int id;
  final String title, category, image, description;
  final double price, rating;
  _Product({required this.id, required this.title, required this.category, required this.image, required this.price, required this.rating, required this.description});
  factory _Product.fromJson(Map<String, dynamic> j) => _Product(
    id: j['id'], title: j['title'], category: j['category'], image: j['image'],
    price: (j['price'] as num).toDouble(), rating: (j['rating']['rate'] as num).toDouble(),
    description: j['description'],
  );
}

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<_Product> _products = [];
  bool _loading = true;
  String? _error;
  final Set<int> _cart = {};

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await http.get(Uri.parse('https://fakestoreapi.com/products?limit=12'));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        setState(() { _products = list.map((j) => _Product.fromJson(j)).toList(); _loading = false; });
      } else {
        setState(() { _error = 'Failed to load (${res.statusCode})'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = 'Network error'; _loading = false; });
    }
  }

  void _toggleCart(int id) => setState(() => _cart.contains(id) ? _cart.remove(id) : _cart.add(id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('STOREFRONT', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.onSurfaceDim, letterSpacing: 6)),
                        const SizedBox(height: 4),
                        Text('Shop', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(icon: const Icon(Icons.shopping_bag_outlined), onPressed: () {}),
                      if (_cart.isNotEmpty)
                        Positioned(right: 6, top: 6, child: Container(
                          padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                          child: Text('${_cart.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _loading ? _buildShimmer()
                    : _error != null ? _buildError()
                    : RefreshIndicator(
                        onRefresh: _fetch,
                        color: AppColors.accent,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.62,
                          ),
                          itemCount: _products.length,
                          itemBuilder: (_, i) => _buildCard(_products[i], i),
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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.65),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.08)),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.onSurfaceDim),
          const SizedBox(height: 12),
          Text(_error!, style: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppColors.onSurfaceDim)),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _fetch, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildCard(_Product p, int index) {
    final inCart = _cart.contains(p.id);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail(product: p, inCart: inCart, onCartToggle: () => _toggleCart(p.id)))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.4)),
          boxShadow: AppTokens.subtleShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.network(p.image, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, size: 32)),
                  ),
                  Positioned(top: 8, right: 8, child: GestureDetector(
                    onTap: () => _toggleCart(p.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppTokens.subtleShadow),
                      child: Icon(inCart ? Icons.shopping_bag_rounded : Icons.shopping_bag_outlined, size: 16, color: inCart ? AppColors.accent : AppColors.onSurfaceDim),
                    ),
                  )),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurface, height: 1.3)),
                    const Spacer(),
                    Row(
                      children: [
                        Text('\$${p.price.toStringAsFixed(2)}', style: GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.accent)),
                        const Spacer(),
                        Icon(Icons.star_rounded, size: 14, color: const Color(0xFFF2994A)),
                        const SizedBox(width: 2),
                        Text(p.rating.toString(), style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.onSurfaceDim)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 50)).scale(begin: const Offset(0.95, 0.95));
  }
}
