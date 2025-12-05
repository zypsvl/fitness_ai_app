import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_settings_model.dart';
import '../services/notification_service.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  late NotificationSettings _settings;
  bool _loading = true;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('notification_settings');

    if (json != null) {
      final Map<String, dynamic> map = {};
      // Parse stored settings
      _settings = NotificationSettings.fromJson(map);
    } else {
      _settings = const NotificationSettings();
    }

    setState(() => _loading = false);
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_settings', _settings.toJson().toString());

    // Update scheduled notifications
    if (_settings.dailyReminderEnabled) {
      await _notificationService.scheduleWorkoutReminder(_settings.reminderTime);
    } else {
      await _notificationService.cancelWorkoutReminder();
    }
  }

  Future<void> _pickTime() async {
    final strings = AppStrings(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _settings.reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryPurple,
              onPrimary: Colors.white,
              surface: AppTheme.surfaceDark,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _settings.reminderTime) {
      setState(() {
        _settings = _settings.copyWith(reminderTime: picked);
      });
      await _saveSettings();
    }
  }

  Future<void> _testNotification() async {
    final strings = AppStrings(context);
    await _notificationService.showTestNotification(
      title: strings.testNotification,
      body: strings.notifDailyWorkoutBody,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.testNotification),
          backgroundColor: AppTheme.primaryPurple,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context);

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.notificationSettings),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Permissions Status Card
                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 20,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: FutureBuilder<bool>(
                    future: _notificationService.areNotificationsEnabled(),
                    builder: (context, snapshot) {
                      final enabled = snapshot.data ?? false;
                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: enabled
                                  ? AppTheme.secondaryCyan.withValues(alpha: 0.2)
                                  : Colors.orange.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              enabled
                                  ? Icons.notifications_active
                                  : Icons.notifications_off,
                              color: enabled ? AppTheme.secondaryCyan : Colors.orange,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  enabled
                                      ? strings.notifications
                                      : strings.notificationPermissionRequired,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!enabled) ...[
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () async {
                                      await _notificationService
                                          .requestPermissions();
                                      setState(() {});
                                    },
                                    child: Text(strings.enableNotifications),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ).animate().fadeIn().slideY(begin: -0.2),

                // Daily Reminder Section
                _buildSectionTitle(strings.dailyReminder, Icons.alarm),
                const SizedBox(height: 12),
                
                GlassContainer(
                  padding: const EdgeInsets.all(4),
                  borderRadius: 16,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _settings.dailyReminderEnabled,
                        onChanged: (value) async {
                          setState(() {
                            _settings = _settings.copyWith(
                              dailyReminderEnabled: value,
                            );
                          });
                          await _saveSettings();
                        },
                        title: Text(
                          strings.dailyReminder,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Get reminded to work out daily',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                        activeColor: AppTheme.primaryPurple,
                      ),
                      if (_settings.dailyReminderEnabled) ...[
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.access_time,
                            color: AppTheme.secondaryCyan,
                          ),
                          title: Text(
                            strings.reminderTime,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_settings.reminderTime.hour.toString().padLeft(2, '0')}:${_settings.reminderTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: _pickTime,
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),

                const SizedBox(height: 24),

                // Other Notifications Section
                _buildSectionTitle('Other Notifications', Icons.notifications_active),
                const SizedBox(height: 12),

                GlassContainer(
                  padding: const EdgeInsets.all(4),
                  borderRadius: 16,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      _buildNotificationToggle(
                        title: strings.streakWarnings,
                        subtitle: 'Alert when streak is at risk',
                        icon: Icons.local_fire_department,
                        value: _settings.streakWarningEnabled,
                        onChanged: (value) async {
                          setState(() {
                            _settings = _settings.copyWith(
                              streakWarningEnabled: value,
                            );
                          });
                          await _saveSettings();
                        },
                      ),
                      const Divider(height: 1),
                      _buildNotificationToggle(
                        title: strings.achievementNotifications,
                        subtitle: 'Celebrate unlocked achievements',
                        icon: Icons.emoji_events,
                        value: _settings.achievementNotificationsEnabled,
                        onChanged: (value) async {
                          setState(() {
                            _settings = _settings.copyWith(
                              achievementNotificationsEnabled: value,
                            );
                          });
                          await _saveSettings();
                        },
                      ),
                      const Divider(height: 1),
                      _buildNotificationToggle(
                        title: strings.prCelebrations,
                        subtitle: 'Get notified of new personal records',
                        icon: Icons.military_tech,
                        value: _settings.prCelebrationEnabled,
                        onChanged: (value) async {
                          setState(() {
                            _settings = _settings.copyWith(
                              prCelebrationEnabled: value,
                            );
                          });
                          await _saveSettings();
                        },
                      ),
                      const Divider(height: 1),
                      _buildNotificationToggle(
                        title: strings.restDayReminders,
                        subtitle: 'Remember to take rest days',
                        icon: Icons.self_improvement,
                        value: _settings.restDayRemindersEnabled,
                        onChanged: (value) async {
                          setState(() {
                            _settings = _settings.copyWith(
                              restDayRemindersEnabled: value,
                            );
                          });
                          await _saveSettings();
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

                const SizedBox(height: 24),

                // Test Notification Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _testNotification,
                    icon: const Icon(Icons.send),
                    label: Text(strings.testNotification),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).scale(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.secondaryCyan,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(icon, color: AppTheme.secondaryCyan, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ),
      activeColor: AppTheme.primaryPurple,
    );
  }
}
