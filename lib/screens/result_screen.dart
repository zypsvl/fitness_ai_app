import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../models/weekly_plan_model.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/save_program_dialog.dart';
import 'active_workout_screen.dart';
import 'edit_program_screen.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);
    final plan = provider.weeklyPlan;
    final strings = AppStrings(context);

    if (plan.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.error)),
        body: Center(child: Text(strings.programLoadError)),
      );
    }

    return DefaultTabController(
      length: plan.length,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(strings.programReady),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppTheme.neonShadow(AppTheme.primaryPurple, opacity: 0.4),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: plan.map((day) => Tab(text: strings.getDayName(day.dayName))).toList(),
              ),
            ),
          ),
        ),
        body: AnimatedGradientBackground(
          child: SafeArea(
            child: TabBarView(
              children: plan.asMap().entries.map((entry) {
                return _buildDayPage(context, provider, entry.value, entry.key, strings);
              }).toList(),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Start Button
            FloatingActionButton(
              heroTag: 'startWorkout',
              onPressed: () {
                if (plan.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActiveWorkoutScreen(
                        workoutDay: plan[0],
                        programId: 'current',
                        programName: 'Current Program',
                      ),
                    ),
                  );
                }
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.green.shade700],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.neonShadow(Colors.green, opacity: 0.5),
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
              ),
            ).animate().fadeIn(delay: 400.ms).scale(),
            
            const SizedBox(height: 12),
            
            // Edit Button
            FloatingActionButton(
              heroTag: 'editProgram',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProgramScreen(programId: 'current'),
                  ),
                );
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.accentOrange, AppTheme.accentOrange.withValues(alpha: 0.8)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.neonShadow(AppTheme.accentOrange, opacity: 0.5),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 24),
              ),
            ).animate().fadeIn(delay: 450.ms).scale(),
            
            const SizedBox(height: 12),
            
            // Save Button (only if not saved)
            if (!provider.isCurrentProgramSaved)
              FloatingActionButton(
                heroTag: 'saveProgram',
                onPressed: () async {
                  final result = await showDialog<String>(
                    context: context,
                    builder: (_) => SaveProgramDialog(
                      initialName: provider.currentProgramName,
                    ),
                  );
                  
                  if (result != null && result.isNotEmpty && context.mounted) {
                    final success = await provider.saveCurrentProgram(result);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Program kaydedildi!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      
                      // Navigate back to home screen
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  }
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.neonShadow(AppTheme.primaryPurple, opacity: 0.5),
                  ),
                  child: const Icon(Icons.save, color: Colors.white, size: 24),
                ),
              ).animate().fadeIn(delay: 500.ms).scale(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayPage(BuildContext context, WorkoutProvider provider, WorkoutDay day, int dayIndex, AppStrings strings) {
    // Check if it's a rest day
    if (day.isRestDay) {
      return Center(
        child: GlassContainer(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          borderRadius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.secondaryCyan.withValues(alpha: 0.3), AppTheme.primaryPurple.withValues(alpha: 0.3)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bed,
                  size: 64,
                  color: AppTheme.secondaryCyan,
                ),
              ).animate().scale(duration: 600.ms),
              
              const SizedBox(height: 24),
              
              Text(
                strings.restDay,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),
              
              const SizedBox(height: 16),
              
              Text(
                strings.restDayMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),
              
              const SizedBox(height: 32),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.secondaryCyan.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.secondaryCyan, size: 20),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        strings.restDayTip,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.secondaryCyan,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
            ],
          ),
        ),
      );
    }
    
    // Regular workout day
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Day Focus Header
        GlassContainer(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          borderRadius: 20,
          margin: const EdgeInsets.only(bottom: 20),
          boxShadow: AppTheme.neonShadow(AppTheme.secondaryCyan, opacity: 0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fitness_center,
                color: AppTheme.secondaryCyan,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                strings.getBodyPart(day.focus).toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryCyan,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.2),

        // Exercise Cards
        ...day.exercises.asMap().entries.map((entry) {
          final index = entry.key;
          final scheduledEx = entry.value;
          final ex = scheduledEx.exercise;

          final isCompleted = provider.isExerciseCompleted(day.dayName, index);
          final isInProgress = provider.isExerciseInProgress(day.dayName, index);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActiveWorkoutScreen(
                        workoutDay: day,
                        programId: 'current',
                        programName: 'Current Program',
                        startExerciseIndex: index,
                        singleExerciseMode: true,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: GlassContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 16,
                  child: Row(
                    children: [
                      // GIF Container
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: AppTheme.primaryGradient,
                          boxShadow: AppTheme.neonShadow(AppTheme.primaryPurple, opacity: 0.3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            ex.assetPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.withValues(alpha: 0.3),
                                      Colors.orange.withValues(alpha: 0.3),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white54,
                                  size: 32,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Exercise Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ex.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppTheme.secondaryGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${scheduledEx.sets} Set × ${scheduledEx.reps}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status Icon (Yellow for in-progress, Green for completed)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted 
                              ? Colors.green 
                              : isInProgress 
                                  ? Colors.amber.shade700
                                  : Colors.transparent,
                          border: Border.all(
                            color: isCompleted 
                                ? Colors.green 
                                : isInProgress
                                    ? Colors.amber.shade700
                                    : Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: isCompleted 
                              ? AppTheme.neonShadow(Colors.green, opacity: 0.5) 
                              : isInProgress
                                  ? AppTheme.neonShadow(Colors.amber.shade700, opacity: 0.5)
                                  : null,
                        ),
                        child: Icon(
                          isCompleted ? Icons.check : isInProgress ? Icons.more_horiz : Icons.check,
                          color: isCompleted || isInProgress 
                              ? Colors.white 
                              : Colors.white.withValues(alpha: 0.3),
                          size: 20,
                        ),
                      ).animate(target: (isCompleted || isInProgress) ? 1 : 0).scale(
                        duration: 300.ms,
                        curve: Curves.elasticOut,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: ((index + 1) * 100).ms)
              .slideX(begin: 0.2);
        }),

        // Summary Card
        const SizedBox(height: 20),
        GlassContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: 16,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(
                    Icons.fitness_center,
                    "${day.exercises.length}",
                    strings.exercises,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  _buildStat(
                    Icons.repeat,
                    "${day.exercises.fold<int>(0, (sum, e) => sum + (int.tryParse(e.sets) ?? 0))}",
                    strings.totalSets,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  _buildStat(
                    Icons.timer,
                    "~45",
                    strings.minutes,
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 500.ms).scale(),
      ],
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryPurple, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
