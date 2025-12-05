import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/streak_model.dart';
import '../theme_config.dart';
import 'glass_container.dart';

class StreakWidget extends StatelessWidget {
  final StreakModel streakData;
  final VoidCallback? onTap;

  const StreakWidget({
    super.key,
    required this.streakData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAtRisk = streakData.isAtRisk;
    final currentStreak = streakData.currentStreak;
    final longestStreak = streakData.longestStreak;
    final nextMilestone = streakData.nextMilestone;
    final progress = streakData.progressToNextMilestone;

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with fire icon
              Row(
                children: [
                  // Animated fire icon
                  Text(
                    '🔥',
                    style: const TextStyle(fontSize: 32),
                  ).animate(
                    onPlay: (controller) => controller.repeat(),
                  ).shimmer(
                    duration: 2.seconds,
                    color: isAtRisk ? Colors.orange : AppTheme.primaryPurple,
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Streak counter
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentStreak == 0 
                              ? 'Start Your Streak!' 
                              : '$currentStreak Day Streak',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (longestStreak > currentStreak)
                          Text(
                            'Best: $longestStreak days',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Warning message if at risk
              if (isAtRisk)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Workout today to keep your streak!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade200,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).shake(),
              
              // Progress to next milestone
              if (nextMilestone != null && currentStreak > 0) ...[
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Next milestone',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              Text(
                                '$nextMilestone days',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.accentOrange,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              
              // Motivational message for new users
              if (currentStreak == 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Complete a workout to start your streak!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
