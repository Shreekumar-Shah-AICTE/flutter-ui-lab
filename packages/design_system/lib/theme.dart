import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();
  static const Color surface = Color(0xFFFAFAF8);
  static const Color surfaceAlt = Color(0xFFF0EFEB);
  static const Color onSurface = Color(0xFF1A1A18);
  static const Color onSurfaceDim = Color(0xFF8A8A85);
  static const Color accent = Color(0xFF3A7BF8);
  static const Color accentSoft = Color(0xFFEBF1FE);
  static const Color success = Color(0xFF2DBE6C);
  static const Color error = Color(0xFFF04438);
  static const Color border = Color(0xFFE5E4E0);
  static const Color darkSurface = Color(0xFF0F0F0F);
  static const Color darkSurfaceAlt = Color(0xFF1C1C1C);
  static const Color darkOnSurface = Color(0xFFF0EFEB);
  static const Color darkOnSurfaceDim = Color(0xFF6A6A65);
  static const Color darkAccent = Color(0xFF5B9BFF);
  static const Color darkBorder = Color(0xFF2A2A2A);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme.light(
        surface: AppColors.surface,
        primary: AppColors.accent,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
      ),
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkSurface,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.darkSurface,
        primary: AppColors.darkAccent,
        onSurface: AppColors.darkOnSurface,
        error: AppColors.error,
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.darkBorder, thickness: 1),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color color = brightness == Brightness.light ? AppColors.onSurface : AppColors.darkOnSurface;
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(fontSize: 48, fontWeight: FontWeight.w800, color: color, letterSpacing: -1.5),
      displayMedium: GoogleFonts.plusJakartaSans(fontSize: 36, fontWeight: FontWeight.w700, color: color, letterSpacing: -1.0),
      displaySmall: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w300, color: color, letterSpacing: -0.5),
      headlineLarge: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, color: color),
      headlineMedium: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w600, color: color),
      titleLarge: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: color),
      titleMedium: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: color),
      bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w400, color: color, height: 1.6),
      bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w400, color: color, height: 1.5),
      bodySmall: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w400, color: color.withOpacity(0.6)),
      labelLarge: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w500, color: color, letterSpacing: 0.5),
      labelSmall: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w400, color: color.withOpacity(0.5), letterSpacing: 0.8),
    );
  }
}
