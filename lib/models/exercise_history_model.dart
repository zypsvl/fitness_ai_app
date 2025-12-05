class SetData {
  final int setNumber;
  final double weight;
  final int reps;
  final bool completed;

  SetData({
    required this.setNumber,
    required this.weight,
    required this.reps,
    this.completed = true,
  });

  double get volume => weight * reps;

  factory SetData.fromJson(Map<String, dynamic> json) {
    return SetData(
      setNumber: json['setNumber'] as int,
      weight: (json['weight'] as num).toDouble(),
      reps: json['reps'] as int,
      completed: json['completed'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setNumber': setNumber,
      'weight': weight,
      'reps': reps,
      'completed': completed,
    };
  }
}

class ExerciseHistory {
  final String exerciseId;
  final String exerciseName;
  final DateTime workoutDate;
  final List<SetData> sets;
  final String? notes;
  final int? rpe; // Rate of Perceived Exertion (1-10)
  final String programId;
  final String dayName;

  ExerciseHistory({
    required this.exerciseId,
    required this.exerciseName,
    required this.workoutDate,
    required this.sets,
    this.notes,
    this.rpe,
    required this.programId,
    required this.dayName,
  });

  // Calculate total volume for this workout
  double get totalVolume {
    return sets.fold(0.0, (sum, set) => sum + set.volume);
  }

  // Get average weight across all sets
  double get averageWeight {
    if (sets.isEmpty) return 0.0;
    final totalWeight = sets.fold(0.0, (sum, set) => sum + set.weight);
    return totalWeight / sets.length;
  }

  // Get average reps across all sets
  double get averageReps {
    if (sets.isEmpty) return 0.0;
    final totalReps = sets.fold(0, (sum, set) => sum + set.reps);
    return totalReps / sets.length;
  }

  // Get the heaviest set
  SetData? get heaviestSet {
    if (sets.isEmpty) return null;
    return sets.reduce((a, b) => a.weight > b.weight ? a : b);
  }

  // Get the highest rep set
  SetData? get highestRepSet {
    if (sets.isEmpty) return null;
    return sets.reduce((a, b) => a.reps > b.reps ? a : b);
  }

  // Get suggestion for next workout
  String getSuggestion({ExerciseHistory? previousWorkout}) {
    if (previousWorkout == null || sets.isEmpty) {
      return 'Complete all sets with good form';
    }

    final prevHeaviest = previousWorkout.heaviestSet;
    final currentHeaviest = heaviestSet;

    if (prevHeaviest == null || currentHeaviest == null) {
      return 'Track your performance';
    }

    // If weight increased
    if (currentHeaviest.weight > prevHeaviest.weight) {
      return 'Great! Try to maintain ${currentHeaviest.weight}kg';
    }

    // If reps increased at same weight
    if (currentHeaviest.weight == prevHeaviest.weight &&
        currentHeaviest.reps > prevHeaviest.reps) {
      if (currentHeaviest.reps >= 12) {
        return 'Try +2.5kg at 8-10 reps';
      }
      return 'Try +1 more rep';
    }

    // If performance declined
    if (currentHeaviest.weight < prevHeaviest.weight ||
        (currentHeaviest.weight == prevHeaviest.weight &&
            currentHeaviest.reps < prevHeaviest.reps)) {
      return 'Rest well, you got this!';
    }

    // Standard progression
    return 'Try +2.5kg or +1 rep';
  }

  // Factory constructor from JSON
  factory ExerciseHistory.fromJson(Map<String, dynamic> json) {
    return ExerciseHistory(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      workoutDate: DateTime.parse(json['workoutDate'] as String),
      sets: (json['sets'] as List<dynamic>)
          .map((e) => SetData.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      rpe: json['rpe'] as int?,
      programId: json['programId'] as String,
      dayName: json['dayName'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'workoutDate': workoutDate.toIso8601String(),
      'sets': sets.map((e) => e.toJson()).toList(),
      'notes': notes,
      'rpe': rpe,
      'programId': programId,
      'dayName': dayName,
    };
  }

  @override
  String toString() {
    return 'ExerciseHistory(exercise: $exerciseName, date: $workoutDate, sets: ${sets.length}, volume: ${totalVolume}kg)';
  }
}
