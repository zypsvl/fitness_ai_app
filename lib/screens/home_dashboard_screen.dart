import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/streak_widget.dart';
import '../widgets/streak_flame_widget.dart';
import '../widgets/level_progress_widget.dart';
import '../widgets/water_tracker_widget.dart';
import '../widgets/nutrition_tracker_widget.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import 'onboarding_screen.dart';
import 'create_program_setup_screen.dart';
import 'onboarding_screen.dart';
import 'my_programs_screen.dart';
import 'result_screen.dart';
import 'active_workout_screen.dart';
import 'progress_screen.dart';
import 'user_profile_screen.dart';
import 'body_measurements_screen.dart';
import 'statistics_screen.dart';
import 'achievements_screen.dart';
import '../widgets/firebase_test_widget.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);
    final strings = AppStrings(context);
    final recentPrograms = provider.savedPrograms.reversed.take(3).toList();
    final totalPrograms = provider.savedPrograms.length;

    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Enhanced Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.welcome,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white70,
                                ),
                              ).animate().fadeIn().slideX(begin: -0.2),
                              Text(
                                "Let's crush it! 💪",
                                style: Theme.of(context).textTheme.displayMedium,
                              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
                              const SizedBox(height: 8),
                              const StreakFlameWidget().animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserProfileScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppTheme.primaryGradient,
                                boxShadow: AppTheme.neonShadow(AppTheme.primaryPurple),
                              ),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: AppTheme.backgroundDark,
                                child: const Icon(Icons.person, color: Colors.white),
                              ),
                            ),
                          ).animate().fadeIn(delay: 200.ms).scale(),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Hero Stats Section
                      SizedBox(
                        height: 140,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            _buildHeroStatCard(
                              context,
                              icon: Icons.local_fire_department,
                              value: "${provider.streakData.currentStreak}",
                              label: provider.isStreakAtRisk() ? "At Risk!" : "Day Streak",
                              color: provider.isStreakAtRisk() ? Colors.red : AppTheme.accentOrange,
                              delay: 300,
                            ),
                            const SizedBox(width: 16),
                            _buildHeroStatCard(
                              context,
                              icon: Icons.fitness_center,
                              value: "$totalPrograms",
                              label: "Programs",
                              color: AppTheme.primaryPurple,
                              delay: 400,
                            ),
                            const SizedBox(width: 16),
                            _buildHeroStatCard(
                              context,
                              icon: Icons.check_circle,
                              value: "${provider.getWeeklyWorkoutCount()}",
                              label: "Workouts",
                              color: AppTheme.neonGreen,
                              delay: 500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Quick Actions Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildListDelegate([
                    _buildQuickActionCard(
                      context,
                      title: strings.createNewProgram,
                      icon: Icons.add_circle_outline,
                      gradient: AppTheme.primaryGradient,
                      onTap: () => _showCreateOptions(context),
                      delay: 600,
                    ),
                    if (provider.weeklyPlan.isNotEmpty)
                      _buildQuickActionCard(
                        context,
                        title: "Quick Start",
                        icon: Icons.play_arrow_rounded,
                        gradient: AppTheme.accentGradient,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ActiveWorkoutScreen(
                              workoutDay: provider.weeklyPlan[0],
                              programId: 'current',
                              programName: 'Current',
                            ),
                          ),
                        ),
                        delay: 700,
                      )
                    else
                      _buildQuickActionCard(
                        context,
                        title: strings.myPrograms,
                        icon: Icons.list_alt,
                        gradient: AppTheme.accentGradient,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MyProgramsScreen()),
                        ),
                        delay: 700,
                      ),
                    _buildQuickActionCard(
                      context,
                      title: strings.statistics,
                      icon: Icons.bar_chart,
                      gradient: AppTheme.pinkGradient,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                      ),
                      delay: 800,
                    ),
                    _buildQuickActionCard(
                      context,
                      title: strings.bodyMeasurements,
                      icon: Icons.monitor_weight,
                      gradient: AppTheme.secondaryGradient,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BodyMeasurementsScreen()),
                      ),
                      delay: 900,
                    ),
                  ]),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // Recent Programs
              if (recentPrograms.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          strings.recentPrograms,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MyProgramsScreen()),
                          ),
                          child: Text(
                            strings.viewAll,
                            style: TextStyle(color: AppTheme.secondaryCyan),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 800.ms),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final program = recentPrograms[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildProgramCard(context, program, index),
                        );
                      },
                      childCount: recentPrograms.length,
                    ),
                  ),
                ),
              ],

              // Water Tracker
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: const WaterTrackerWidget()
                      .animate().fadeIn(delay: 900.ms).slideY(begin: 0.2),
                ),
              ),

              // Nutrition Tracker
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: const NutritionTrackerWidget()
                      .animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required int delay,
  }) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.2);
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
    required int delay,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.neonShadow(gradient.colors.first),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                icon,
                size: 100,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).scale();
  }

  Widget _buildProgramCard(BuildContext context, dynamic program, int index) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.neonShadow(AppTheme.primaryPurple, opacity: 0.3),
            ),
            child: const Icon(Icons.fitness_center, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${program.daysPerWeek} Days • ${program.goal}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white.withValues(alpha: 0.3), size: 16),
        ],
      ),
    ).animate().fadeIn(delay: ((index + 8) * 100).ms).slideX(begin: 0.2);
  }

  void _showCreateOptions(BuildContext context) {
    final strings = AppStrings(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              strings.createProgramTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionTile(
              context,
              icon: Icons.auto_awesome,
              title: strings.createWithAI,
              subtitle: strings.createWithAIDesc,
              color: AppTheme.primaryPurple,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildOptionTile(
              context,
              icon: Icons.edit_note,
              title: strings.createManually,
              subtitle: strings.createManuallyDesc,
              color: AppTheme.secondaryCyan,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateProgramSetupScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withValues(alpha: 0.3), size: 16),
          ],
        ),
      ),
    );
  }
}

