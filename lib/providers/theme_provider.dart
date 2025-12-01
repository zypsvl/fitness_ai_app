import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeOption {
  system, // Follow system theme
  light,  // Always light
  dark,   // Always dark
}

class ThemeProvider extends ChangeNotifier {
  ThemeOption _themeOption = ThemeOption.system;
  static const String _themeKey = 'theme_preference';

  ThemeOption get themeOption => _themeOption;

  /// Get the actual ThemeMode based on current selection
  ThemeMode get themeMode {
    switch (_themeOption) {
      case ThemeOption.system:
        return ThemeMode.system;
      case ThemeOption.light:
        return ThemeMode.light;
      case ThemeOption.dark:
        return ThemeMode.dark;
    }
  }

  /// Load saved theme preference
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        _themeOption = ThemeOption.values.firstWhere(
          (e) => e.toString() == savedTheme,
          orElse: () => ThemeOption.system,
        );
        notifyListeners();
        print('✅ Theme loaded: $_themeOption');
      }
    } catch (e) {
      print('❌ Error loading theme: $e');
    }
  }

  /// Set theme option and save to preferences
  Future<void> setTheme(ThemeOption option) async {
    if (_themeOption == option) return;

    _themeOption = option;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, option.toString());
      print('✅ Theme saved: $option');
    } catch (e) {
      print('❌ Error saving theme: $e');
    }
  }

  /// Convenience methods
  Future<void> setSystemTheme() => setTheme(ThemeOption.system);
  Future<void> setLightTheme() => setTheme(ThemeOption.light);
  Future<void> setDarkTheme() => setTheme(ThemeOption.dark);

  /// Get display name for theme option
  String getThemeName(ThemeOption option) {
    switch (option) {
      case ThemeOption.system:
        return 'System';
      case ThemeOption.light:
        return 'Light';
      case ThemeOption.dark:
        return 'Dark';
    }
  }

  /// Get current theme name
  String get currentThemeName => getThemeName(_themeOption);
}
