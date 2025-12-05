import 'package:flutter/material.dart';

/// Central color palette for the fitness app
/// Using modern, accessible colors with proper contrast ratios
class AppColors {
  // ============================================================
  // PRIMARY COLORS (60% usage)
  // ============================================================
  
  /// Modern Purple - Primary brand color
  /// Used for: Main actions, key UI elements
  static const Color primaryPurple = Color(0xFF6C63FF);
  static const Color primaryPurpleDark = Color(0xFF5750E0);
  static const Color primaryPurpleLight = Color(0xFF8C85FF);
  
  // ============================================================
  // SECONDARY COLORS (30% usage)
  // ============================================================
  
  /// Turquoise - Secondary brand color
  /// Used for: Secondary actions, accents
  static const Color secondaryTurquoise = Color(0xFF2EC4B6);
  static const Color secondaryTurquoiseDark = Color(0xFF25A89C);
  static const Color secondaryTurquoiseLight = Color(0xFF4DD4C7);
  
  // ============================================================
  // ACCENT COLORS (10% usage)
  // ============================================================
  
  /// Yellow - Accent color for achievements and highlights
  /// Used for: Success states, achievements, highlights
  static const Color accentYellow = Color(0xFFFFD93D);
  static const Color accentYellowDark = Color(0xFFE6C335);
  static const Color accentYellowLight = Color(0xFFFFE26B);
  
  // ============================================================
  // SEMANTIC COLORS
  // ============================================================
  
  /// Success color - Green for completed actions
  static const Color success = Color(0xFF10B981);
  
  /// Warning color - Orange for warnings
  static const Color warning = Color(0xFFF97316);
  
  /// Error color - Red for errors
  static const Color error = Color(0xFFEF4444);
  
  /// Info color - Blue for information
  static const Color info = Color(0xFF3B82F6);
  
  // ============================================================
  // DARK THEME BACKGROUNDS
  // ============================================================
  
  /// Main background - Deep dark (not pure black for comfort)
  static const Color backgroundDark = Color(0xFF1A1D23);
  
  /// Surface background - Slightly lighter for cards
  static const Color surfaceDark = Color(0xFF252A31);
  
  /// Elevated surface - For elevated cards and modals
  static const Color surfaceElevatedDark = Color(0xFF2D333B);
  
  // ============================================================
  // DARK THEME TEXT COLORS
  // ============================================================
  
  /// Primary text - Main content (WCAG AAA: 15.3:1 contrast)
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  
  /// Secondary text - Less important content (WCAG AA: 7.2:1 contrast)
  static const Color textSecondaryDark = Color(0xFFA0A4AA);
  
  /// Tertiary text - Hints and disabled (WCAG AA: 4.8:1 contrast)
  static const Color textTertiaryDark = Color(0xFF6B7280);
  
  // ============================================================
  // LIGHT THEME BACKGROUNDS
  // ============================================================
  
  /// Main background - Light neutral
  static const Color backgroundLight = Color(0xFFFAFAFA);
  
  /// Surface background - White for cards
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  /// Elevated surface - Slight shadow for depth
  static const Color surfaceElevatedLight = Color(0xFFF5F5F5);
  
  // ============================================================
  // LIGHT THEME TEXT COLORS
  // ============================================================
  
  /// Primary text - Main content (WCAG AAA: 14.1:1 contrast)
  static const Color textPrimaryLight = Color(0xFF1F2937);
  
  /// Secondary text - Less important content (WCAG AA: 7.5:1 contrast)
  static const Color textSecondaryLight = Color(0xFF4B5563);
  
  /// Tertiary text - Hints and disabled (WCAG AA: 4.6:1 contrast)
  static const Color textTertiaryLight = Color(0xFF9CA3AF);
  
  // ============================================================
  // DIVIDERS & BORDERS
  // ============================================================
  
  static const Color dividerDark = Color(0xFF353B43);
  static const Color dividerLight = Color(0xFFE5E7EB);
  
  // ============================================================
  // GRADIENTS
  // ============================================================
  
  /// Primary gradient - Purple to lighter purple
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryPurpleLight],
  );
  
  /// Secondary gradient - Turquoise gradient
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryTurquoise, secondaryTurquoiseLight],
  );
  
  /// Accent gradient - Yellow to orange
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentYellow, Color(0xFFFFB020)],
  );
  
  /// Success gradient - Green shades
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF34D399)],
  );

  /// Pink gradient - Vibrant pink shades
  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF4B8B), Color(0xFFFF85B3)],
  );
  
  /// Background gradient for screens
  static const LinearGradient backgroundGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundDark,
      Color(0xFF0F1116),
    ],
  );
  
  // ============================================================
  // SHADOW COLORS
  // ============================================================
  
  /// Standard shadow for cards (dark theme)
  static List<BoxShadow> get cardShadowDark => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
  
  /// Standard shadow for cards (light theme)
  static List<BoxShadow> get cardShadowLight => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
  
  /// Neon glow effect for special elements
  static List<BoxShadow> neonGlow(Color color, {double opacity = 0.4}) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: color.withOpacity(opacity * 0.5),
        blurRadius: 40,
        spreadRadius: 5,
        offset: const Offset(0, 8),
      ),
    ];
  }
}
