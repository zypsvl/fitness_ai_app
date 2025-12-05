import 'dart:convert';

class StreakModel {
  final int currentStreak;
  final DateTime? lastActivityDate;
  final int bestStreak;
  final List<int> milestonesAchieved;

  StreakModel({
    required this.currentStreak,
    this.lastActivityDate,
    required this.bestStreak,
    this.milestonesAchieved = const [],
  });

  static const List<int> milestones = [3, 7, 14, 30, 60, 90, 180, 365];

  factory StreakModel.initial() {
    return StreakModel(
      currentStreak: 0,
      lastActivityDate: null,
      bestStreak: 0,
      milestonesAchieved: [],
    );
  }

  bool get isAtRisk {
    if (lastActivityDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = DateTime(lastActivityDate!.year, lastActivityDate!.month, lastActivityDate!.day);
    
    // If last activity was yesterday, streak is safe for today.
    // If last activity was before yesterday, streak is broken (but we might show it as 0 already).
    // "At risk" usually means "do it today or lose it".
    // So if last activity was yesterday, and today is not done, it's at risk.
    final difference = today.difference(last).inDays;
    return difference == 1;
  }

  StreakModel updateStreak(DateTime activityDate) {
    final now = DateTime(activityDate.year, activityDate.month, activityDate.day);
    
    // If no previous activity, start streak
    if (lastActivityDate == null) {
      return StreakModel(
        currentStreak: 1,
        lastActivityDate: activityDate,
        bestStreak: 1,
        milestonesAchieved: milestonesAchieved,
      );
    }

    final last = DateTime(lastActivityDate!.year, lastActivityDate!.month, lastActivityDate!.day);

    if (now.isAtSameMomentAs(last)) {
      // Already active today, no change
      return this;
    }

    final difference = now.difference(last).inDays;
    int newStreak;
    List<int> newMilestones = List.from(milestonesAchieved);

    if (difference == 1) {
      // Consecutive day, increment streak
      newStreak = currentStreak + 1;
    } else {
      // Missed a day (or more), reset to 1
      newStreak = 1;
    }
    
    // Check milestones
    if (milestones.contains(newStreak) && !newMilestones.contains(newStreak)) {
      newMilestones.add(newStreak);
    }

    return StreakModel(
      currentStreak: newStreak,
      lastActivityDate: activityDate,
      bestStreak: newStreak > bestStreak ? newStreak : bestStreak,
      milestonesAchieved: newMilestones,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentStreak': currentStreak,
      'lastActivityDate': lastActivityDate?.toIso8601String(),
      'bestStreak': bestStreak,
      'milestonesAchieved': milestonesAchieved,
    };
  }

  factory StreakModel.fromMap(Map<String, dynamic> map) {
    return StreakModel(
      currentStreak: map['currentStreak']?.toInt() ?? 0,
      lastActivityDate: map['lastActivityDate'] != null 
          ? DateTime.parse(map['lastActivityDate']) 
          : null,
      bestStreak: map['bestStreak']?.toInt() ?? 0,
      milestonesAchieved: List<int>.from(map['milestonesAchieved'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory StreakModel.fromJson(String source) =>
      StreakModel.fromMap(json.decode(source));
      
  // Compatibility getters
  int get longestStreak => bestStreak;
  
  int? get nextMilestone {
    for (final milestone in milestones) {
      if (currentStreak < milestone) {
        return milestone;
      }
    }
    return null; // All milestones achieved!
  }
  
  double get progressToNextMilestone {
    final next = nextMilestone;
    if (next == null) return 1.0;
    
    // Find previous milestone to calculate progress between them
    int previous = 0;
    for (int i = 0; i < milestones.length; i++) {
      if (milestones[i] == next) {
        if (i > 0) previous = milestones[i - 1];
        break;
      }
    }
    
    if (currentStreak <= previous) return 0.0;
    
    return (currentStreak - previous) / (next - previous);
  }

  StreakModel updateAfterWorkout() => updateStreak(DateTime.now());
}
