import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/workout_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/stats_card_widget.dart';
import '../widgets/volume_chart_widget.dart';
import '../widgets/muscle_distribution_chart.dart';
import '../widgets/smart_insights_card.dart';
import '../data/achievements_data.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import 'achievements_screen.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final userProvider = Provider.of<UserProfileProvider>(context);
    final strings = AppStrings(context);
    final allWorkouts = workoutProvider.workoutHistory;

    // Calculate statistics
    final totalWorkouts = allWorkouts.length;
    final totalMinutes =
        allWorkouts.fold<int>(0, (sum, w) => sum + w.duration.inMinutes);
    final totalVolume = allWorkouts.fold<double>(0, (sum, w) => sum + w.totalVolume);
    final totalSets = allWorkouts.fold<int>(0, (sum, w) => sum + w.totalSets);
    final totalReps = allWorkouts.fold<int>(0, (sum, w) => sum + w.totalReps);

    // Calculate streak
    int currentStreak = workoutProvider.streakData.currentStreak;

    // Calculate score
    final score = _calculateScore(
      totalWorkouts,
      currentStreak,
      totalVolume,
      totalSets,
    );

    // Check achievements
    final achievements = AchievementsData.checkAchievements(
      AchievementsData.getDefaultAchievements(),
      totalWorkouts,
      currentStreak,
      totalVolume,
      totalSets,
    );
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;

    // Get average workout duration
    final avgDuration =
        totalWorkouts > 0 ? totalMinutes / totalWorkouts : 0.0;

    // Get Advanced Stats Data
    final volumeData = workoutProvider.getVolumeProgression();
    final muscleData = workoutProvider.getMuscleGroupDistribution();
    final insights = workoutProvider.getSmartInsights();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.statistics),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Score Card
                GlassContainer(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 20,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      Text(
                        strings.fitnessScore,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: score / 100,
                              strokeWidth: 12,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.secondaryCyan,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '$score',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              ),
                              Text(
                                strings.getScoreLabel(score),
                                style: TextStyle(
                                  color: AppTheme.secondaryCyan,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn().scale(),

                // Smart Insights
                if (insights.isNotEmpty) ...[
                  SmartInsightsCard(insights: insights),
                  const SizedBox(height: 24),
                ],

                // Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    StatsCardWidget(
                      title: strings.totalWorkouts,
                      value: '$totalWorkouts',
                      subtitle: strings.workouts,
                      icon: Icons.fitness_center,
                      color: AppTheme.primaryPurple,
                    ).animate(delay: 100.ms).fadeIn().scale(),
                    StatsCardWidget(
                      title: strings.currentStreak,
                      value: '$currentStreak',
                      subtitle: strings.days,
                      icon: Icons.local_fire_department,
                      color: AppTheme.accentOrange,
                    ).animate(delay: 200.ms).fadeIn().scale(),
                    StatsCardWidget(
                      title: strings.totalVolume,
                      value: _formatVolume(totalVolume),
                      subtitle: strings.kg,
                      icon: Icons.trending_up,
                      color: AppTheme.secondaryCyan,
                    ).animate(delay: 300.ms).fadeIn().scale(),
                    StatsCardWidget(
                      title: strings.averageTime,
                      value: '${avgDuration.toStringAsFixed(0)}',
                      subtitle: strings.minutes,
                      icon: Icons.timer,
                      color: AppTheme.primaryPurple,
                    ).animate(delay: 400.ms).fadeIn().scale(),
                  ],
                ),

                const SizedBox(height: 24),

                // Volume Progression Chart
                Text(
                  'Volume Progression',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate(delay: 500.ms).fadeIn(),

                const SizedBox(height: 12),

                GlassContainer(
                  padding: EdgeInsets.zero,
                  borderRadius: 20,
                  child: VolumeChartWidget(data: volumeData),
                ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),

                const SizedBox(height: 24),

                // Muscle Distribution Chart
                if (muscleData.isNotEmpty) ...[
                  Text(
                    'Muscle Focus',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate(delay: 700.ms).fadeIn(),

                  const SizedBox(height: 12),

                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 20,
                    child: MuscleDistributionChartWidget(data: muscleData),
                  ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.2),
                  
                  const SizedBox(height: 24),
                ],

                // Achievements Button
                GlassContainer(
                  padding: EdgeInsets.zero,
                  borderRadius: 16,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      strings.achievements,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '$unlockedCount / ${achievements.length} ${strings.achievementsUnlocked}',
                      style: TextStyle(
                        color: AppTheme.secondaryCyan,
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AchievementsScreen(
                            achievements: achievements,
                          ),
                        ),
                      );
                    },
                  ),
                ).animate(delay: 900.ms).fadeIn().slideX(begin: 0.2),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatVolume(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }

  int _calculateScore(
    int totalWorkouts,
    int currentStreak,
    double totalVolume,
    int totalSets,
  ) {
    int score = 0;

    // Workout frequency (max 30 points)
    if (totalWorkouts >= 100) {
      score += 30;
    } else if (totalWorkouts >= 50) {
      score += 20;
    } else if (totalWorkouts >= 20) {
      score += 15;
    } else if (totalWorkouts >= 10) {
      score += 10;
    } else if (totalWorkouts >= 1) {
      score += 5;
    }

    // Current streak (max 30 points)
    if (currentStreak >= 30) {
      score += 30;
    } else if (currentStreak >= 14) {
      score += 20;
    } else if (currentStreak >= 7) {
      score += 15;
    } else if (currentStreak >= 3) {
      score += 10;
    } else if (currentStreak >= 1) {
      score += 5;
    }

    // Volume (max 20 points)
    if (totalVolume >= 50000) {
      score += 20;
    } else if (totalVolume >= 25000) {
      score += 15;
    } else if (totalVolume >= 10000) {
      score += 10;
    } else if (totalVolume >= 5000) {
      score += 5;
    }

    // Sets (max 20 points)
    if (totalSets >= 1000) {
      score += 20;
    } else if (totalSets >= 500) {
      score += 15;
    } else if (totalSets >= 250) {
      score += 10;
    } else if (totalSets >= 100) {
      score += 5;
    }

    return score.clamp(0, 100);
  }
}
