import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';

/// Button size variants
enum ButtonSize {
  small,
  medium,
  large,
}

/// Button style variants
enum ButtonVariant {
  filled,
  outlined,
  text,
  gradient,
}

/// Standard primary button with consistent styling
/// Includes haptic feedback and accessibility support
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final LinearGradient? gradient;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.filled,
    this.icon,
    this.isLoading = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    // Determine sizing based on ButtonSize
    double fontSize;
    EdgeInsets padding;
    double iconSize;
    
    switch (size) {
      case ButtonSize.small:
        fontSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
        iconSize = 18;
        break;
      case ButtonSize.medium:
        fontSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
        iconSize = 20;
        break;
      case ButtonSize.large:
        fontSize = 18;
        padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 18);
        iconSize = 24;
        break;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == ButtonVariant.filled || variant == ButtonVariant.gradient
                    ? Colors.white
                    : AppColors.primaryPurple,
              ),
            ),
          )
        else if (icon != null) ...[
          Icon(icon, size: iconSize),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    switch (variant) {
      case ButtonVariant.filled:
        return ElevatedButton(
          onPressed: isLoading ? null : _handleTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: Colors.white,
            padding: padding,
            elevation: 0,
            shadowColor: AppColors.primaryPurple.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(88, 44), // Accessibility minimum
          ),
          child: buttonChild,
        );

      case ButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : _handleTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryPurple,
            padding: padding,
            side: const BorderSide(
              color: AppColors.primaryPurple,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(88, 44),
          ),
          child: buttonChild,
        );

      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : _handleTap,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryPurple,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(88, 44),
          ),
          child: buttonChild,
        );

      case ButtonVariant.gradient:
        return Container(
          decoration: BoxDecoration(
            gradient: gradient ?? AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppColors.neonGlow(
              gradient?.colors.first ?? AppColors.primaryPurple,
              opacity: 0.3,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : _handleTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: padding,
                constraints: const BoxConstraints(minWidth: 88, minHeight: 44),
                alignment: Alignment.center,
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  child: buttonChild,
                ),
              ),
            ),
          ),
        );
    }
  }

  void _handleTap() {
    // Haptic feedback for better UX
    HapticFeedback.lightImpact();
    onPressed?.call();
  }
}
