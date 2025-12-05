import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme_config.dart';
import '../widgets/glass_container.dart';

class AnatomicalBodySelector extends StatefulWidget {
  final Set<String> selectedAreas;
  final Function(String) onAreaToggle;

  const AnatomicalBodySelector({
    super.key,
    required this.selectedAreas,
    required this.onAreaToggle,
  });

  @override
  State<AnatomicalBodySelector> createState() => _AnatomicalBodySelectorState();
}

class _AnatomicalBodySelectorState extends State<AnatomicalBodySelector> {
  bool _showingFront = true;

  // Define clickable areas with their positions (rough percentages)
  final Map<String, Map<String, dynamic>> _frontAreas = {
    'chest': {'icon': Icons.favorite, 'top': 0.25, 'left': 0.35, 'width': 0.3, 'height': 0.15},
    'shoulders': {'icon': Icons.accessibility_new, 'top': 0.18, 'left': 0.15, 'width': 0.7, 'height': 0.12},
    'arms': {'icon': Icons.fitness_center, 'top': 0.3, 'left': 0.05, 'width': 0.2, 'height': 0.25},
    'core': {'icon': Icons.center_focus_strong, 'top': 0.42, 'left': 0.35, 'width': 0.3, 'height': 0.18},
    'legs': {'icon': Icons.directions_run, 'top': 0.65, 'left': 0.25, 'width': 0.5, 'height': 0.3},
  };

  final Map<String, Map<String, dynamic>> _backAreas = {
    'back': {'icon': Icons.back_hand, 'top': 0.25, 'left': 0.25, 'width': 0.5, 'height': 0.35},
    'shoulders': {'icon': Icons.accessibility_new, 'top': 0.18, 'left': 0.15, 'width': 0.7, 'height': 0.12},
    'glutes': {'icon': Icons.sports_gymnastics, 'top': 0.55, 'left': 0.3, 'width': 0.4, 'height': 0.15},
    'legs': {'icon': Icons.directions_run, 'top': 0.7, 'left': 0.25, 'width': 0.5, 'height': 0.25},
  };

  @override
  Widget build(BuildContext context) {
    final currentAreas = _showingFront ? _frontAreas : _backAreas;
    
    return Column(
      children: [
        // Front/Back Toggle
        GlassContainer(
          padding: const EdgeInsets.all(4),
          borderRadius: 12,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleButton('Ön', _showingFront, () {
                setState(() => _showingFront = true);
              }),
              const SizedBox(width: 4),
              _buildToggleButton('Arka', !_showingFront, () {
                setState(() => _showingFront = false);
              }),
            ],
          ),
        ).animate().fadeIn().slideY(begin: -0.2),
        
        const SizedBox(height: 24),
        
        // Body visualization with clickable areas
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Background silhouette (placeholder - in real app would be an image)
                  Center(
                    child: Container(
                      width: constraints.maxWidth * 0.6,
                      height: constraints.maxHeight * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.person,
                        size: constraints.maxHeight * 0.8,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  
                  // Clickable area buttons
                  ...currentAreas.entries.map((entry) {
                    final areaKey = entry.key;
                    final areaData = entry.value;
                    final isSelected = widget.selectedAreas.contains(areaKey);
                    
                    return Positioned(
                      top: constraints.maxHeight * (areaData['top'] as double),
                      left: constraints.maxWidth * (areaData['left'] as double),
                      width: constraints.maxWidth * (areaData['width'] as double),
                      height: constraints.maxHeight * (areaData['height'] as double),
                      child: GestureDetector(
                        onTap: () => widget.onAreaToggle(areaKey),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? AppTheme.primaryPurple.withValues(alpha: 0.3)
                              : Colors.transparent,
                            border: Border.all(
                              color: isSelected 
                                ? AppTheme.primaryPurple
                                : Colors.white.withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSelected 
                              ? AppTheme.neonShadow(AppTheme.primaryPurple, opacity: 0.4)
                              : null,
                          ),
                          child: Center(
                            child: Icon(
                              areaData['icon'] as IconData,
                              color: isSelected 
                                ? AppTheme.primaryPurple
                                : Colors.white.withValues(alpha: 0.3),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    );

                  }),
                ],
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Selected areas chips
        if (widget.selectedAreas.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: widget.selectedAreas.map((area) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient.scale(0.7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.neonShadow(AppTheme.primaryPurple, opacity: 0.3),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getAreaLabel(area),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => widget.onAreaToggle(area),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 100.ms),
      ],
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.secondaryGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _getAreaLabel(String key) {
    switch (key) {
      case 'chest':
        return 'Göğüs';
      case 'back':
        return 'Sırt';
      case 'shoulders':
        return 'Omuzlar';
      case 'arms':
        return 'Kollar';
      case 'core':
        return 'Karın';
      case 'legs':
        return 'Bacaklar';
      case 'glutes':
        return 'Kalçalar';
      default:
        return key;
    }
  }
}
