import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';

class ProductDetail extends StatelessWidget {
  final dynamic product;
  final bool inCart;
  final VoidCallback onCartToggle;
  const ProductDetail({super.key, required this.product, required this.inCart, required this.onCartToggle});

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
                  Text(product.category.toString().toUpperCase(), style: GoogleFonts.jetBrainsMono(fontSize: 10, color: AppColors.onSurfaceDim, letterSpacing: 2)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 250,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(20)),
                        child: Image.network(product.image, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, size: 48)),
                      ),
                    ).animate().fadeIn(duration: 500.ms),
                    const SizedBox(height: 24),
                    Text(product.title, style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.onSurface, height: 1.3))
                        .animate().fadeIn(duration: 500.ms, delay: 100.ms),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('\$${product.price.toStringAsFixed(2)}', style: GoogleFonts.jetBrainsMono(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.accent)),
                        const Spacer(),
                        Icon(Icons.star_rounded, size: 18, color: const Color(0xFFF2994A)),
                        const SizedBox(width: 4),
                        Text('${product.rating}', style: GoogleFonts.jetBrainsMono(fontSize: 14, color: AppColors.onSurfaceDim)),
                      ],
                    ).animate().fadeIn(duration: 500.ms, delay: 150.ms),
                    const SizedBox(height: 20),
                    Text(product.description, style: GoogleFonts.plusJakartaSans(fontSize: 15, color: AppColors.onSurfaceDim, height: 1.6))
                        .animate().fadeIn(duration: 500.ms, delay: 200.ms),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () { onCartToggle(); Navigator.pop(context); },
                  icon: Icon(inCart ? Icons.remove_shopping_cart_rounded : Icons.add_shopping_cart_rounded),
                  label: Text(inCart ? 'Remove from Cart' : 'Add to Cart'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
