import 'dart:math';

class WaterIntake {
  final DateTime date;
  final int totalMl;
  final int goalMl;
  final List<int> entries;

  WaterIntake({
    required this.date,
    this.totalMl = 0,
    this.goalMl = 2000, // Default 2L
    this.entries = const [],
  });

  // Getters
  double get progress => min(1.0, totalMl / goalMl);
  bool get isGoalReached => totalMl >= goalMl;
  int get remainingMl => max(0, goalMl - totalMl);
  int get glassCount => entries.length;
  double get liters => totalMl / 1000.0;
  double get goalLiters => goalMl / 1000.0;

  // Add water
  WaterIntake addWater(int ml) {
    final newEntries = List<int>.from(entries)..add(ml);
    return WaterIntake(
      date: date,
      totalMl: totalMl + ml,
      goalMl: goalMl,
      entries: newEntries,
    );
  }

  // Set new goal
  WaterIntake setGoal(int newGoalMl) {
    return WaterIntake(
      date: date,
      totalMl: totalMl,
      goalMl: newGoalMl,
      entries: entries,
    );
  }

  // Reset for new day
  WaterIntake resetForNewDay() {
    return WaterIntake(
      date: DateTime.now(),
      totalMl: 0,
      goalMl: goalMl, // Keep the same goal
      entries: [],
    );
  }

  // Check if this is today's data
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  // Factory constructor from JSON
  factory WaterIntake.fromJson(Map<String, dynamic> json) {
    return WaterIntake(
      date: DateTime.parse(json['date'] as String),
      totalMl: json['totalMl'] as int? ?? 0,
      goalMl: json['goalMl'] as int? ?? 2000,
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalMl': totalMl,
      'goalMl': goalMl,
      'entries': entries,
    };
  }

  @override
  String toString() {
    return 'WaterIntake(${liters.toStringAsFixed(1)}L / ${goalLiters.toStringAsFixed(1)}L, ${(progress * 100).toStringAsFixed(0)}%)';
  }
}
