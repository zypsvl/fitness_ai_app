import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../theme_config.dart';
import '../services/share_service.dart';
import '../widgets/shareable_stats_card.dart';

class StreakFlameWidget extends StatelessWidget {
  const StreakFlameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        final streak = provider.streakData.currentStreak;
        final isAtRisk = provider.isStreakAtRisk();
        
        // Determine flame color based on streak
        Color flameColor;
        if (streak >= 30) {
          flameColor = const Color(0xFFB388FF); // Purple (Master)
        } else if (streak >= 7) {
          flameColor = const Color(0xFFFF5722); // Orange (Hot)
        } else {
          flameColor = const Color(0xFFFFC107); // Yellow (Warm)
        }

        return GestureDetector(
          onTap: () {
            final shareService = ShareService();
            shareService.shareWidget(
              context: context,
              subject: 'My GymGenius Streak! 🔥',
              text: 'I\'m on a $streak day streak with GymGenius! Can you beat me? 🏃‍♂️💨',
              widget: ShareableStatsCard(
                title: 'CURRENT STREAK',
                value: '$streak Days',
                subtitle: isAtRisk ? 'Keeping it alive!' : 'On fire! 🔥',
                icon: Icons.local_fire_department,
                color: flameColor,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isAtRisk ? Colors.red.withValues(alpha: 0.5) : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: flameColor,
                  size: 24,
                )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  duration: 1000.ms,
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                )
                .then()
                .shimmer(duration: 2000.ms, color: Colors.white.withValues(alpha: 0.5)),
                
                const SizedBox(width: 8),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$streak Day Streak',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (isAtRisk)
                      Text(
                        'Keep it up!',
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
