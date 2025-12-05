import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../models/workout_session_model.dart';
import '../models/workout_progress_model.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/progress_calendar_widget.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';

class ProgressScreen extends StatefulWidget {
  final String? programId;

  const ProgressScreen({super.key, this.programId});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);
    final theme = Theme.of(context);
    final strings = AppStrings(context);

    // Get workout history
    final allWorkouts = provider.workoutHistory;
    final weeklyCount = provider.getWeeklyWorkoutCount();
    final monthlyCount = provider.getMonthlyWorkoutCount();

    // Build completed days map for calendar
    final completedDays = <DateTime, bool>{};
    for (final workout in allWorkouts) {
      if (workout.isCompleted) {
        final date = DateTime(
          workout.startTime.year,
          workout.startTime.month,
          workout.startTime.day,
        );
        completedDays[date] = true;
      }
    }

    // Calculate current streak
    int currentStreak = 0;
    if (allWorkouts.isNotEmpty) {
      final sortedWorkouts = allWorkouts.where((w) => w.isCompleted).toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));

      if (sortedWorkouts.isNotEmpty) {
        final now = DateTime.now();
        final lastWorkout = sortedWorkouts.first.startTime;
        final daysDiff = now.difference(lastWorkout).inDays;

        if (daysDiff <= 1) {
          currentStreak = 1;
          DateTime checkDate = lastWorkout;

          for (int i = 1; i < sortedWorkouts.length; i++) {
            final prevWorkout = sortedWorkouts[i];
            final diff = checkDate.difference(prevWorkout.startTime).inDays;

            if (diff == 1 || diff == 0) {
              if (diff == 1) currentStreak++;
              checkDate = prevWorkout.startTime;
            } else {
              break;
            }
          }
        }
      }
    }

    // Calculate total volume this month
    double totalVolume = 0;
    int totalSets = 0;
    for (final workout in allWorkouts) {
      if (workout.startTime.month == _currentMonth.month &&
          workout.startTime.year == _currentMonth.year) {
        totalVolume += workout.totalVolume;
        totalSets += workout.totalSets;
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.progress),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Streak Card
                GlassContainer(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 20,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: AppTheme.neonShadow(
                            AppTheme.primaryPurple,
                            opacity: 0.4,
                          ),
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.currentStreak,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$currentStreak ${strings.days}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        currentStreak > 0 ? Icons.trending_up : Icons.trending_flat,
                        color: currentStreak > 0
                            ? AppTheme.secondaryCyan
                            : Colors.white54,
                        size: 32,
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideX(begin: -0.2),

                // Stats Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        strings.thisWeek,
                        '$weeklyCount',
                        strings.workouts,
                        Icons.calendar_today,
                        AppTheme.secondaryCyan,
                      ).animate(delay: 100.ms).fadeIn().scale(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        strings.thisMonth,
                        '$monthlyCount',
                        strings.workouts,
                        Icons.calendar_month,
                        AppTheme.primaryPurple,
                      ).animate(delay: 200.ms).fadeIn().scale(),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        strings.totalSets,
                        '$totalSets',
                        strings.thisMonth,
                        Icons.fitness_center,
                        AppTheme.accentOrange,
                      ).animate(delay: 300.ms).fadeIn().scale(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        strings.totalVolume,
                        '${totalVolume.toStringAsFixed(0)} ${strings.kg}',
                        strings.thisMonth,
                        Icons.trending_up,
                        AppTheme.secondaryCyan,
                      ).animate(delay: 400.ms).fadeIn().scale(),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Calendar Section
                Text(
                  strings.workoutCalendar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate(delay: 500.ms).fadeIn(),

                const SizedBox(height: 12),

                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 20,
                  child: Column(
                    children: [
                      // Month navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _currentMonth = DateTime(
                                  _currentMonth.year,
                                  _currentMonth.month - 1,
                                );
                              });
                            },
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '${strings.getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _currentMonth = DateTime(
                                  _currentMonth.year,
                                  _currentMonth.month + 1,
                                );
                              });
                            },
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),

                      // Calendar
                      ProgressCalendarWidget(
                        completedDays: completedDays,
                        currentMonth: _currentMonth,
                      ),

                      const SizedBox(height: 16),

                      // Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem(
                            strings.completedLabel,
                            AppTheme.secondaryCyan.withValues(alpha: 0.3),
                          ),
                          const SizedBox(width: 20),
                          _buildLegendItem(
                            strings.today,
                            Colors.transparent,
                            borderColor: AppTheme.primaryPurple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),

                const SizedBox(height: 24),

                // Recent Workouts
                if (allWorkouts.isNotEmpty) ...[
                  Text(
                    strings.recentWorkouts,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate(delay: 700.ms).fadeIn(),

                  const SizedBox(height: 12),

                  ...allWorkouts.take(5).map((workout) {
                    return _buildWorkoutCard(workout, strings)
                        .animate(delay: 800.ms)
                        .fadeIn()
                        .slideX(begin: 0.2);
                  }),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, {Color? borderColor}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: borderColor != null
                ? Border.all(color: borderColor, width: 2)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutCard(WorkoutSession workout, AppStrings strings) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.getBodyPart(workout.focus),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${workout.totalSets} ${strings.set} • ${workout.totalReps} ${strings.rep}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(workout.startTime, strings),
                style: TextStyle(
                  color: AppTheme.secondaryCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDuration(workout.duration, strings),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, AppStrings strings) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return strings.today;
    if (diff == 1) return strings.yesterday;
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDuration(Duration duration, AppStrings strings) {
    final minutes = duration.inMinutes;
    return '$minutes ${strings.minutes}';
  }
}
