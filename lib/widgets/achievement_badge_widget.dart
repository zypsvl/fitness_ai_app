import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/user_stats_model.dart';
import '../theme_config.dart';

class AchievementBadgeWidget extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;

  const AchievementBadgeWidget({
    super.key,
    required this.achievement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isUnlocked
              ? LinearGradient(
                  colors: [
                    AppTheme.primaryPurple.withValues(alpha: 0.3),
                    AppTheme.secondaryCyan.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isUnlocked ? null : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? AppTheme.secondaryCyan.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: 2,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isUnlocked ? AppTheme.primaryGradient : null,
                color: isUnlocked ? null : Colors.white.withValues(alpha: 0.1),
                boxShadow: isUnlocked
                    ? AppTheme.neonShadow(
                        AppTheme.primaryPurple,
                        opacity: 0.5,
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: TextStyle(
                    fontSize: 32,
                    color: isUnlocked ? null : Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            )
                .animate(
                  target: isUnlocked ? 1 : 0,
                )
                .scale(
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 12),
            // Title
            Text(
              achievement.title,
              style: TextStyle(
                color: isUnlocked ? Colors.white : Colors.white.withValues(alpha: 0.4),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              achievement.description,
              style: TextStyle(
                color: isUnlocked
                    ? AppTheme.secondaryCyan
                    : Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Lock/Unlock indicator
            if (!isUnlocked)
              Icon(
                Icons.lock_outline,
                size: 16,
                color: Colors.white.withValues(alpha: 0.3),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 14,
                    color: AppTheme.secondaryCyan,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Açıldı!',
                    style: TextStyle(
                      color: AppTheme.secondaryCyan,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
