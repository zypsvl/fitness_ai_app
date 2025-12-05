class PersonalRecord {
  final String exerciseId;
  final String exerciseName;
  final double maxWeight;
  final int maxReps;
  final double maxVolume;
  final DateTime achievedDate;
  final String programId;
  final String programName;

  PersonalRecord({
    required this.exerciseId,
    required this.exerciseName,
    required this.maxWeight,
    required this.maxReps,
    required this.maxVolume,
    required this.achievedDate,
    required this.programId,
    required this.programName,
  });

  // Calculate volume (weight × reps)
  static double calculateVolume(double weight, int reps, int sets) {
    return weight * reps * sets;
  }

  // Check if this performance beats the current PR
  bool isBetterThan(double weight, int reps) {
    final newVolume = weight * reps;
    return newVolume > maxVolume || 
           (weight > maxWeight && reps >= maxReps) ||
           (reps > maxReps && weight >= maxWeight);
  }

  // Factory constructor from JSON
  factory PersonalRecord.fromJson(Map<String, dynamic> json) {
    return PersonalRecord(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      maxWeight: (json['maxWeight'] as num).toDouble(),
      maxReps: json['maxReps'] as int,
      maxVolume: (json['maxVolume'] as num).toDouble(),
      achievedDate: DateTime.parse(json['achievedDate'] as String),
      programId: json['programId'] as String,
      programName: json['programName'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'maxWeight': maxWeight,
      'maxReps': maxReps,
      'maxVolume': maxVolume,
      'achievedDate': achievedDate.toIso8601String(),
      'programId': programId,
      'programName': programName,
    };
  }

  // Create a copy with updated values
  PersonalRecord copyWith({
    String? exerciseId,
    String? exerciseName,
    double? maxWeight,
    int? maxReps,
    double? maxVolume,
    DateTime? achievedDate,
    String? programId,
    String? programName,
  }) {
    return PersonalRecord(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      maxWeight: maxWeight ?? this.maxWeight,
      maxReps: maxReps ?? this.maxReps,
      maxVolume: maxVolume ?? this.maxVolume,
      achievedDate: achievedDate ?? this.achievedDate,
      programId: programId ?? this.programId,
      programName: programName ?? this.programName,
    );
  }

  @override
  String toString() {
    return 'PersonalRecord(exercise: $exerciseName, weight: ${maxWeight}kg, reps: $maxReps, volume: ${maxVolume}kg, date: $achievedDate)';
  }
}
