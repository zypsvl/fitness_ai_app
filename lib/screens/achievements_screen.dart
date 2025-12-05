import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/user_stats_model.dart';
import '../data/achievements_data.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/achievement_badge_widget.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';

class AchievementsScreen extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementsScreen({
    super.key,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context);
    final allAchievements = achievements.isNotEmpty
        ? achievements
        : AchievementsData.getDefaultAchievements();

    final unlockedCount =
        allAchievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.achievements),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Card
                GlassContainer(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 20,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: AppTheme.neonShadow(
                            AppTheme.primaryPurple,
                            opacity: 0.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.earnedAchievements,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$unlockedCount / ${allAchievements.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: unlockedCount / allAchievements.length,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.secondaryCyan,
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: -0.2),

                // Achievement Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: allAchievements.length,
                  itemBuilder: (context, index) {
                    final achievement = allAchievements[index];
                    return AchievementBadgeWidget(
                      achievement: achievement,
                      onTap: () {
                        _showAchievementDetails(context, achievement, strings);
                      },
                    ).animate(delay: (100 * index).ms).fadeIn().scale();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(BuildContext context, Achievement achievement, AppStrings strings) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: achievement.isUnlocked
                      ? AppTheme.primaryGradient
                      : null,
                  color: achievement.isUnlocked
                      ? null
                      : Colors.white.withValues(alpha: 0.1),
                ),
                child: Text(
                  achievement.icon,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                achievement.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                achievement.description,
                style: TextStyle(
                  color: AppTheme.secondaryCyan,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (achievement.isUnlocked && achievement.unlockedDate != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${strings.unlockedOn} ${achievement.unlockedDate!.day}/${achievement.unlockedDate!.month}/${achievement.unlockedDate!.year}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        strings.notUnlockedYet,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  strings.close,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
