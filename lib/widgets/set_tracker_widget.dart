import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme_config.dart';
import '../models/weekly_plan_model.dart';
import 'glass_container.dart';

/// Widget for tracking individual sets during a workout
class SetTrackerWidget extends StatefulWidget {
  final ScheduledExercise exercise;
  final int currentSetIndex;
  final List<SetData> completedSets;
  final Function(SetData) onSetComplete;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const SetTrackerWidget({
    super.key,
    required this.exercise,
    required this.currentSetIndex,
    required this.completedSets,
    required this.onSetComplete,
    this.onPrevious,
    this.onNext,
  });

  @override
  State<SetTrackerWidget> createState() => _SetTrackerWidgetState();
}

class _SetTrackerWidgetState extends State<SetTrackerWidget> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _completeSet() {
    final weight = double.tryParse(_weightController.text);
    final reps = int.tryParse(_repsController.text);

    if (reps == null || reps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir tekrar sayısı girin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onSetComplete(SetData(
      setNumber: widget.currentSetIndex + 1,
      weight: weight,
      reps: reps,
    ));

    // Clear inputs
    _weightController.clear();
    _repsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSets = int.tryParse(widget.exercise.sets) ?? 3;

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise info
          Row(
            children: [
              // Exercise GIF
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: AppTheme.primaryGradient,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.exercise.exercise.assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.fitness_center,
                        color: Colors.white,
                        size: 30,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Exercise name and target
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exercise.exercise.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.exercise.sets} Set × ${widget.exercise.reps}',
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

          const SizedBox(height: 20),

          // Set progress
          Text(
            'SET ${widget.currentSetIndex + 1}/$totalSets',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryPurple,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Completed sets
          if (widget.completedSets.isNotEmpty) ...[
            Text(
              'Tamamlanan Setler:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...widget.completedSets.asMap().entries.map((entry) {
              final set = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.secondaryCyan,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Set ${set.setNumber}: ${set.weight != null ? '${set.weight}kg × ' : ''}${set.reps} tekrar',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],

          // Input fields
          if (widget.currentSetIndex < totalSets) ...[
            Row(
              children: [
                // Weight input
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ağırlık (kg)',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Reps input
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tekrar',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _repsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.exercise.reps,
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Complete set button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _completeSet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryCyan,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Seti Tamamla',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // All sets completed message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppTheme.secondaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.celebration, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Tüm setler tamamlandı! 🎉',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Simple data class for set information
class SetData {
  final int setNumber;
  final double? weight;
  final int reps;

  SetData({
    required this.setNumber,
    this.weight,
    required this.reps,
  });
}
