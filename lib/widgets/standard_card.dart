import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Elevation levels for cards
enum CardElevation {
  none,
  low,
  medium,
  high,
}

/// Standard card widget for consistent design across the app
/// Provides glass morphism effect with proper shadows and borders
class StandardCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final CardElevation elevation;
  final Color? color;
  final VoidCallback? onTap;
  final bool showBorder;

  const StandardCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.elevation = CardElevation.low,
    this.color,
    this.onTap,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Determine shadow based on elevation
    List<BoxShadow> shadows;
    switch (elevation) {
      case CardElevation.none:
        shadows = [];
        break;
      case CardElevation.low:
        shadows = [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
        break;
      case CardElevation.medium:
        shadows = [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ];
        break;
      case CardElevation.high:
        shadows = [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.16),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ];
        break;
    }

    final widget = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                width: 1,
              )
            : null,
        boxShadow: shadows,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: widget,
      );
    }

    return widget;
  }
}
