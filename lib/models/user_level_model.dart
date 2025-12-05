class UserLevel {
  final int currentLevel;
  final int totalXP;
  final List<String> unlockedRewards;
  final int totalWorkouts;
  final int totalPRs;

  UserLevel({
    this.currentLevel = 1,
    this.totalXP = 0,
    this.unlockedRewards = const [],
    this.totalWorkouts = 0,
    this.totalPRs = 0,
  });

  // XP required for each level (exponential growth)
  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    // Base: 100 XP for level 2, increases by 50 each level
    return 100 + (level - 2) * 50;
  }

  // Total XP needed to reach a specific level from level 1
  static int totalXPForLevel(int level) {
    int total = 0;
    for (int i = 2; i <= level; i++) {
      total += xpForLevel(i);
    }
    return total;
  }

  // XP needed to reach next level
  int get xpToNextLevel {
    return xpForLevel(currentLevel + 1);
  }

  // XP progress in current level (0.0 to 1.0)
  double get levelProgress {
    if (currentLevel == 1) {
      return totalXP / xpToNextLevel;
    }
    
    final xpForCurrentLevel = totalXPForLevel(currentLevel);
    final xpInCurrentLevel = totalXP - xpForCurrentLevel;
    
    return xpInCurrentLevel / xpToNextLevel;
  }

  // Current XP within the level
  int get currentLevelXP {
    if (currentLevel == 1) return totalXP;
    return totalXP - totalXPForLevel(currentLevel);
  }

  // Add XP and check for level up
  UserLevel addXP(int xp, {String? newReward}) {
    final newTotalXP = totalXP + xp;
    int newLevel = currentLevel;
    
    // Calculate new level
    for (int i = currentLevel + 1; i <= 100; i++) {
      if (newTotalXP >= totalXPForLevel(i)) {
        newLevel = i;
      } else {
        break;
      }
    }

    List<String> newRewards = List.from(unlockedRewards);
    if (newReward != null && !newRewards.contains(newReward)) {
      newRewards.add(newReward);
    }

    return UserLevel(
      currentLevel: newLevel,
      totalXP: newTotalXP,
      unlockedRewards: newRewards,
      totalWorkouts: totalWorkouts,
      totalPRs: totalPRs,
    );
  }

  // Level up rewards
  static String? getRewardForLevel(int level) {
    final rewards = {
      5: '🎨 Unlock: Purple Theme',
      10: '🎨 Unlock: Blue Theme',
      15: '🏆 Achievement: Dedicated Athlete',
      20: '🎨 Unlock: Green Theme',
      25: '🏋️ Achievement: Strong Foundation',
      30: '🎨 Unlock: Orange Theme',
      40: '🏆 Achievement: Fitness Warrior',
      50: '🎨 Unlock: Red Theme',
      60: '🏋️ Achievement: Unstoppable',
      75: '🎨 Unlock: Gold Theme',
      100: '👑 Achievement: Fitness Legend',
    };
    return rewards[level];
  }

  // Increment workout count
  UserLevel incrementWorkouts() {
    return UserLevel(
      currentLevel: currentLevel,
      totalXP: totalXP,
      unlockedRewards: unlockedRewards,
      totalWorkouts: totalWorkouts + 1,
      totalPRs: totalPRs,
    );
  }

  // Increment PR count
  UserLevel incrementPRs() {
    return UserLevel(
      currentLevel: currentLevel,
      totalXP: totalXP,
      unlockedRewards: unlockedRewards,
      totalWorkouts: totalWorkouts,
      totalPRs: totalPRs + 1,
    );
  }

  // Factory constructor from JSON
  factory UserLevel.fromJson(Map<String, dynamic> json) {
    return UserLevel(
      currentLevel: json['currentLevel'] as int? ?? 1,
      totalXP: json['totalXP'] as int? ?? 0,
      unlockedRewards: (json['unlockedRewards'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      totalWorkouts: json['totalWorkouts'] as int? ?? 0,
      totalPRs: json['totalPRs'] as int? ?? 0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel,
      'totalXP': totalXP,
      'unlockedRewards': unlockedRewards,
      'totalWorkouts': totalWorkouts,
      'totalPRs': totalPRs,
    };
  }

  @override
  String toString() {
    return 'UserLevel(level: $currentLevel, xp: $totalXP, workouts: $totalWorkouts, PRs: $totalPRs)';
  }
}
