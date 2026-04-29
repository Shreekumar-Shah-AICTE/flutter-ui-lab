import 'package:flutter/material.dart';

class AppTokens {
  AppTokens._();

  // Spacing (8px baseline grid)
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // Border Radii
  static const double radiusXs = 8.0;
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;
  static const double radiusFull = 9999.0;

  // Shadows
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 8)),
    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get neumorphicLight => [
    BoxShadow(color: Colors.white.withOpacity(0.8), blurRadius: 16, offset: const Offset(-6, -6)),
    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(6, 6)),
  ];

  static List<BoxShadow> get neumorphicPressed => [
    BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 8, offset: const Offset(-3, -3)),
    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(3, 3)),
  ];
}
