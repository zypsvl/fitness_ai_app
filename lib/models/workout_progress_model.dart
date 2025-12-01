/// Tracks user's workout progress and statistics
class WorkoutProgress {
  final String programId;
  final int totalWorkouts;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastWorkoutDate;
  final Map<String, int> weeklyCompletion; // day name -> count
  final List<PersonalRecord> personalRecords;

  WorkoutProgress({
    required this.programId,
    this.totalWorkouts = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastWorkoutDate,
    this.weeklyCompletion = const {},
    this.personalRecords = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'programId': programId,
      'totalWorkouts': totalWorkouts,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastWorkoutDate': lastWorkoutDate?.toIso8601String(),
      'weeklyCompletion': weeklyCompletion,
      'personalRecords': personalRecords.map((pr) => pr.toJson()).toList(),
    };
  }

  factory WorkoutProgress.fromJson(Map<String, dynamic> json) {
    return WorkoutProgress(
      programId: json['programId'] as String,
      totalWorkouts: json['totalWorkouts'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastWorkoutDate: json['lastWorkoutDate'] != null
          ? DateTime.parse(json['lastWorkoutDate'] as String)
          : null,
      weeklyCompletion: Map<String, int>.from(json['weeklyCompletion'] ?? {}),
      personalRecords: (json['personalRecords'] as List?)
              ?.map((pr) => PersonalRecord.fromJson(pr as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  WorkoutProgress copyWith({
    String? programId,
    int? totalWorkouts,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastWorkoutDate,
    Map<String, int>? weeklyCompletion,
    List<PersonalRecord>? personalRecords,
  }) {
    return WorkoutProgress(
      programId: programId ?? this.programId,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      weeklyCompletion: weeklyCompletion ?? this.weeklyCompletion,
      personalRecords: personalRecords ?? this.personalRecords,
    );
  }

  /// Update progress after completing a workout
  WorkoutProgress afterWorkout(String dayName, DateTime workoutDate) {
    // Calculate new streak
    int newStreak = currentStreak;
    if (lastWorkoutDate != null) {
      final daysDiff = workoutDate.difference(lastWorkoutDate!).inDays;
      if (daysDiff == 1) {
        newStreak = currentStreak + 1;
      } else if (daysDiff == 0) {
        newStreak = currentStreak; // Same day, don't break streak
      } else {
        newStreak = 1; // Streak broken, start fresh
      }
    } else {
      newStreak = 1; // First workout
    }

    // Update weekly completion
    final newWeekly = Map<String, int>.from(weeklyCompletion);
    newWeekly[dayName] = (newWeekly[dayName] ?? 0) + 1;

    return copyWith(
      totalWorkouts: totalWorkouts + 1,
      currentStreak: newStreak,
      longestStreak: newStreak > longestStreak ? newStreak : longestStreak,
      lastWorkoutDate: workoutDate,
      weeklyCompletion: newWeekly,
    );
  }

  /// Add or update a personal record
  WorkoutProgress addPersonalRecord(PersonalRecord pr) {
    final newPRs = List<PersonalRecord>.from(personalRecords);
    
    // Check if PR exists for this exercise
    final existingIndex = newPRs.indexWhere((p) => p.exerciseId == pr.exerciseId);
    
    if (existingIndex != -1) {
      // Update if new PR is better
      if (pr.weight > newPRs[existingIndex].weight) {
        newPRs[existingIndex] = pr;
      }
    } else {
      // Add new PR
      newPRs.add(pr);
    }

    return copyWith(personalRecords: newPRs);
  }
}

/// Represents a personal record for an exercise
class PersonalRecord {
  final String exerciseId;
  final String exerciseName;
  final double weight;
  final int reps;
  final DateTime date;

  PersonalRecord({
    required this.exerciseId,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'weight': weight,
      'reps': reps,
      'date': date.toIso8601String(),
    };
  }

  factory PersonalRecord.fromJson(Map<String, dynamic> json) {
    return PersonalRecord(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      weight: (json['weight'] as num).toDouble(),
      reps: json['reps'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
