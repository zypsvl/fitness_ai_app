import 'dart:convert';

class NutritionLog {
  final DateTime date;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int targetCalories;
  final int targetProtein;
  final int targetCarbs;
  final int targetFat;

  NutritionLog({
    required this.date,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.targetCalories = 2000,
    this.targetProtein = 150,
    this.targetCarbs = 200,
    this.targetFat = 65,
  });

  // Getters for progress
  double get caloriesProgress => (calories / targetCalories).clamp(0.0, 1.0);
  double get proteinProgress => (protein / targetProtein).clamp(0.0, 1.0);
  double get carbsProgress => (carbs / targetCarbs).clamp(0.0, 1.0);
  double get fatProgress => (fat / targetFat).clamp(0.0, 1.0);

  bool get isCaloriesGoalReached => calories >= targetCalories;
  bool get isProteinGoalReached => protein >= targetProtein;

  // Add entry
  NutritionLog addEntry({
    int calories = 0,
    int protein = 0,
    int carbs = 0,
    int fat = 0,
  }) {
    return NutritionLog(
      date: date,
      calories: this.calories + calories,
      protein: this.protein + protein,
      carbs: this.carbs + carbs,
      fat: this.fat + fat,
      targetCalories: targetCalories,
      targetProtein: targetProtein,
      targetCarbs: targetCarbs,
      targetFat: targetFat,
    );
  }

  // Update targets
  NutritionLog updateTargets({
    int? targetCalories,
    int? targetProtein,
    int? targetCarbs,
    int? targetFat,
  }) {
    return NutritionLog(
      date: date,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFat: targetFat ?? this.targetFat,
    );
  }

  // Check if today
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Reset for new day (keep targets)
  NutritionLog resetForNewDay() {
    return NutritionLog(
      date: DateTime.now(),
      calories: 0,
      protein: 0,
      carbs: 0,
      fat: 0,
      targetCalories: targetCalories,
      targetProtein: targetProtein,
      targetCarbs: targetCarbs,
      targetFat: targetFat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'targetCalories': targetCalories,
      'targetProtein': targetProtein,
      'targetCarbs': targetCarbs,
      'targetFat': targetFat,
    };
  }

  factory NutritionLog.fromMap(Map<String, dynamic> map) {
    return NutritionLog(
      date: DateTime.parse(map['date']),
      calories: map['calories']?.toInt() ?? 0,
      protein: map['protein']?.toInt() ?? 0,
      carbs: map['carbs']?.toInt() ?? 0,
      fat: map['fat']?.toInt() ?? 0,
      targetCalories: map['targetCalories']?.toInt() ?? 2000,
      targetProtein: map['targetProtein']?.toInt() ?? 150,
      targetCarbs: map['targetCarbs']?.toInt() ?? 200,
      targetFat: map['targetFat']?.toInt() ?? 65,
    );
  }

  String toJson() => json.encode(toMap());

  factory NutritionLog.fromJson(String source) =>
      NutritionLog.fromMap(json.decode(source));
}
