import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/weekly_plan_model.dart';
import '../models/workout_session_model.dart';
import '../providers/workout_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/set_tracker_widget.dart';
import '../widgets/rest_timer_widget.dart';
import '../widgets/rest_timer_bottom_sheet.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import '../services/share_service.dart';
import '../widgets/shareable_stats_card.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final WorkoutDay workoutDay;
  final String programId;
  final String programName;
  final int? startExerciseIndex;
  final bool singleExerciseMode;

  const ActiveWorkoutScreen({
    super.key,
    required this.workoutDay,
    required this.programId,
    required this.programName,
    this.startExerciseIndex,
    this.singleExerciseMode = false,
  });

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  late WorkoutSession _session;
  int _currentExerciseIndex = 0;
  List<SetData> _currentSets = [];
  bool _showRestTimer = false;
  int _restDuration = 90; // Default rest duration
  bool _isWorkoutCompleted = false;

  @override
  void initState() {
    super.initState();
    _currentExerciseIndex = widget.startExerciseIndex ?? 0;
    _session = WorkoutSession.create(
      programId: widget.programId,
      programName: widget.programName,
      dayName: widget.workoutDay.dayName,
      focus: widget.workoutDay.focus,
    );
  }

  ScheduledExercise get _currentExercise =>
      widget.workoutDay.exercises[_currentExerciseIndex];

  int get _totalSets => int.tryParse(_currentExercise.sets) ?? 3;

  bool get _isExerciseCompleted => _currentSets.length >= _totalSets;

  bool get _isLastExercise =>
      _currentExerciseIndex >= widget.workoutDay.exercises.length - 1;

  void _onSetComplete(SetData setData) {
    // Mark exercise as in-progress when first set is completed
    if (_currentSets.isEmpty) {
      final provider = Provider.of<WorkoutProvider>(context, listen: false);
      provider.markExerciseInProgress(widget.workoutDay.dayName, _currentExerciseIndex);
    }

    setState(() {
      _currentSets.add(setData);

      // Add to session
      _session = _session.addSet(
        CompletedSet(
          exerciseId: _currentExercise.exercise.id,
          setNumber: setData.setNumber,
          weight: setData.weight,
          reps: setData.reps,
          timestamp: DateTime.now(),
        ),
      );
    });

    // Show rest timer or completion based on progress
    if (!_isExerciseCompleted) {
      // Show bottom sheet to let user select rest duration
      _showRestTimerSelection();
    } else if (widget.singleExerciseMode) {
      // Single exercise mode - finish immediately
      _completeSingleExercise();
    } else if (!_isLastExercise) {
      // Exercise completed, move to next
      _showCompletionMessage();
    } else {
      // Workout completed!
      _completeWorkout();
    }
  }

  void _showRestTimerSelection() {
    showRestTimerBottomSheet(
      context: context,
      onSkip: () {
        // User skipped rest, ready for next set
        setState(() {
          _showRestTimer = false;
        });
      },
      onStartTimer: (duration) {
        // User selected duration, start timer
        setState(() {
          _showRestTimer = true;
          _restDuration = duration;
        });
      },
    );
  }

  void _completeSingleExercise() {
    // Mark as complete in provider
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    provider.markExerciseComplete(widget.workoutDay.dayName, _currentExerciseIndex);
    
    // Save session data even for single exercise
    provider.saveWorkoutSession(_session);

    final strings = AppStrings(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('${_currentExercise.exercise.name} ${strings.completed}'),
          ],
        ),
        backgroundColor: AppTheme.neonGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Return to previous screen after short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _showCompletionMessage() {
    final strings = AppStrings(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('${_currentExercise.exercise.name} ${strings.completed}'),
          ],
        ),
        backgroundColor: AppTheme.secondaryCyan,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    // Auto-advance after short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _nextExercise();
      }
    });
  }

  void _nextExercise() {
    if (widget.singleExerciseMode) {
      _completeSingleExercise();
      return;
    }

    if (_currentExerciseIndex < widget.workoutDay.exercises.length - 1) {
      // Mark current exercise as complete before moving to next
      final provider = Provider.of<WorkoutProvider>(context, listen: false);
      provider.markExerciseComplete(widget.workoutDay.dayName, _currentExerciseIndex);

      setState(() {
        _currentExerciseIndex++;
        _currentSets = [];
        _showRestTimer = false;
      });
    } else {
      _completeWorkout();
    }
  }

  void _previousExercise() {
    if (widget.singleExerciseMode) {
      Navigator.pop(context);
      return;
    }

    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _currentSets = [];
        _showRestTimer = false;
      });
    }
  }

  void _completeWorkout() {
    // Mark last exercise as complete
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    provider.markExerciseComplete(widget.workoutDay.dayName, _currentExerciseIndex);

    setState(() {
      _isWorkoutCompleted = true;
      _session = _session.complete();
    });

    // Save workout to provider
    provider.saveWorkoutSession(_session);

    // Show completion dialog
    _showWorkoutCompletionDialog();
  }

  void _showWorkoutCompletionDialog() {
    final strings = AppStrings(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          borderRadius: 24,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.celebration,
                color: AppTheme.secondaryCyan,
                size: 64,
              ).animate().scale(duration: 500.ms).then().shimmer(duration: 1000.ms),
              const SizedBox(height: 20),
              Text(
                strings.workoutCompleted,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    _buildStat('⏱️', strings.duration, _formatDuration(_session.duration)),
                    const Divider(color: Colors.white24, height: 24),
                    _buildStat('💪', strings.sets, '${_session.totalSets}'),
                    const Divider(color: Colors.white24, height: 24),
                    _buildStat('🔥', strings.reps, '${_session.totalReps}'),
                    if (_session.totalVolume > 0) ...[
                      const Divider(color: Colors.white24, height: 24),
                      _buildStat('📊', strings.volume, '${_session.totalVolume.toStringAsFixed(0)} kg'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Close workout screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryCyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shadowColor: AppTheme.secondaryCyan.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    strings.complete,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    final shareService = ShareService();
                    shareService.shareWidget(
                      context: context,
                      subject: 'Workout Completed! 🚀',
                      text: 'I just crushed a ${_session.duration.inMinutes} min workout with GymGenius! 💪',
                      widget: ShareableStatsCard(
                        title: 'WORKOUT COMPLETED',
                        value: '${_session.duration.inMinutes} min',
                        subtitle: '${_session.totalSets} Sets • ${_session.totalReps} Reps',
                        icon: Icons.fitness_center,
                        color: AppTheme.secondaryCyan,
                      ),
                    );
                  },
                  icon: const Icon(Icons.share, color: Colors.white70),
                  label: const Text(
                    'Share Achievement',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String emoji, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$emoji $label',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<bool> _onWillPop() async {
    if (_isWorkoutCompleted) return true;

    final strings = AppStrings(context);
    final result = await showDialog<bool>(
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pause_circle_outline,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                strings.finishWorkout,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                strings.finishWorkoutConfirm,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        strings.continueWorkout,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.redAccent.shade400, Colors.redAccent.shade700],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          strings.finish,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppStrings(context);
    final progress = (_currentExerciseIndex + 1) / widget.workoutDay.exercises.length;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.getBodyPart(widget.workoutDay.focus),
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                '${strings.exercise} ${_currentExerciseIndex + 1}/${widget.workoutDay.exercises.length}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.secondaryCyan,
                  ),
                  minHeight: 6,
                ),
              ),
            ),
          ),
        ),
        body: AnimatedGradientBackground(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Set tracker
                        SetTrackerWidget(
                          exercise: _currentExercise,
                          currentSetIndex: _currentSets.length,
                          completedSets: _currentSets,
                          onSetComplete: _onSetComplete,
                        ).animate().fadeIn().slideY(begin: -0.1),

                        const SizedBox(height: 20),

                        // Rest timer
                        if (_showRestTimer) ...[
                          RestTimerWidget(
                            durationSeconds: _restDuration,
                            onComplete: () {
                              setState(() {
                                _showRestTimer = false;
                              });
                            },
                            onSkip: () {
                              setState(() {
                                _showRestTimer = false;
                              });
                            },
                          ).animate().fadeIn().scale(),
                          const SizedBox(height: 20),
                        ],

                        // Navigation buttons
                        if (_isExerciseCompleted && !_isLastExercise)
                            GlassContainer(
                            padding: const EdgeInsets.all(16),
                            borderRadius: 16,
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.secondaryCyan,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  strings.exerciseCompleted,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _nextExercise,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryPurple,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      '${strings.nextExercise} →',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn().scale(),
                      ],
                    ),
                  ),
                ),

                // Bottom navigation
                if (!_isWorkoutCompleted)
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous button
                        if (_currentExerciseIndex > 0)
                          TextButton.icon(
                            onPressed: _previousExercise,
                            icon: const Icon(Icons.arrow_back, color: Colors.white70),
                            label: Text(
                              strings.previous,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          )
                        else
                          const SizedBox(width: 80),

                        // Workout duration
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            final duration = DateTime.now().difference(_session.startTime);
                            return Text(
                              _formatDuration(duration),
                              style: const TextStyle(
                                color: AppTheme.secondaryCyan,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            );
                          },
                        ),

                        // Skip exercise button
                        if (!_isExerciseCompleted)
                          TextButton(
                            onPressed: _nextExercise,
                            child: Text(
                              strings.skip,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          )
                        else
                          const SizedBox(width: 80),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
