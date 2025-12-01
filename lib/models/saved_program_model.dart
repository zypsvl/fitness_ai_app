import 'package:uuid/uuid.dart';
import 'weekly_plan_model.dart';
import 'exercise_model.dart';

class SavedProgram {
  final String id;
  final String name;
  final DateTime createdAt;
  final String gender;
  final String goal;
  final String level;
  final String location;
  final int daysPerWeek;
  final List<WorkoutDay> plan;

  SavedProgram({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.gender,
    required this.goal,
    required this.level,
    required this.location,
    required this.daysPerWeek,
    required this.plan,
  });

  // Create new program with generated ID
  factory SavedProgram.create({
    required String name,
    required String gender,
    required String goal,
    required String level,
    required String location,
    required int daysPerWeek,
    required List<WorkoutDay> plan,
  }) {
    return SavedProgram(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
      gender: gender,
      goal: goal,
      level: level,
      location: location,
      daysPerWeek: daysPerWeek,
      plan: plan,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'gender': gender,
      'goal': goal,
      'level': level,
      'location': location,
      'daysPerWeek': daysPerWeek,
      'plan': plan.map((day) => {
        'day': day.dayName,
        'focus': day.focus,
        'exercises': day.exercises.map((ex) => {
          'id': ex.exercise.id,
          'sets': ex.sets,
          'reps': ex.reps,
        }).toList(),
      }).toList(),
    };
  }

  // Create from JSON
  factory SavedProgram.fromJson(Map<String, dynamic> json, List<Exercise> allExercises) {
    var planList = json['plan'] as List;
    
    return SavedProgram(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      gender: json['gender'],
      goal: json['goal'],
      level: json['level'],
      location: json['location'],
      daysPerWeek: json['daysPerWeek'],
      plan: planList.map((dayJson) => WorkoutDay.fromJson(
        dayJson as Map<String, dynamic>,
        allExercises,
      )).toList(),
    );
  }

  // Copy with new name
  SavedProgram copyWith({String? name}) {
    return SavedProgram(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      gender: gender,
      goal: goal,
      level: level,
      location: location,
      daysPerWeek: daysPerWeek,
      plan: plan,
    );
  }

  // Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks hafta önce';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ay önce';
    }
  }

  // Get total exercises count
  int get totalExercises {
    return plan.fold(0, (sum, day) => sum + day.exercises.length);
  }
}
