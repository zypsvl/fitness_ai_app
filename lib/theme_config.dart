import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/app_colors.dart';

class AppTheme {
  // Modern Color Palette - Using AppColors
  static const Color primaryPurple = AppColors.primaryPurple;
  static const Color primaryPink = AppColors.primaryPurple; // Consolidated
  static const Color secondaryCyan = AppColors.secondaryTurquoise;
  static const Color secondaryBlue = AppColors.secondaryTurquoise; // Consolidated
  static const Color accentOrange = AppColors.warning;
  static const Color accentYellow = AppColors.accentYellow;
  static const Color neonGreen = AppColors.success;

  // Deep Dark Backgrounds
  static const Color backgroundDark = AppColors.backgroundDark;
  static const Color backgroundMedium = AppColors.surfaceDark;
  static const Color backgroundLight = AppColors.surfaceElevatedDark;

  static const Color surfaceDark = AppColors.surfaceDark;
  static const Color surfaceLight = AppColors.surfaceElevatedDark;

  // Vibrant Gradients - Using AppColors
  static const LinearGradient primaryGradient = AppColors.primaryGradient;
  static const LinearGradient secondaryGradient = AppColors.secondaryGradient;
  static const LinearGradient backgroundGradient = AppColors.backgroundGradientDark;
  static const LinearGradient accentGradient = AppColors.accentGradient;
  static const LinearGradient pinkGradient = AppColors.pinkGradient;

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: secondaryCyan,
        surface: surfaceDark,
        background: backgroundDark,
        error: Color(0xFFEF4444),
      ),

      // Text Theme with Google Fonts
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          color: Colors.white70,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: Colors.white60,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: Colors.white54,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          shadowColor: primaryPurple.withValues(alpha: 0.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // Enhanced Glass Container Decoration
  static BoxDecoration glassDecoration({
    Color? color,
    double borderRadius = 20,
    bool showBorder = true,
    double opacity = 0.08,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: showBorder
          ? Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // Neon Glow Shadow
  static List<BoxShadow> neonShadow(Color color, {double opacity = 0.4, double blur = 20}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: color.withValues(alpha: opacity * 0.5),
        blurRadius: blur * 2,
        spreadRadius: 5,
        offset: const Offset(0, 8),
      ),
    ];
  }

  // Shimmer Gradient
  static LinearGradient shimmerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white.withValues(alpha: 0.0),
      Colors.white.withValues(alpha: 0.1),
      Colors.white.withValues(alpha: 0.0),
    ],
    stops: const [0.0, 0.5, 1.0],
  );

  // Light Theme (Minimal support for now, focusing on Dark Mode)
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.light(
        primary: primaryPurple,
        secondary: secondaryCyan,
        surface: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A),
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          color: const Color(0xFF334155),
        ),
      ),
    );
  }
}
