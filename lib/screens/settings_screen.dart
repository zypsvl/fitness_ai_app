import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Theme Section Header
          Text(
            'TEMA',
            style: theme.textTheme.titleSmall?.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
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
                  'Sistem',
                  Icons.brightness_auto,
                  'Cihaz temasını takip et',
                  themeProvider,
                ),
                const Divider(height: 1),
                _buildThemeOption(
                  context,
                  ThemeOption.light,
                  'Aydınlık',
                  Icons.light_mode,
                  'Aydınlık tema kullan',
                  themeProvider,
                ),
                const Divider(height: 1),
                _buildThemeOption(
                  context,
                  ThemeOption.dark,
                  'Karanlık',
                  Icons.dark_mode,
                  'Karanlık tema kullan',
                  themeProvider,
                ),
              ],
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
                    'Tema tercihiniz kaydedilir ve uygulamayı her açtığınızda kullanılır.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          color: isSelected ? AppTheme.primaryPurple : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white54 : Colors.black45,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppTheme.primaryPurple)
          : null,
      onTap: () => themeProvider.setTheme(option),
    );
  }
}
