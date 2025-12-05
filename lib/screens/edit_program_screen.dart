import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../models/weekly_plan_model.dart';
import '../models/exercise_model.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import 'exercise_picker_screen.dart';
import 'result_screen.dart';

class EditProgramScreen extends StatefulWidget {
  final String programId;

  const EditProgramScreen({
    super.key,
    required this.programId,
  });

  @override
  State<EditProgramScreen> createState() => _EditProgramScreenState();
}

class _EditProgramScreenState extends State<EditProgramScreen> {
  late List<WorkoutDay> _editedPlan;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    // Create a deep copy of the plan
    _editedPlan = List.from(provider.weeklyPlan);
  }

  Future<void> _replaceExercise(
    int dayIndex,
    int exerciseIndex,
    BuildContext context,
  ) async {
    final currentExercise = _editedPlan[dayIndex].exercises[exerciseIndex];

    final selectedExercise = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(
        builder: (_) => ExercisePickerScreen(
          targetMuscle: currentExercise.exercise.primaryMuscle,
          currentEquipment: currentExercise.exercise.equipmentTier,
        ),
      ),
    );

    if (selectedExercise != null && mounted) {
      setState(() {
        final updatedExercises = List<ScheduledExercise>.from(
          _editedPlan[dayIndex].exercises,
        );
        updatedExercises[exerciseIndex] = ScheduledExercise(
          exercise: selectedExercise,
          sets: currentExercise.sets,
          reps: currentExercise.reps,
        );

        _editedPlan[dayIndex] = WorkoutDay(
          dayName: _editedPlan[dayIndex].dayName,
          focus: _editedPlan[dayIndex].focus,
          exercises: updatedExercises,
        );

        _hasChanges = true;
      });

      final strings = AppStrings(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.replacedWith(selectedExercise.name)),
          backgroundColor: AppTheme.secondaryCyan,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _editSetsReps(
    int dayIndex,
    int exerciseIndex,
    BuildContext context,
  ) async {
    final currentExercise = _editedPlan[dayIndex].exercises[exerciseIndex];
    final setsController = TextEditingController(text: currentExercise.sets);
    final repsController = TextEditingController(text: currentExercise.reps);

    final strings = AppStrings(context);
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          strings.editSetsReps,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: setsController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: strings.setCount,
                labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: repsController,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: strings.repsCount,
                labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'sets': setsController.text,
                'reps': repsController.text,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
            ),
            child: Text(strings.save),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      setState(() {
        final updatedExercises = List<ScheduledExercise>.from(
          _editedPlan[dayIndex].exercises,
        );
        updatedExercises[exerciseIndex] = ScheduledExercise(
          exercise: currentExercise.exercise,
          sets: result['sets']!,
          reps: result['reps']!,
        );

        _editedPlan[dayIndex] = WorkoutDay(
          dayName: _editedPlan[dayIndex].dayName,
          focus: _editedPlan[dayIndex].focus,
          exercises: updatedExercises,
        );

        _hasChanges = true;
      });
    }
  }

  void _deleteExercise(int dayIndex, int exerciseIndex) {
    final strings = AppStrings(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          strings.deleteExercise,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          strings.deleteExerciseConfirm,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final updatedExercises = List<ScheduledExercise>.from(
                  _editedPlan[dayIndex].exercises,
                );
                updatedExercises.removeAt(exerciseIndex);

                _editedPlan[dayIndex] = WorkoutDay(
                  dayName: _editedPlan[dayIndex].dayName,
                  focus: _editedPlan[dayIndex].focus,
                  exercises: updatedExercises,
                );

                _hasChanges = true;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    provider.updateWeeklyPlan(_editedPlan);
    
    // Navigate to ResultScreen so user can view and save the program
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ResultScreen(),
      ),
    );

    final strings = AppStrings(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.programUpdated),
        backgroundColor: AppTheme.secondaryCyan,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final strings = AppStrings(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          strings.saveChanges,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          strings.unsavedChangesConfirm,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              strings.dontSave,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
              _saveChanges();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
            ),
            child: Text(strings.save),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final strings = AppStrings(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(strings.editProgram),
          actions: [
            if (_hasChanges)
              TextButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.check, color: Colors.white),
                label: Text(
                  strings.save,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
        body: AnimatedGradientBackground(
          child: SafeArea(
            child: DefaultTabController(
              length: _editedPlan.length,
              child: Column(
                children: [
                  // Day tabs
                  TabBar(
                    isScrollable: true,
                    indicatorColor: AppTheme.primaryPurple,
                    tabs: _editedPlan.map((day) {
                      return Tab(text: day.dayName);
                    }).toList(),
                  ),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      children: _editedPlan.asMap().entries.map((entry) {
                        final dayIndex = entry.key;
                        final day = entry.value;

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: day.exercises.length + 1,
                          itemBuilder: (context, index) {
                            if (index == day.exercises.length) {
                              // Add exercise button
                              return GlassContainer(
                                padding: const EdgeInsets.all(20),
                                borderRadius: 16,
                                margin: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () async {
                                    final selectedExercise =
                                        await Navigator.push<Exercise>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ExercisePickerScreen(),
                                      ),
                                    );

                                    if (selectedExercise != null && mounted) {
                                      setState(() {
                                        final updatedExercises =
                                            List<ScheduledExercise>.from(
                                          day.exercises,
                                        );
                                        updatedExercises.add(ScheduledExercise(
                                          exercise: selectedExercise,
                                          sets: '3',
                                          reps: '8-10',
                                        ));

                                        _editedPlan[dayIndex] = WorkoutDay(
                                          dayName: day.dayName,
                                          focus: day.focus,
                                          exercises: updatedExercises,
                                        );

                                        _hasChanges = true;
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: AppTheme.secondaryCyan,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        strings.addExercise,
                                        style: TextStyle(
                                          color: AppTheme.secondaryCyan,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final exercise = day.exercises[index];
                            return _buildExerciseCard(
                              exercise,
                              dayIndex,
                              index,
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    ScheduledExercise exercise,
    int dayIndex,
    int exerciseIndex,
  ) {
    final strings = AppStrings(context);
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      borderRadius: 16,
      child: Column(
        children: [
          Row(
            children: [
              // GIF
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: AppTheme.primaryGradient,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    exercise.exercise.assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.fitness_center,
                        color: Colors.white.withValues(alpha: 0.5),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.exercise.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${exercise.sets} ${strings.sets} × ${exercise.reps}',
                      style: TextStyle(
                        color: AppTheme.secondaryCyan,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _replaceExercise(dayIndex, exerciseIndex, context),
                  icon: const Icon(Icons.swap_horiz, size: 18),
                  label: Text(strings.replace),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.secondaryCyan,
                    side: BorderSide(color: AppTheme.secondaryCyan),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _editSetsReps(dayIndex, exerciseIndex, context),
                  icon: const Icon(Icons.edit, size: 18),
                  label: Text(strings.setsReps),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryPurple,
                    side: BorderSide(color: AppTheme.primaryPurple),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _deleteExercise(dayIndex, exerciseIndex),
                icon: const Icon(Icons.delete_outline),
                color: Colors.red.shade300,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.2);
  }
}
