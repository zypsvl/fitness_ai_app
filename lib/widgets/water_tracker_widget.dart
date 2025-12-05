import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../theme_config.dart';
import '../widgets/glass_container.dart';
import '../utils/app_strings.dart';

class WaterTrackerWidget extends StatelessWidget {
  const WaterTrackerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);
    final strings = AppStrings(context);
    final waterIntake = provider.todayWaterIntake;

    if (waterIntake == null) {
      return const SizedBox.shrink();
    }

    final progress = waterIntake.progress;
    final isGoalReached = waterIntake.isGoalReached;

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isGoalReached
                        ? [AppTheme.secondaryCyan, AppTheme.primaryPurple]
                        : [
                            const Color(0xFF4FC3F7),
                            const Color(0xFF29B6F6)
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_drink,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.waterIntake,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      strings.dailyWaterGoal,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showGoalDialog(context, provider, strings),
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white70,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress Circle and Stats
          Row(
            children: [
              // Circular Progress
              SizedBox(
                width: 100,
height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isGoalReached
                              ? AppTheme.secondaryCyan
                              : const Color(0xFF4FC3F7),
                        ),
                      ),
                    ).animate(
                      onPlay: isGoalReached
                          ? (controller) => controller.repeat()
                          : null,
                    ).scale(
                      duration: 1000.ms,
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isGoalReached)
                          const Text(
                            '🎉',
                            style: TextStyle(fontSize: 16),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Consumed
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          strings.consumed,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${waterIntake.totalMl} ${strings.ml}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Goal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          strings.dailyWaterGoal,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${waterIntake.goalMl} ${strings.ml}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Remaining
                    if (!isGoalReached)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            strings.remaining,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${waterIntake.remainingMl} ${strings.ml}',
                            style: const TextStyle(
                              color: Color(0xFF4FC3F7),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.secondaryCyan,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            strings.goalReached,
                            style: const TextStyle(
                              color: AppTheme.secondaryCyan,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Add Water Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                provider.addWater(250);
                HapticFeedback.lightImpact();
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                '+ 250${strings.ml}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  void _showGoalDialog(
    BuildContext context,
    WorkoutProvider provider,
    AppStrings strings,
  ) {
    final currentGoal = provider.todayWaterIntake?.goalMl ?? 2000;
    int selectedGoal = currentGoal;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1F38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            strings.waterGoal,
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Preset buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [1500, 2000, 2500, 3000].map((goal) {
                  final isSelected = selectedGoal == goal;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGoal = goal;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  const Color(0xFF4FC3F7),
                                  const Color(0xFF29B6F6)
                                ],
                              )
                            : null,
                        color: isSelected
                            ? null
                            : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4FC3F7)
                              : Colors.white.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '${(goal / 1000).toStringAsFixed(1)}${strings.liters}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Selected goal display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      strings.dailyWaterGoal,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$selectedGoal ${strings.ml}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.cancel),
            ),
            TextButton(
              onPressed: () {
                provider.setWaterGoal(selectedGoal);
                Navigator.pop(context);
              },
              child: Text(
                strings.save,
                style: const TextStyle(color: Color(0xFF4FC3F7)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
