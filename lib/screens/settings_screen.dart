import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/glass_container.dart';
import '../widgets/animated_gradient_background.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import 'notification_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final strings = AppStrings(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.settingsTitle),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Theme Section Header
              Text(
                strings.themeTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Theme Options
              GlassContainer(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    _buildThemeOption(
                      context,
                      ThemeOption.system,
                      strings.themeSystem,
                      Icons.brightness_auto,
                      strings.themeSystemDesc,
                      themeProvider,
                    ),
                    const Divider(height: 1, color: Colors.white10),
                    _buildThemeOption(
                      context,
                      ThemeOption.light,
                      strings.themeLight,
                      Icons.light_mode,
                      strings.themeLightDesc,
                      themeProvider,
                    ),
                    const Divider(height: 1, color: Colors.white10),
                    _buildThemeOption(
                      context,
                      ThemeOption.dark,
                      strings.themeDark,
                      Icons.dark_mode,
                      strings.themeDarkDesc,
                      themeProvider,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Notifications Section Header
              Text(
                strings.notificationsTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Notifications Option
              GlassContainer(
                padding: const EdgeInsets.all(4),
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.primaryPurple,
                  ),
                  title: Text(
                    strings.notificationSettings,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    strings.notificationSettingsDesc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white70),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationSettingsScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Info Card
              GlassContainer(
                padding: const EdgeInsets.all(16),
                color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.primaryPurple),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        strings.themeInfo,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeOption option,
    String title,
    IconData icon,
    String subtitle,
    ThemeProvider themeProvider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = themeProvider.themeOption == option;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryPurple : (isDark ? Colors.white70 : Colors.black54),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppTheme.primaryPurple : Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.white54,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppTheme.primaryPurple)
          : null,
      onTap: () => themeProvider.setTheme(option),
    );
  }
}
