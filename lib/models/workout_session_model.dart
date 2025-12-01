import 'package:uuid/uuid.dart';

/// Represents a single set completed during a workout
class CompletedSet {
  final String exerciseId;
  final int setNumber;
  final double? weight; // in kg, null if bodyweight
  final int reps;
  final DateTime timestamp;
  final String? notes;

  CompletedSet({
    required this.exerciseId,
    required this.setNumber,
    this.weight,
    required this.reps,
    required this.timestamp,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'setNumber': setNumber,
      'weight': weight,
      'reps': reps,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory CompletedSet.fromJson(Map<String, dynamic> json) {
    return CompletedSet(
      exerciseId: json['exerciseId'] as String,
      setNumber: json['setNumber'] as int,
      weight: json['weight'] as double?,
      reps: json['reps'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
    );
  }

  CompletedSet copyWith({
    String? exerciseId,
    int? setNumber,
    double? weight,
    int? reps,
    DateTime? timestamp,
    String? notes,
  }) {
    return CompletedSet(
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
    );
  }
}

/// Represents a completed workout session
class WorkoutSession {
  final String id;
  final String programId;
  final String programName;
  final DateTime startTime;
  final DateTime? endTime;
  final String dayName;
  final String focus;
  final List<CompletedSet> completedSets;
  final String? notes;
  final bool isCompleted;

  WorkoutSession({
    required this.id,
    required this.programId,
    required this.programName,
    required this.startTime,
    this.endTime,
    required this.dayName,
    required this.focus,
    required this.completedSets,
    this.notes,
    this.isCompleted = false,
  });

  /// Calculate total workout duration
  Duration get duration {
    if (endTime == null) {
      return DateTime.now().difference(startTime);
    }
    return endTime!.difference(startTime);
  }

  /// Get total volume (sets × reps × weight)
  double get totalVolume {
    return completedSets.fold(0.0, (sum, set) {
      final weight = set.weight ?? 0.0;
      return sum + (weight * set.reps);
    });
  }

  /// Get total number of sets completed
  int get totalSets => completedSets.length;

  /// Get total number of reps
  int get totalReps => completedSets.fold(0, (sum, set) => sum + set.reps);

  /// Create a new workout session
  factory WorkoutSession.create({
    required String programId,
    required String programName,
    required String dayName,
    required String focus,
  }) {
    return WorkoutSession(
      id: const Uuid().v4(),
      programId: programId,
      programName: programName,
      startTime: DateTime.now(),
      dayName: dayName,
      focus: focus,
      completedSets: [],
      isCompleted: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'programId': programId,
      'programName': programName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'dayName': dayName,
      'focus': focus,
      'completedSets': completedSets.map((s) => s.toJson()).toList(),
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      programId: json['programId'] as String,
      programName: json['programName'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null 
          ? DateTime.parse(json['endTime'] as String) 
          : null,
      dayName: json['dayName'] as String,
      focus: json['focus'] as String,
      completedSets: (json['completedSets'] as List)
          .map((s) => CompletedSet.fromJson(s as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  WorkoutSession copyWith({
    String? id,
    String? programId,
    String? programName,
    DateTime? startTime,
    DateTime? endTime,
    String? dayName,
    String? focus,
    List<CompletedSet>? completedSets,
    String? notes,
    bool? isCompleted,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      programName: programName ?? this.programName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      dayName: dayName ?? this.dayName,
      focus: focus ?? this.focus,
      completedSets: completedSets ?? this.completedSets,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Add a completed set to this session
  WorkoutSession addSet(CompletedSet set) {
    return copyWith(
      completedSets: [...completedSets, set],
    );
  }

  /// Update a specific set
  WorkoutSession updateSet(int index, CompletedSet set) {
    final newSets = List<CompletedSet>.from(completedSets);
    if (index >= 0 && index < newSets.length) {
      newSets[index] = set;
    }
    return copyWith(completedSets: newSets);
  }

  /// Mark workout as completed
  WorkoutSession complete({String? notes}) {
    return copyWith(
      endTime: DateTime.now(),
      isCompleted: true,
      notes: notes,
    );
  }
}
