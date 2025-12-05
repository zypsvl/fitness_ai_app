import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/nutrition_provider.dart';
import '../providers/workout_provider.dart';
import '../theme_config.dart';
import 'glass_container.dart';
import 'add_nutrition_dialog.dart';
import 'edit_nutrition_goals_dialog.dart';

class NutritionTrackerWidget extends StatelessWidget {
  const NutritionTrackerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionProvider>(
      builder: (context, provider, child) {
        final log = provider.todayLog;
        if (log == null) return const SizedBox.shrink();

        return GlassContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nutrition',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Daily Macros',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditNutritionGoalsDialog(
                              currentCalories: log.targetCalories,
                              currentProtein: log.targetProtein,
                              currentCarbs: log.targetCarbs,
                              currentFat: log.targetFat,
                              onSave: (c, p, cb, f) {
                                provider.updateTargets(
                                  targetCalories: c,
                                  targetProtein: p,
                                  targetCarbs: cb,
                                  targetFat: f,
                                );
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings, color: Colors.white70, size: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AddNutritionDialog(
                              onAdd: (c, p, cb, f) {
                                provider.addEntry(
                                  calories: c,
                                  protein: p,
                                  carbs: cb,
                                  fat: f,
                                );
                                // Also update streak
                                Provider.of<WorkoutProvider>(context, listen: false).updateStreakAfterWorkout();
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_circle, color: AppTheme.primaryPurple),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Calories Progress
              _buildProgressBar(
                label: 'Calories',
                current: log.calories,
                target: log.targetCalories,
                color: const Color(0xFFFF5722),
                unit: 'kcal',
              ),

              const SizedBox(height: 16),

              // Macros Row
              Row(
                children: [
                  Expanded(
                    child: _buildMacroItem(
                      label: 'Protein',
                      current: log.protein,
                      target: log.targetProtein,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMacroItem(
                      label: 'Carbs',
                      current: log.carbs,
                      target: log.targetCarbs,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMacroItem(
                      label: 'Fat',
                      current: log.fat,
                      target: log.targetFat,
                      color: const Color(0xFFFFC107),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.1);
      },
    );
  }

  Widget _buildProgressBar({
    required String label,
    required int current,
    required int target,
    required Color color,
    required String unit,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text('$current / $target $unit', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroItem({
    required String label,
    required int current,
    required int target,
    required Color color,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          const SizedBox(height: 4),
          Text('${current}g', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
