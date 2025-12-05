import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user_profile_model.dart';
import '../models/body_measurement_model.dart';
import '../models/user_stats_model.dart';
import '../data/achievements_data.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile? _profile;
  List<BodyMeasurement> _measurements = [];
  UserStats _stats = UserStats();

  UserProfile? get profile => _profile;
  List<BodyMeasurement> get measurements => List.unmodifiable(_measurements);
  UserStats get stats => _stats;

  // Get latest measurement
  BodyMeasurement? get latestMeasurement {
    if (_measurements.isEmpty) return null;
    return _measurements.first;
  }

  // Get current weight
  double? get currentWeight => latestMeasurement?.weight;

  // Get weight change from first measurement
  double? get totalWeightChange {
    if (_measurements.length < 2) return null;
    final first = _measurements.last;
    final current = _measurements.first;
    return current.weight - first.weight;
  }

  // Get weight change percentage
  double? get totalWeightChangePercent {
    if (_measurements.length < 2) return null;
    final first = _measurements.last;
    final current = _measurements.first;
    return current.getWeightChange(first);
  }

  // Initialize and load data
  Future<void> loadData() async {
    await _loadProfile();
    await _loadMeasurements();
    notifyListeners();
  }

  // Load profile from storage
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('user_profile');
    if (profileJson != null) {
      final data = jsonDecode(profileJson) as Map<String, dynamic>;
      _profile = UserProfile.fromJson(data);
    }
  }

  // Save profile to storage
  Future<void> _saveProfile() async {
    if (_profile == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', jsonEncode(_profile!.toJson()));
  }

  // Update or create profile
  Future<void> updateProfile({
    String? name,
    int? age,
    String? gender,
    double? height,
    double? targetWeight,
  }) async {
    if (_profile == null) {
      _profile = UserProfile(
        id: const Uuid().v4(),
        name: name ?? 'User',
        age: age,
        gender: gender,
        height: height,
        targetWeight: targetWeight,
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
    } else {
      _profile = _profile!.copyWith(
        name: name,
        age: age,
        gender: gender,
        height: height,
        targetWeight: targetWeight,
        lastUpdated: DateTime.now(),
      );
    }
    await _saveProfile();
    await syncToCloud(); // Sync to Firebase
    notifyListeners();
  }

  // Set active program
  Future<void> setActiveProgram(String? programId) async {
    if (_profile == null) return;
    _profile = _profile!.copyWith(
      activeProgramId: programId,
      lastUpdated: DateTime.now(),
    );
    await _saveProfile();
    notifyListeners();
  }

  // Load measurements from storage
  Future<void> _loadMeasurements() async {
    final prefs = await SharedPreferences.getInstance();
    final measurementsJson = prefs.getString('body_measurements');
    if (measurementsJson != null) {
      final data = jsonDecode(measurementsJson) as List;
      _measurements = data
          .map((item) => BodyMeasurement.fromJson(item as Map<String, dynamic>))
          .toList();
      // Sort by date descending (most recent first)
      _measurements.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  // Save measurements to storage
  Future<void> _saveMeasurements() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _measurements.map((m) => m.toJson()).toList();
    await prefs.setString('body_measurements', jsonEncode(data));
  }

  // Add new measurement
  Future<void> addMeasurement({
    required double weight,
    double? chest,
    double? waist,
    double? hips,
    double? arms,
    double? thighs,
    String? notes,
  }) async {
    final measurement = BodyMeasurement.create(
      weight: weight,
      chest: chest,
      waist: waist,
      hips: hips,
      arms: arms,
      thighs: thighs,
      notes: notes,
    );

    _measurements.insert(0, measurement);
    await _saveMeasurements();
    notifyListeners();
  }

  // Update existing measurement
  Future<void> updateMeasurement(
    String id, {
    double? weight,
    double? chest,
    double? waist,
    double? hips,
    double? arms,
    double? thighs,
    String? notes,
  }) async {
    final index = _measurements.indexWhere((m) => m.id == id);
    if (index == -1) return;

    _measurements[index] = _measurements[index].copyWith(
      weight: weight,
      chest: chest,
      waist: waist,
      hips: hips,
      arms: arms,
      thighs: thighs,
      notes: notes,
    );

    await _saveMeasurements();
    notifyListeners();
  }

  // Delete measurement
  Future<void> deleteMeasurement(String id) async {
    _measurements.removeWhere((m) => m.id == id);
    await _saveMeasurements();
    notifyListeners();
  }

  // Get measurements for chart (last N days)
  List<BodyMeasurement> getMeasurementsForChart(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _measurements
        .where((m) => m.date.isAfter(cutoffDate))
        .toList()
        .reversed
        .toList(); // Oldest first for chart
  }

  // Update stats (should be called after workout completion)
  void updateStats(UserStats newStats) {
    _stats = newStats;
    notifyListeners();
  }

  // Get current BMI
  double? getCurrentBMI() {
    if (_profile == null || currentWeight == null) return null;
    return _profile!.calculateBMI(currentWeight);
  }

  // Get BMI category
  String getBMICategory() {
    final bmi = getCurrentBMI();
    if (_profile == null) return 'Bilinmiyor';
    return _profile!.getBMICategory(bmi);
  }

  // Get weight progress towards target
  double? getWeightProgress() {
    if (_profile?.targetWeight == null || currentWeight == null) return null;
    if (_measurements.length < 2) return null;

    final startWeight = _measurements.last.weight;
    final targetWeight = _profile!.targetWeight!;
    final currentW = currentWeight!;

    final totalChange = targetWeight - startWeight;
    if (totalChange == 0) return 100.0;

    final currentChange = currentW - startWeight;
    return (currentChange / totalChange * 100).clamp(0.0, 100.0);
  }

  // Check if profile is complete
  bool get isProfileComplete {
    if (_profile == null) return false;
    return _profile!.name.isNotEmpty &&
        _profile!.age != null &&
        _profile!.height != null;
  }

  // Check if user has any measurements
  bool get hasMeasurements => _measurements.isNotEmpty;

  // ============ CLOUD SYNC ============
  /// Sync profile to Firebase Firestore
  Future<void> syncToCloud() async {
    if (_profile == null) return;
   
    try {
      final authService = AuthService();
      final firestoreService = FirestoreService();
      final userId = await authService.getCurrentUserId();
      
      await firestoreService.saveUserProfile(userId, {
        'name': _profile!.name,
        'age': _profile!.age,
        'gender': _profile!.gender,
        'height': _profile!.height,
        'targetWeight': _profile!.targetWeight,
        'activeProgramId': _profile!.activeProgramId,
        'totalWorkouts': _stats.totalWorkouts,
        'currentStreak': _stats.currentStreak,
        'longestStreak': _stats.longestStreak,
        'totalVolume': _stats.totalVolume,
      });
      
      print('✅ Profile synced to cloud');
    } catch (e) {
      print('⚠️ Profile sync failed: $e');
    }
  }
  // ====================================
}
