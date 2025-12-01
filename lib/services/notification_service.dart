import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
    print('✅ NotificationService initialized');
  }

  /// Request notification permissions (Android 13+)
  Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted = await androidImplementation.requestNotificationsPermission();
      return granted ?? false;
    }

    // iOS permissions requested during initialization
    return true;
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Could navigate to specific screen based on payload
  }

  // ---------------------------------------------------
  // REST TIMER NOTIFICATIONS
  // ---------------------------------------------------

  /// Show notification when rest timer completes
  Future<void> showRestTimerComplete() async {
    const androidDetails = AndroidNotificationDetails(
      'rest_timer',
      'Rest Timer',
      channelDescription: 'Rest timer completion notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      0, // Notification ID
      '⏰ Dinlenme Tamamlandı!',
      'Bir sonraki set için hazır mısın?',
      notificationDetails,
      payload: 'rest_timer',
    );

    print('✅ Rest timer notification sent');
  }

  // ---------------------------------------------------
  // WORKOUT REMINDER NOTIFICATIONS
  // ---------------------------------------------------

  /// Schedule daily workout reminder at specific time
  Future<void> scheduleWorkoutReminder(TimeOfDay time) async {
    // Cancel previous workout reminders
    await _plugin.cancel(1);

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'workout_reminder',
      'Workout Reminders',
      channelDescription: 'Daily workout reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      1, // Notification ID
      '🏋️ Antrenman Zamanı!',
      'Fitness yolculuğun seni bekliyor',
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      payload: 'workout_reminder',
    );

    print('✅ Workout reminder scheduled for ${time.hour}:${time.minute}');
  }

  /// Cancel workout reminder
  Future<void> cancelWorkoutReminder() async {
    await _plugin.cancel(1);
    print('❌ Workout reminder cancelled');
  }

  // ---------------------------------------------------
  // MOTIVATIONAL MESSAGES
  // ---------------------------------------------------

  final List<String> _motivationalMessages = [
    'Bugün harika bir antrenman günü! 💪',
    'Hedeflerine bir adım daha yakınsın! 🎯',
    'Güçlü kalırsan, güçlü olursun! 🔥',
    'Her set seni daha iyi yapıyor! ⚡',
    'Başarı tutarlılıktan gelir! 🌟',
    'Sen yapabilirsin! Kendine inan! 💫',
    'Bugün kendini zorla! 🚀',
    'Vücut elde etmek istediğin yaşamı yaratır! 🏆',
  ];

  /// Schedule daily motivational message (8 AM)
  Future<void> scheduleDailyMotivation() async {
    // Cancel previous motivation
    await _plugin.cancel(2);

    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 8, 0); // 8 AM

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Random motivational message
    final message = (_motivationalMessages..shuffle()).first;

    const androidDetails = AndroidNotificationDetails(
      'motivation',
      'Daily Motivation',
      channelDescription: 'Daily motivational messages',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      2, // Notification ID
      '💪 Günün Motivasyonu',
      message,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'motivation',
    );

    print('✅ Daily motivation scheduled');
  }

  /// Cancel daily motivation
  Future<void> cancelDailyMotivation() async {
    await _plugin.cancel(2);
    print('❌ Daily motivation cancelled');
  }

  // ---------------------------------------------------
  // UTILITY METHODS
  // ---------------------------------------------------

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    print('❌ All notifications cancelled');
  }

  /// Get active notifications (for debugging)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    final List<ActiveNotification> activeNotifications =
        await _plugin.getActiveNotifications();
    return activeNotifications;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }

    return true; // iOS assumes enabled if permission granted
  }
}
