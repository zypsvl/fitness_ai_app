import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme_config.dart';
import '../widgets/glass_container.dart';

class EquipmentIconCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;

  const EquipmentIconCard({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = selectedColor ?? AppTheme.secondaryCyan;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
              ? color 
              : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
            ? AppTheme.neonShadow(color, opacity: 0.4)
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
              ],
        ),
        child: GlassContainer(
          borderRadius: 16,
          padding: const EdgeInsets.all(20),
          showBorder: false,  // Border handled by outer container
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon container
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: isSelected 
                    ? LinearGradient(
                        colors: [color, color.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                  color: isSelected 
                    ? null 
                    : Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  boxShadow: isSelected 
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Selection indicator
              if (isSelected) ...[ 
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: color, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Seçildi',
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
