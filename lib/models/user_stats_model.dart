class UserStats {
  final int totalWorkouts;
  final int totalMinutes;
  final int currentStreak;
  final int longestStreak;
  final double totalVolume; // in kg
  final int totalSets;
  final int totalReps;
  final DateTime? lastWorkoutDate;
  final Map<String, int> muscleGroupDistribution; // muscle group -> count
  final List<Achievement> achievements;

  UserStats({
    this.totalWorkouts = 0,
    this.totalMinutes = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalVolume = 0,
    this.totalSets = 0,
    this.totalReps = 0,
    this.lastWorkoutDate,
    this.muscleGroupDistribution = const {},
    this.achievements = const [],
  });

  // Calculate workout score (0-100)
  int calculateScore() {
    int score = 0;

    // Workout frequency (max 30 points)
    if (totalWorkouts >= 100) {
      score += 30;
    } else if (totalWorkouts >= 50) {
      score += 20;
    } else if (totalWorkouts >= 20) {
      score += 15;
    } else if (totalWorkouts >= 10) {
      score += 10;
    } else if (totalWorkouts >= 1) {
      score += 5;
    }

    // Current streak (max 30 points)
    if (currentStreak >= 30) {
      score += 30;
    } else if (currentStreak >= 14) {
      score += 20;
    } else if (currentStreak >= 7) {
      score += 15;
    } else if (currentStreak >= 3) {
      score += 10;
    } else if (currentStreak >= 1) {
      score += 5;
    }

    // Volume (max 20 points)
    if (totalVolume >= 50000) {
      score += 20;
    } else if (totalVolume >= 25000) {
      score += 15;
    } else if (totalVolume >= 10000) {
      score += 10;
    } else if (totalVolume >= 5000) {
      score += 5;
    }

    // Achievements (max 20 points)
    final earnedAchievements = achievements.where((a) => a.isUnlocked).length;
    if (earnedAchievements >= 10) {
      score += 20;
    } else if (earnedAchievements >= 5) {
      score += 15;
    } else if (earnedAchievements >= 3) {
      score += 10;
    } else if (earnedAchievements >= 1) {
      score += 5;
    }

    return score.clamp(0, 100);
  }

  // Get average workout duration
  double get averageWorkoutDuration {
    if (totalWorkouts == 0) return 0;
    return totalMinutes / totalWorkouts;
  }

  // Get most trained muscle group
  String? get mostTrainedMuscleGroup {
    if (muscleGroupDistribution.isEmpty) return null;
    return muscleGroupDistribution.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  UserStats copyWith({
    int? totalWorkouts,
    int? totalMinutes,
    int? currentStreak,
    int? longestStreak,
    double? totalVolume,
    int? totalSets,
    int? totalReps,
    DateTime? lastWorkoutDate,
    Map<String, int>? muscleGroupDistribution,
    List<Achievement>? achievements,
  }) {
    return UserStats(
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalVolume: totalVolume ?? this.totalVolume,
      totalSets: totalSets ?? this.totalSets,
      totalReps: totalReps ?? this.totalReps,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      muscleGroupDistribution: muscleGroupDistribution ?? this.muscleGroupDistribution,
      achievements: achievements ?? this.achievements,
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedDate;
  final int threshold; // Required value to unlock

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedDate,
    required this.threshold,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedDate,
    int? threshold,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
      threshold: threshold ?? this.threshold,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedDate': unlockedDate?.toIso8601String(),
      'threshold': threshold,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedDate: json['unlockedDate'] != null
          ? DateTime.parse(json['unlockedDate'] as String)
          : null,
      threshold: json['threshold'] as int,
    );
  }
}
