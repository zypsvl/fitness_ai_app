import 'exercise_model.dart';

String normalizeId(String s) {
  return s.trim().toLowerCase().replaceAll(" ", "_").replaceAll("-", "_");
}

class WorkoutDay {
  final String dayName;
  final String focus;
  final List<ScheduledExercise> exercises;

  WorkoutDay({
    required this.dayName,
    required this.focus,
    required this.exercises,
  });

  factory WorkoutDay.fromJson(
    Map<String, dynamic> json,
    List<Exercise> allExercises,
  ) {
    var list = json['exercises'] as List;

    return WorkoutDay(
      dayName: json['day'] ?? "Gün",
      focus: json['focus'] ?? "Genel",
      exercises:
          list.map((e) => ScheduledExercise.fromJson(e, allExercises)).toList(),
    );
  }
}

class ScheduledExercise {
  final Exercise exercise;
  final String sets;
  final String reps;

  ScheduledExercise({
    required this.exercise,
    required this.sets,
    required this.reps,
  });

  factory ScheduledExercise.fromJson(
    Map<String, dynamic> json,
    List<Exercise> allDb,
  ) {
    String id = normalizeId(json['id'].toString());

    Exercise found = allDb.firstWhere(
      (e) => e.id.toLowerCase() == id,
      orElse: () => Exercise(
        id: "unknown",
        name: "Bilinmeyen Hareket ($id)",
        mechanic: "",
        equipmentTier: "",
        primaryMuscle: "",
        secondaryMuscles: [],
        bodyPart: "",
        difficulty: 1,
      ),
    );

    return ScheduledExercise(
      exercise: found,
      sets: json['sets']?.toString() ?? "3",
      reps: json['reps']?.toString() ?? "10",
    );
  }
}
