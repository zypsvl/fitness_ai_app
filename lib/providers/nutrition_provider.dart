import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/nutrition_model.dart';

class NutritionProvider with ChangeNotifier {
  NutritionLog? _todayLog;
  bool _isLoading = true;

  NutritionLog? get todayLog => _todayLog;
  bool get isLoading => _isLoading;

  NutritionProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString('nutrition_log');

      if (jsonString != null) {
        final loadedLog = NutritionLog.fromJson(jsonString);
        if (loadedLog.isToday()) {
          _todayLog = loadedLog;
        } else {
          // Reset for new day but keep targets
          _todayLog = loadedLog.resetForNewDay();
          await _saveData();
        }
      } else {
        // First time initialization or no log found
        // Load saved goals if available
        final int targetCalories = prefs.getInt('goal_calories') ?? 2000;
        final int targetProtein = prefs.getInt('goal_protein') ?? 150;
        final int targetCarbs = prefs.getInt('goal_carbs') ?? 200;
        final int targetFat = prefs.getInt('goal_fat') ?? 65;

        _todayLog = NutritionLog(
          date: DateTime.now(),
          targetCalories: targetCalories,
          targetProtein: targetProtein,
          targetCarbs: targetCarbs,
          targetFat: targetFat,
        );
      }
    } catch (e) {
      debugPrint('Error loading nutrition data: $e');
      _todayLog = NutritionLog(date: DateTime.now());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveData() async {
    if (_todayLog == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nutrition_log', _todayLog!.toJson());
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving nutrition data: $e');
    }
  }

  Future<void> addEntry({
    int calories = 0,
    int protein = 0,
    int carbs = 0,
    int fat = 0,
  }) async {
    if (_todayLog == null) return;

    _todayLog = _todayLog!.addEntry(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
    await _saveData();
  }

  Future<void> updateTargets({
    int? targetCalories,
    int? targetProtein,
    int? targetCarbs,
    int? targetFat,
  }) async {
    if (_todayLog == null) return;

    _todayLog = _todayLog!.updateTargets(
      targetCalories: targetCalories,
      targetProtein: targetProtein,
      targetCarbs: targetCarbs,
      targetFat: targetFat,
    );
    await _saveData();

    // Also save as persistent user preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      if (targetCalories != null) await prefs.setInt('goal_calories', targetCalories);
      if (targetProtein != null) await prefs.setInt('goal_protein', targetProtein);
      if (targetCarbs != null) await prefs.setInt('goal_carbs', targetCarbs);
      if (targetFat != null) await prefs.setInt('goal_fat', targetFat);
    } catch (e) {
      debugPrint('Error saving nutrition goals: $e');
    }
  }
}
