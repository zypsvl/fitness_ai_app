import 'package:flutter/material.dart';
import '../theme_config.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.isSelected = false,
    this.selectedColor = const Color(0xFFBB86FC), // Default to primary purple
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: margin,
        padding: padding ?? const EdgeInsets.all(24),
        decoration: AppTheme.glassDecoration(
          color: isSelected ? selectedColor.withValues(alpha: 0.2) : null,
          showBorder: isSelected,
          borderRadius: borderRadius,
        ).copyWith(
          boxShadow: isSelected ? AppTheme.neonShadow(selectedColor) : [],
          border: isSelected ? Border.all(color: selectedColor, width: 2) : null,
        ),
        child: child,
      ),
    );
  }
}
