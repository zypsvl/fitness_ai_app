import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import 'onboarding_screen.dart';
import 'my_programs_screen.dart';
import 'result_screen.dart';
import 'active_workout_screen.dart';
import 'progress_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);
    final strings = AppStrings(context);
    // Show newest programs first by reversing the list
    final recentPrograms = provider.savedPrograms.reversed.take(3).toList();
    final totalPrograms = provider.savedPrograms.length;

    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.welcome,
                        style: Theme.of(context).textTheme.displayLarge,
                      ).animate().fadeIn().slideX(begin: -0.2),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        strings.readyForGoals,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Recent Programs Section
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyProgramsScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                strings.viewAll,
                                style: TextStyle(
                                  color: AppTheme.secondaryCyan,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: AppTheme.secondaryCyan,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms),
                  ),
                ),
                
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final program = recentPrograms[index];
                        return GlassContainer(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                            onTap: () {
                              provider.loadProgramById(program.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ResultScreen(),
                                ),
                              );
                            },
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
                                        program.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${program.daysPerWeek} ${strings.daysCount(program.daysPerWeek)} • ${program.goal}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: ((index + 3) * 100).ms).slideX(begin: 0.2);
                      },
                      childCount: recentPrograms.length,
                    ),
                  ),
                ),
              ],

              // Create New Program Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnboardingScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppTheme.glowShadow(
                          AppTheme.primaryPurple,
                          opacity: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_circle_outline,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            strings.createNewProgram,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            strings.customWorkoutProgram,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).scale(),
                ),
              ),

              // Workout Stats Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              color: AppTheme.secondaryCyan,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              strings.statistics,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat(
                              Icons.fitness_center,
                              "$totalPrograms",
                              totalPrograms == 1 ? strings.program : strings.programs,
                              AppTheme.primaryPurple,
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            _buildStat(
                              Icons.calendar_today,
                              "${provider.getWeeklyWorkoutCount()}",
                              strings.totalDays,
                              AppTheme.secondaryCyan,
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            _buildStat(
                              Icons.trending_up,
                              "${provider.getMonthlyWorkoutCount()}",
                              strings.exercises,
                              AppTheme.accentOrange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                ),
              ),

              // Quick Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      // My Programs
                      Expanded(
                        child: GlassContainer(
                          padding: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyProgramsScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.list_alt,
                                  color: AppTheme.secondaryCyan,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  strings.myPrograms,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: 600.ms).scale(),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Start Quick Workout (if has program)
                      if (provider.weeklyPlan.isNotEmpty)
                        Expanded(
                          child: GlassContainer(
                            padding: const EdgeInsets.all(20),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActiveWorkoutScreen(
                                      workoutDay: provider.weeklyPlan[0],
                                      programId: 'current',
                                      programName: 'Current',
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.primaryGradient,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Quick Start',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(delay: 700.ms).scale(),
                        ),
                      
                      const SizedBox(width: 12),
                      
                      // Progress Button
                      Expanded(
                        child: GlassContainer(
                          padding: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProgressScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: AppTheme.accentOrange,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'İlerleme',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: 800.ms).scale(),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
