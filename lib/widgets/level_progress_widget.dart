import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/user_level_model.dart';
import '../theme_config.dart';
import 'glass_container.dart';

class LevelProgressWidget extends StatelessWidget {
  final UserLevel userLevel;
  final VoidCallback? onTap;
  final bool compact;

  const LevelProgressWidget({
    super.key,
    required this.userLevel,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentLevel = userLevel.currentLevel;
    final currentXP = userLevel.currentLevelXP;
    final xpToNext = userLevel.xpToNextLevel;
    final progress = userLevel.levelProgress;

    if (compact) {
      return _buildCompactView(currentLevel, currentXP, xpToNext, progress);
    }

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Level badge
                  _buildLevelBadge(currentLevel),
                  
                  const SizedBox(width: 12),
                  
                  // Level info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level $currentLevel',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '$currentXP / $xpToNext XP',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.primaryPurple,
                                        AppTheme.primaryPink,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ).animate(
                                  onPlay: (controller) => controller.repeat(reverse: true),
                                ).shimmer(
                                  duration: 2.seconds,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Stats row
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatChip(
                    icon: Icons.fitness_center,
                    label: '${userLevel.totalWorkouts} workouts',
                    color: AppTheme.secondaryCyan,
                  ),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    icon: Icons.emoji_events,
                    label: '${userLevel.totalPRs} PRs',
                    color: AppTheme.accentOrange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactView(
    int level,
    int currentXP,
    int xpToNext,
    double progress,
  ) {
    return Row(
      children: [
        _buildLevelBadge(level, size: 32),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level $level',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryPurple,
                  ),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelBadge(int level, {double size = 48}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryPurple,
            AppTheme.primaryPink,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$level',
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).scale(
      duration: 2.seconds,
      begin: const Offset(1.0, 1.0),
      end: const Offset(1.05, 1.05),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
