import '../models/user_stats_model.dart';

class AchievementsData {
  static List<Achievement> getDefaultAchievements() {
    return [
      Achievement(
        id: 'first_step',
        title: 'İlk Adım',
        description: 'İlk antrenmanını tamamla',
        icon: '🎯',
        threshold: 1,
      ),
      Achievement(
        id: 'committed',
        title: 'Kararlı',
        description: '7 gün üst üste antrenman yap',
        icon: '🔥',
        threshold: 7,
      ),
      Achievement(
        id: 'fire_ball',
        title: 'Ateş Topu',
        description: '30 gün üst üste antrenman yap',
        icon: '⚡',
        threshold: 30,
      ),
      Achievement(
        id: 'strong',
        title: 'Güçlü',
        description: '50 antrenman tamamla',
        icon: '💪',
        threshold: 50,
      ),
      Achievement(
        id: 'beast_mode',
        title: 'Canavar Modu',
        description: '100 antrenman tamamla',
        icon: '🦁',
        threshold: 100,
      ),
      Achievement(
        id: 'legend',
        title: 'Efsane',
        description: '365 gün üst üste antrenman yap',
        icon: '👑',
        threshold: 365,
      ),
      Achievement(
        id: 'volume_master',
        title: 'Hacim Ustası',
        description: '50,000 kg toplam hacme ulaş',
        icon: '📈',
        threshold: 50000,
      ),
      Achievement(
        id: 'set_monster',
        title: 'Set Canavarı',
        description: '1,000 set tamamla',
        icon: '🏋️',
        threshold: 1000,
      ),
      Achievement(
        id: 'consistency_king',
        title: 'Tutarlılık Kralı',
        description: 'Bir ayda 20 antrenman yap',
        icon: '🎖️',
        threshold: 20,
      ),
      Achievement(
        id: 'early_bird',
        title: 'Erken Kuş',
        description: '5 sabah antrenimanı tamamla',
        icon: '🌅',
        threshold: 5,
      ),
    ];
  }

  // Check and unlock achievements based on user stats
  static List<Achievement> checkAchievements(
    List<Achievement> currentAchievements,
    int totalWorkouts,
    int currentStreak,
    double totalVolume,
    int totalSets,
  ) {
    final updatedAchievements = <Achievement>[];

    for (final achievement in currentAchievements) {
      bool shouldUnlock = false;

      switch (achievement.id) {
        case 'first_step':
          shouldUnlock = totalWorkouts >= 1;
          break;
        case 'committed':
          shouldUnlock = currentStreak >= 7;
          break;
        case 'fire_ball':
          shouldUnlock = currentStreak >= 30;
          break;
        case 'strong':
          shouldUnlock = totalWorkouts >= 50;
          break;
        case 'beast_mode':
          shouldUnlock = totalWorkouts >= 100;
          break;
        case 'legend':
          shouldUnlock = currentStreak >= 365;
          break;
        case 'volume_master':
          shouldUnlock = totalVolume >= 50000;
          break;
        case 'set_monster':
          shouldUnlock = totalSets >= 1000;
          break;
        case 'consistency_king':
          shouldUnlock = totalWorkouts >= 20;
          break;
        case 'early_bird':
          // This would need workout time tracking, for now just unlock after 5 workouts
          shouldUnlock = totalWorkouts >= 5;
          break;
      }

      if (shouldUnlock && !achievement.isUnlocked) {
        updatedAchievements.add(achievement.copyWith(
          isUnlocked: true,
          unlockedDate: DateTime.now(),
        ));
      } else {
        updatedAchievements.add(achievement);
      }
    }

    return updatedAchievements;
  }
}
