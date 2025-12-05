import 'package:flutter/material.dart';

class NotificationSettings {
  final bool dailyReminderEnabled;
  final TimeOfDay reminderTime;
  final bool streakWarningEnabled;
  final bool achievementNotificationsEnabled;
  final bool restDayRemindersEnabled;
  final bool prCelebrationEnabled;

  const NotificationSettings({
    this.dailyReminderEnabled = true,
    this.reminderTime = const TimeOfDay(hour: 18, minute: 0),
    this.streakWarningEnabled = true,
    this.achievementNotificationsEnabled = true,
    this.restDayRemindersEnabled = true,
    this.prCelebrationEnabled = true,
  });

  // Factory constructor from JSON
  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      dailyReminderEnabled: json['dailyReminderEnabled'] as bool? ?? true,
      reminderTime: json['reminderTime'] != null
          ? TimeOfDay(
              hour: json['reminderTime']['hour'] as int,
              minute: json['reminderTime']['minute'] as int,
            )
          : const TimeOfDay(hour: 18, minute: 0),
      streakWarningEnabled: json['streakWarningEnabled'] as bool? ?? true,
      achievementNotificationsEnabled:
          json['achievementNotificationsEnabled'] as bool? ?? true,
      restDayRemindersEnabled: json['restDayRemindersEnabled'] as bool? ?? true,
      prCelebrationEnabled: json['prCelebrationEnabled'] as bool? ?? true,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'dailyReminderEnabled': dailyReminderEnabled,
      'reminderTime': {
        'hour': reminderTime.hour,
        'minute': reminderTime.minute,
      },
      'streakWarningEnabled': streakWarningEnabled,
      'achievementNotificationsEnabled': achievementNotificationsEnabled,
      'restDayRemindersEnabled': restDayRemindersEnabled,
      'prCelebrationEnabled': prCelebrationEnabled,
    };
  }

  // Create a copy with updated values
  NotificationSettings copyWith({
    bool? dailyReminderEnabled,
    TimeOfDay? reminderTime,
    bool? streakWarningEnabled,
    bool? achievementNotificationsEnabled,
    bool? restDayRemindersEnabled,
    bool? prCelebrationEnabled,
  }) {
    return NotificationSettings(
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      streakWarningEnabled: streakWarningEnabled ?? this.streakWarningEnabled,
      achievementNotificationsEnabled: achievementNotificationsEnabled ??
          this.achievementNotificationsEnabled,
      restDayRemindersEnabled:
          restDayRemindersEnabled ?? this.restDayRemindersEnabled,
      prCelebrationEnabled: prCelebrationEnabled ?? this.prCelebrationEnabled,
    );
  }

  @override
  String toString() {
    return 'NotificationSettings(dailyReminder: $dailyReminderEnabled, time: ${reminderTime.hour}:${reminderTime.minute})';
  }
}
