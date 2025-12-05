import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise_model.dart';
import '../models/weekly_plan_model.dart';
import '../models/saved_program_model.dart';
import '../models/workout_session_model.dart';
import '../models/workout_progress_model.dart' as progress;
import '../models/personal_record_model.dart';
import '../models/streak_model.dart';
import '../models/exercise_history_model.dart';
import '../models/user_level_model.dart';
import '../models/water_intake_model.dart';
import '../services/groq_service.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Exercise> _allExercises = [];
  List<WorkoutDay> _weeklyPlan = [];
  bool _isLoading = false;
  
  // Saved programs management
  List<SavedProgram> _savedPrograms = [];
  
  // Workout tracking
  List<WorkoutSession> _workoutHistory = [];
  Map<String, progress.WorkoutProgress> _programProgress = {};
  
  // Track completed exercises in the current session
  // Format: "dayName_exerciseIndex"
  final Set<String> _completedExercises = {};
  
  // Current program metadata (for saving)
  String _currentProgramId = '';
  String _currentProgramName = '';
  String _currentGender = '';
  String _currentGoal = '';
  String _currentLevel = '';
  String _currentLocation = '';
  int _currentDays = 0;
  int _currentDuration = 45;
  bool _isCurrentProgramSaved = false; // Track if current program is already saved
  
  // ---------------------------------------------------
  // PHASE 1: NEW FEATURES
  // ---------------------------------------------------
  
  // Personal Records tracking
  Map<String, PersonalRecord> _personalRecords = {}; // exerciseId -> PR
  
  // Streak system
  StreakModel _streakData = StreakModel.initial();
  
  // Exercise history (per-exercise workout data)
  Map<String, List<ExerciseHistory>> _exerciseHistory = {}; // exerciseId -> history list
  
  // Gamification (XP & Levels)
  UserLevel _userLevel = UserLevel();
  
  // Water Tracking
  WaterIntake? _todayWaterIntake;
  
  // Favorite Exercises (Quick Win Feature)
  Set<String> _favoriteExerciseIds = {};

  List<WorkoutDay> get weeklyPlan => _weeklyPlan;
  bool get isLoading => _isLoading;
  List<Exercise> get allExercises => _allExercises;
  List<SavedProgram> get savedPrograms => _savedPrograms;
  bool get isCurrentProgramSaved => _isCurrentProgramSaved;
  List<WorkoutSession> get workoutHistory => _workoutHistory;
  Map<String, progress.WorkoutProgress> get programProgress => _programProgress;
  Set<String> get completedExercises => _completedExercises;
  String get currentProgramName => _currentProgramName;
  
  // Phase 1 getters
  Map<String, PersonalRecord> get personalRecords => _personalRecords;
  StreakModel get streakData => _streakData;
  Map<String, List<ExerciseHistory>> get exerciseHistory => _exerciseHistory;
  UserLevel get userLevel => _userLevel;
  
  // Water Tracking getter
  WaterIntake? get todayWaterIntake => _todayWaterIntake;
  
  // Favorite Exercises getter
  Set<String> get favoriteExerciseIds => _favoriteExerciseIds;

  // ---------------------------------------------------
  // EXERCISE COMPLETION TRACKING
  // ---------------------------------------------------
  
  // Track exercises that are in progress (started but not completed)
  final Set<String> _inProgressExercises = {};
  
  void markExerciseInProgress(String dayName, int exerciseIndex) {
    final key = "${dayName}_$exerciseIndex";
    if (!_inProgressExercises.contains(key) && !_completedExercises.contains(key)) {
      _inProgressExercises.add(key);
      notifyListeners();
    }
  }
  
  void markExerciseComplete(String dayName, int exerciseIndex) {
    final key = "${dayName}_$exerciseIndex";
    // Remove from in-progress if it was there
    _inProgressExercises.remove(key);
    if (!_completedExercises.contains(key)) {
      _completedExercises.add(key);
      notifyListeners();
    }
  }
  
  bool isExerciseCompleted(String dayName, int exerciseIndex) {
    return _completedExercises.contains("${dayName}_$exerciseIndex");
  }
  
  bool isExerciseInProgress(String dayName, int exerciseIndex) {
    return _inProgressExercises.contains("${dayName}_$exerciseIndex");
  }
  
  void clearCompletedExercises() {
    _completedExercises.clear();
    _inProgressExercises.clear();
    notifyListeners();
  }

  // ---------------------------------------------------
  // JSON Egzersiz Verilerini Yükle
  // ---------------------------------------------------
  Future<void> loadData() async {
    try {
      print("📂 exercises.json yükleniyor...");

      final response =
          await rootBundle.loadString("assets/data/exercises.json");
      final List<dynamic> data = json.decode(response);

      _allExercises =
          data.map((e) => Exercise.fromJson(e as Map<String, dynamic>)).toList();

      print("✅ Egzersiz sayısı: ${_allExercises.length}");
      
      // Load saved programs
      await _loadSavedPrograms();
      
      // Load workout history and progress
      await _loadWorkoutHistory();
      await _loadProgress();
      
      // Load Phase 1 features
      await _loadPersonalRecords();
      await _loadStreakData();
      await _loadExerciseHistory();
      await _loadUserLevel();
      
      // Load water tracking
      await _loadWaterIntake();
      
      // Load favorite exercises
      await _loadFavoriteExercises();
    } catch (e) {
      print("❌ Veri yükleme hatası: $e");
    }

    notifyListeners();
  }

  // ---------------------------------------------------
  // Kaydedilmiş planı yükle
  // ---------------------------------------------------
  Future<void> _loadSavedPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('saved_workout_plan');

    if (saved != null) {
      final List decoded = jsonDecode(saved);
      _weeklyPlan =
          decoded.map((day) => WorkoutDay.fromJson(day, _allExercises)).toList();
    }
  }

  // ---------------------------------------------------
  // Yeni Haftalık Program Oluştur
  // ---------------------------------------------------
  // Manual Program Creation
  void createManualProgram(String name, int days) {
    _isLoading = true;
    notifyListeners();

    try {
      _weeklyPlan = List.generate(days, (index) {
        return WorkoutDay(
          dayName: 'Gün ${index + 1}',
          focus: 'Genel',
          exercises: [],
        );
      });

      _currentProgramId = 'manual_${DateTime.now().millisecondsSinceEpoch}';
      _currentProgramName = name;
      _currentGoal = 'Özel Program';
      _currentLevel = 'Özel';
      _currentDuration = 45; // Default duration
      _currentDays = days;
      _currentLocation = 'gym'; // Default location
      _isCurrentProgramSaved = false; // Reset saved flag for new program

      notifyListeners();
    } catch (e) {
      debugPrint('Error creating manual program: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> generateWeeklyPlan(
    String gender,
    String goal,
    String level,
    int days,
    String location,
    String? equipment,
    List<String>? focusAreas,
  ) async {
    _isLoading = true;
    notifyListeners();
    
    // Store current program metadata
    _currentGender = gender;
    _currentGoal = goal;
    _currentLevel = level;
    _currentLocation = location;
    _currentDays = days;
    _isCurrentProgramSaved = false; // Reset saved flag for new program

    try {
      GroqService service = GroqService();

      _weeklyPlan = await service.createWeeklyWorkout(
        _allExercises,
        goal,
        level,
        days,
        location,
        gender,
        equipment,
        focusAreas,
      );

      if (_weeklyPlan.isNotEmpty) {
        await _savePlan();
        _isLoading = false;
        notifyListeners();
        return {'success': true};
      } else {
        _isLoading = false;
        notifyListeners();
        return {
          'success': false,
          'error': 'Program oluşturulamadı. Lütfen tekrar deneyin.'
        };
      }
    } catch (e) {
      print("❌ generateWeeklyPlan hatası: $e");
      _isLoading = false;
      notifyListeners();
      
      // Extract error message from Exception
      String errorMessage = 'Bir hata oluştu. Lütfen tekrar deneyin.';
      if (e is Exception) {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }
      
      return {
        'success': false,
        'error': errorMessage
      };
    }
  }

  // ---------------------------------------------------
  // Planı Cihaza Kaydet
  // ---------------------------------------------------
  Future<void> _savePlan() async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> exportList = _weeklyPlan.map((day) {
      return {
        'day': day.dayName,
        'focus': day.focus,
        'exercises': day.exercises.map((ex) {
          return {
            'id': ex.exercise.id,
            'sets': ex.sets,
            'reps': ex.reps,
          };
        }).toList(),
      };
    }).toList();

    prefs.setString('saved_workout_plan', jsonEncode(exportList));
  }
  
  // ---------------------------------------------------
  // SAVED PROGRAMS MANAGEMENT
  // ---------------------------------------------------
  
  // Save current program with a name
  Future<bool> saveCurrentProgram(String name) async {
    if (_weeklyPlan.isEmpty) return false;
    
    // Check if current program is already saved
    if (_isCurrentProgramSaved) {
      print("⚠️ Bu program zaten kaydedilmiş!");
      return false;
    }
    
    try {
      print("📝 Creating SavedProgram object...");
      final program = SavedProgram.create(
        name: name,
        gender: _currentGender,
        goal: _currentGoal,
        level: _currentLevel,
        location: _currentLocation,
        daysPerWeek: _currentDays,
        plan: _weeklyPlan,
      );
      print("📝 SavedProgram object created: ${program.id}");
      
      _savedPrograms.add(program);
      print("📝 Added to _savedPrograms list. New length: ${_savedPrograms.length}");

      _isCurrentProgramSaved = true; // Mark as saved
      
      print("📝 Saving to SharedPreferences...");
      await _saveProgramsToStorage();
      print("📝 Saved to SharedPreferences.");
      
      notifyListeners();
      print("📝 Listeners notified.");
      
      print("✅ Program kaydedildi: $name");
      return true;
    } catch (e, stackTrace) {
      print("❌ Program kaydetme hatası: $e");
      print(stackTrace);
      return false;
    }
  }
  
  // Load all saved programs from storage
  Future<void> _loadSavedPrograms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final programsString = prefs.getString('saved_programs');
      
      if (programsString != null) {
        final List<dynamic> programsJson = jsonDecode(programsString);
        _savedPrograms = programsJson.map((json) => 
          SavedProgram.fromJson(json as Map<String, dynamic>, _allExercises)
        ).toList();
        
        print("✅ ${_savedPrograms.length} program yüklendi");
      }
    } catch (e) {
      print("❌ Programları yükleme hatası: $e");
      _savedPrograms = [];
    }
  }
  
  // Save programs to storage
  Future<void> _saveProgramsToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final programsJson = _savedPrograms.map((p) => p.toJson()).toList();
      await prefs.setString('saved_programs', jsonEncode(programsJson));
    } catch (e) {
      print("❌ Programları kaydetme hatası: $e");
    }
  }
  
  // Delete a program
  Future<bool> deleteProgram(String id) async {
    try {
      _savedPrograms.removeWhere((p) => p.id == id);
      await _saveProgramsToStorage();
      notifyListeners();
      
      print("✅ Program silindi: $id");
      return true;
    } catch (e) {
      print("❌ Program silme hatası: $e");
      return false;
    }
  }
  
  // Rename a program
  Future<bool> renameProgram(String id, String newName) async {
    try {
      final index = _savedPrograms.indexWhere((p) => p.id == id);
      if (index == -1) return false;
      
      _savedPrograms[index] = _savedPrograms[index].copyWith(name: newName);
      await _saveProgramsToStorage();
      notifyListeners();
      
      print("✅ Program yeniden adlandırıldı: $newName");
      return true;
    } catch (e) {
      print("❌ Program yeniden adlandırma hatası: $e");
      return false;
    }
  }
  
  // Load a specific program by ID
  void loadProgramById(String id) {
    final program = _savedPrograms.firstWhere(
      (p) => p.id == id,
      orElse: () => _savedPrograms.first,
    );
    
    _weeklyPlan = program.plan;
    _currentGender = program.gender;
    _currentGoal = program.goal;
    _currentLevel = program.level;
    _currentLocation = program.location;
    _currentDays = program.daysPerWeek;
    
    notifyListeners();
    print("✅ Program yüklendi: ${program.name}");
  }
  
  // ---------------------------------------------------
  // WORKOUT SESSION TRACKING
  // ---------------------------------------------------
  
  /// Save a completed workout session
  Future<bool> saveWorkoutSession(WorkoutSession session) async {
    try {
      _workoutHistory.add(session);
      await _saveWorkoutHistory();
      
      // Update progress for this program
      final programId = session.programId;
      final currentProgress = _programProgress[programId] ?? progress.WorkoutProgress(programId: programId);
      final updatedProgress = currentProgress.afterWorkout(session.dayName, session.startTime);
      
      // Check for personal records
      progress.WorkoutProgress progressWithPRs = updatedProgress;
      for (final set in session.completedSets) {
        if (set.weight != null && set.weight! > 0) {
          final exercise = _allExercises.firstWhere(
            (ex) => ex.id == set.exerciseId,
            orElse: () => _allExercises.first,
          );
          
          final pr = PersonalRecord(
            exerciseId: set.exerciseId,
            exerciseName: exercise.name,
            maxWeight: set.weight!,
            maxReps: set.reps,
            maxVolume: set.weight! * set.reps,
            achievedDate: set.timestamp,
            programId: programId,
            programName: _currentProgramName,
          );
          
          progressWithPRs = progressWithPRs.addPersonalRecord(progress.PersonalRecord(
            exerciseId: pr.exerciseId,
            exerciseName: pr.exerciseName,
            weight: pr.maxWeight,
            reps: pr.maxReps,
            date: pr.achievedDate,
          ));
        }
      }
      
      _programProgress[programId] = progressWithPRs;
      await _saveProgress();
      
      notifyListeners();
      print("✅ Workout session saved: ${session.id}");
      
      // Update streak
      updateStreakAfterWorkout();
      
      // ============ CLOUD BACKUP ============
      try {
        final authService = AuthService();
        final firestoreService = FirestoreService();
        final userId = await authService.getCurrentUserId();
        
        // Backup workout
        await firestoreService.saveWorkout(userId, session.toJson());
        print('✅ Workout backed up to cloud');
        
        // Update leaderboard
        final userName = 'User'; // Will be fetched from UserProfileProvider in future
        final totalVolume = session.completedSets.fold<double>(
          0.0,
          (sum, set) => sum + (set.weight ?? 0) * set.reps,
        );
        
        await firestoreService.updateLeaderboardStats(
          userId,
          userName,
          1, // +1 workout count
          totalVolume,
        );
        print('✅ Leaderboard updated');
      } catch (e) {
        print('⚠️ Cloud backup failed (offline?): $e');
        // App still works - data saved locally
      }
      // =======================================
      
      return true;
    } catch (e) {
      print("❌ Error saving workout session: $e");
      return false;
    }
  }
  
  /// Get workout history for a specific program
  List<WorkoutSession> getWorkoutHistoryForProgram(String programId) {
    return _workoutHistory
        .where((session) => session.programId == programId)
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime)); // Most recent first
  }
  
  /// Get progress for a specific program
  progress.WorkoutProgress? getProgressForProgram(String programId) {
    return _programProgress[programId];
  }
  
  /// Get last workout date for a program
  DateTime? getLastWorkoutDate(String programId) {
    final sessions = getWorkoutHistoryForProgram(programId);
    return sessions.isNotEmpty ? sessions.first.startTime : null;
  }
  
  /// Get total workouts this week
  int getWeeklyWorkoutCount() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    return _workoutHistory
        .where((session) => session.startTime.isAfter(weekStart))
        .length;
  }
  
  /// Get total workouts this month
  int getMonthlyWorkoutCount() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    
    return _workoutHistory
        .where((session) => session.startTime.isAfter(monthStart))
        .length;
  }
  
  /// Save workout history to storage
  Future<void> _saveWorkoutHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = _workoutHistory.map((s) => s.toJson()).toList();
      await prefs.setString('workout_history', jsonEncode(historyJson));
    } catch (e) {
      print("❌ Error saving workout history: $e");
    }
  }
  
  /// Load workout history from storage
  Future<void> _loadWorkoutHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyString = prefs.getString('workout_history');
      
      if (historyString != null) {
        final List<dynamic> historyJson = jsonDecode(historyString);
        _workoutHistory = historyJson
            .map((json) => WorkoutSession.fromJson(json as Map<String, dynamic>))
            .toList();
        
        print("✅ Loaded ${_workoutHistory.length} workout sessions");
      }
    } catch (e) {
      print("❌ Error loading workout history: $e");
      _workoutHistory = [];
    }
  }
  
  /// Save progress to storage
  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = _programProgress.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
      await prefs.setString('workout_progress', jsonEncode(progressJson));
    } catch (e) {
      print("❌ Error saving progress: $e");
    }
  }
  
  /// Load progress from storage
  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressString = prefs.getString('workout_progress');
      
      if (progressString != null) {
        final Map<String, dynamic> progressJson = jsonDecode(progressString);
        _programProgress = progressJson.map(
          (key, value) => MapEntry(
            key,
            progress.WorkoutProgress.fromJson(value as Map<String, dynamic>),
          ),
        );
        
        print("✅ Loaded progress for ${_programProgress.length} programs");
      }
    } catch (e) {
      print("❌ Error loading progress: $e");
      _programProgress = {};
    }
  }
  
  // ---------------------------------------------------
  // PROGRAM EDITING
  // ---------------------------------------------------
  
  /// Update the weekly plan with edited version
  void updateWeeklyPlan(List<WorkoutDay> newPlan) {
    _weeklyPlan = newPlan;
    _savePlan();
    notifyListeners();
    print("✅ Weekly plan updated");
  }
  

  // ---------------------------------------------------
  // PHASE 1: PERSONAL RECORDS TRACKING
  // ---------------------------------------------------
  
  PersonalRecord? checkAndUpdatePR({
    required String exerciseId,
    required String exerciseName,
    required double weight,
    required int reps,
    required String programId,
    required String programName,
  }) {
    final volume = weight * reps;
    final currentPR = _personalRecords[exerciseId];
    
    if (currentPR == null || currentPR.isBetterThan(weight, reps)) {
      final newPR = PersonalRecord(
        exerciseId: exerciseId,
        exerciseName: exerciseName,
        maxWeight: weight,
        maxReps: reps,
        maxVolume: volume,
        achievedDate: DateTime.now(),
        programId: programId,
        programName: programName,
      );
      
      _personalRecords[exerciseId] = newPR;
      _savePersonalRecords();
      
      _userLevel = _userLevel.addXP(50).incrementPRs();
      _saveUserLevel();
      
      notifyListeners();
      return newPR;
    }
    
    return null;
  }
  
  PersonalRecord? getPersonalRecord(String exerciseId) {
    return _personalRecords[exerciseId];
  }
  
  List<PersonalRecord> getAllPersonalRecords() {
    final records = _personalRecords.values.toList();
    records.sort((a, b) => b.achievedDate.compareTo(a.achievedDate));
    return records;
  }
  
  List<PersonalRecord> getRecentPRs({int days = 30}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return getAllPersonalRecords()
        .where((pr) => pr.achievedDate.isAfter(cutoff))
        .toList();
  }
  
  Future<void> _savePersonalRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prsJson = _personalRecords.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
      await prefs.setString('personal_records', jsonEncode(prsJson));
    } catch (e) {
      print('Error saving personal records: $e');
    }
  }
  
  Future<void> _loadPersonalRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prsString = prefs.getString('personal_records');
      
      if (prsString != null) {
        final Map<String, dynamic> prsJson = jsonDecode(prsString);
        _personalRecords = prsJson.map(
          (key, value) => MapEntry(
            key,
            PersonalRecord.fromJson(value as Map<String, dynamic>),
          ),
        );
        
        print('Loaded ${_personalRecords.length} personal records');
      }
    } catch (e) {
      print('Error loading personal records: $e');
      _personalRecords = {};
    }
  }
  
  // ---------------------------------------------------
  // PHASE 1: STREAK SYSTEM
  // ---------------------------------------------------
  
  void updateStreakAfterWorkout() {
    final oldStreak = _streakData.currentStreak;
    _streakData = _streakData.updateStreak(DateTime.now());
    final newStreak = _streakData.currentStreak;
    
    if (StreakModel.milestones.contains(newStreak) && 
        !_streakData.milestonesAchieved.contains(newStreak)) {
      final bonusXP = newStreak >= 30 ? 200 : 100;
      _userLevel = _userLevel.addXP(bonusXP);
      print('Streak milestone reached: $newStreak days! +$bonusXP XP');
    }
    
    _saveStreakData();
    _saveUserLevel();
    notifyListeners();
    
    print('Streak updated: $oldStreak -> $newStreak');
  }
  
  bool isStreakAtRisk() {
    return _streakData.isAtRisk;
  }
  
  int? getDaysUntilStreakBreak() {
    if (_streakData.lastActivityDate == null) return null;
    
    final now = DateTime.now();
    final daysSince = now.difference(_streakData.lastActivityDate!).inDays;
    
    if (daysSince >= 2) return 0;
    if (daysSince == 1) return 0;
    return 1;
  }
  
  Future<void> _saveStreakData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('streak_data', jsonEncode(_streakData.toJson()));
    } catch (e) {
      print('Error saving streak data: $e');
    }
  }
  
  Future<void> _loadStreakData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final streakString = prefs.getString('streak_data');
      
      if (streakString != null) {
        // Handle both old and new format if needed, but for now assume new format or compatible map
        final streakJson = jsonDecode(streakString);
        if (streakJson is String) {
           _streakData = StreakModel.fromJson(streakJson);
        } else {
           _streakData = StreakModel.fromMap(streakJson as Map<String, dynamic>);
        }
        
        print('Loaded streak data: ${_streakData.currentStreak} days');
      }
    } catch (e) {
      print('Error loading streak data: $e');
      _streakData = StreakModel.initial();
    }
  }
  
  // ---------------------------------------------------
  // PHASE 1: EXERCISE HISTORY
  // ---------------------------------------------------
  
  void saveExercisePerformance({
    required String exerciseId,
    required String exerciseName,
    required List<SetData> sets,
    required String programId,
    required String dayName,
    String? notes,
    int? rpe,
  }) {
    final history = ExerciseHistory(
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      workoutDate: DateTime.now(),
      sets: sets,
      notes: notes,
      rpe: rpe,
      programId: programId,
      dayName: dayName,
    );
    
    if (_exerciseHistory[exerciseId] == null) {
      _exerciseHistory[exerciseId] = [];
    }
    
    _exerciseHistory[exerciseId]!.add(history);
    _saveExerciseHistory();
    notifyListeners();
    
    print('Saved exercise history for $exerciseName');
  }
  
  ExerciseHistory? getLastWorkoutForExercise(String exerciseId) {
    final history = _exerciseHistory[exerciseId];
    if (history == null || history.isEmpty) return null;
    
    history.sort((a, b) => b.workoutDate.compareTo(a.workoutDate));
    return history.first;
  }
  
  List<ExerciseHistory> getExerciseHistoryList(String exerciseId) {
    final history = _exerciseHistory[exerciseId] ?? [];
    history.sort((a, b) => b.workoutDate.compareTo(a.workoutDate));
    return history;
  }
  
  String getProgressionSuggestion(String exerciseId) {
    final history = _exerciseHistory[exerciseId];
    if (history == null || history.length < 2) {
      return 'Complete all sets with good form';
    }
    
    history.sort((a, b) => b.workoutDate.compareTo(a.workoutDate));
    final lastWorkout = history[0];
    final previousWorkout = history[1];
    
    return lastWorkout.getSuggestion(previousWorkout: previousWorkout);
  }
  
  Future<void> _saveExerciseHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = _exerciseHistory.map(
        (key, value) => MapEntry(
          key,
          value.map((h) => h.toJson()).toList(),
        ),
      );
      await prefs.setString('exercise_history', jsonEncode(historyJson));
    } catch (e) {
      print('Error saving exercise history: $e');
    }
  }
  
  Future<void> _loadExerciseHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyString = prefs.getString('exercise_history');
      
      if (historyString != null) {
        final Map<String, dynamic> historyJson = jsonDecode(historyString);
        _exerciseHistory = historyJson.map(
          (key, value) => MapEntry(
            key,
            (value as List<dynamic>)
                .map((h) => ExerciseHistory.fromJson(h as Map<String, dynamic>))
                .toList(),
          ),
        );
        
        final totalCount = _exerciseHistory.values.fold(0, (sum, list) => sum + list.length);
        print('Loaded exercise history: $totalCount entries');
      }
    } catch (e) {
      print('Error loading exercise history: $e');
      _exerciseHistory = {};
    }
  }
  
  // ---------------------------------------------------
  // PHASE 1: GAMIFICATION (XP & LEVELS)
  // ---------------------------------------------------
  
  void addWorkoutXP({
    required int exerciseCount,
    required bool allSetsCompleted,
    int? newPRCount,
  }) {
    int xp = 100;
    
    if (allSetsCompleted) {
      xp += 25;
    }
    
    xp += exerciseCount * 5;
    
    final oldLevel = _userLevel.currentLevel;
    _userLevel = _userLevel.addXP(xp).incrementWorkouts();
    final newLevel = _userLevel.currentLevel;
    
    if (newLevel > oldLevel) {
      final reward = UserLevel.getRewardForLevel(newLevel);
      if (reward != null) {
        _userLevel = _userLevel.addXP(0, newReward: reward);
      }
      print('LEVEL UP! Now level $newLevel');
    }
    
    _saveUserLevel();
    notifyListeners();
    
    print('Added $xp XP. Total: ${_userLevel.totalXP}');
  }
  
  int getXPToNextLevel() {
    return _userLevel.xpToNextLevel;
  }
  
  double getLevelProgress() {
    return _userLevel.levelProgress;
  }
  
  bool checkLevelUp(int previousLevel) {
    return _userLevel.currentLevel > previousLevel;
  }
  
  Future<void> _saveUserLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_level', jsonEncode(_userLevel.toJson()));
    } catch (e) {
      print('Error saving user level: $e');
    }
  }
  
  Future<void> _loadUserLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final levelString = prefs.getString('user_level');
      
      if (levelString != null) {
        final levelJson = jsonDecode(levelString) as Map<String, dynamic>;
        _userLevel = UserLevel.fromJson(levelJson);
        
        print('Loaded user level: Level ${_userLevel.currentLevel}, ${_userLevel.totalXP} XP');
      }
    } catch (e) {
      print('Error loading user level: $e');
      _userLevel = UserLevel();
    }
  }
  
  // ---------------------------------------------------
  // WATER TRACKING
  // ---------------------------------------------------
  
  /// Add water intake
  Future<void> addWater(int ml) async {
    try {
      // Check if we need to reset for new day
      _resetWaterIfNewDay();
      
      // Initialize if null
      _todayWaterIntake ??= WaterIntake(
        date: DateTime.now(),
        goalMl: 2000, // Default 2L
      );
      
      _todayWaterIntake = _todayWaterIntake!.addWater(ml);
      await _saveWaterIntake();
      notifyListeners();
      
      print('Added ${ml}ml water. Total: ${_todayWaterIntake!.totalMl}ml');
    } catch (e) {
      print('Error adding water: $e');
    }
  }
  
  /// Set daily water goal
  Future<void> setWaterGoal(int goalMl) async {
    try {
      _resetWaterIfNewDay();
      
      _todayWaterIntake ??= WaterIntake(
        date: DateTime.now(),
        goalMl: goalMl,
      );
      
      _todayWaterIntake = _todayWaterIntake!.setGoal(goalMl);
      await _saveWaterIntake();
      notifyListeners();
      
      print('Water goal set to ${goalMl}ml');
    } catch (e) {
      print('Error setting water goal: $e');
    }
  }
  
  /// Reset water intake if it's a new day
  void _resetWaterIfNewDay() {
    if (_todayWaterIntake != null && !_todayWaterIntake!.isToday()) {
      print('New day detected! Resetting water intake...');
      // Keep the same goal for the new day
      _todayWaterIntake = _todayWaterIntake!.resetForNewDay();
    }
  }
  
  /// Save water intake data
  Future<void> _saveWaterIntake() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_todayWaterIntake != null) {
        await prefs.setString(
          'water_intake',
          jsonEncode(_todayWaterIntake!.toJson()),
        );
      }
    } catch (e) {
      print('Error saving water intake: $e');
    }
  }
  
  /// Load water intake data
  Future<void> _loadWaterIntake() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final waterString = prefs.getString('water_intake');
      
      if (waterString != null) {
        final waterJson = jsonDecode(waterString) as Map<String, dynamic>;
        _todayWaterIntake = WaterIntake.fromJson(waterJson);
        
        // Reset if it's not today's data
        _resetWaterIfNewDay();
        
        print('Loaded water intake: ${_todayWaterIntake?.totalMl}ml / ${_todayWaterIntake?.goalMl}ml');
      } else {
        // Initialize with default
        _todayWaterIntake = WaterIntake(
          date: DateTime.now(),
          goalMl: 2000,
        );
      }
    } catch (e) {
      print('Error loading water intake: $e');
      _todayWaterIntake = WaterIntake(
        date: DateTime.now(),
        goalMl: 2000,
      );
    }
  }
  // ---------------------------------------------------
  // PHASE 2: ADVANCED STATISTICS
  // ---------------------------------------------------

  /// Get volume data for the last [weeks] weeks
  /// Returns a list of spots for the line chart (x: week index, y: total volume)
  List<Map<String, dynamic>> getVolumeProgression({int weeks = 12}) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: weeks * 7));
    
    // Group by week
    final Map<int, double> weeklyVolume = {};
    
    for (final session in _workoutHistory) {
      if (session.startTime.isAfter(startDate)) {
        final difference = now.difference(session.startTime).inDays;
        final weekIndex = (difference / 7).floor();
        
        // Invert index so 0 is the oldest week, [weeks-1] is current
        final chartIndex = weeks - 1 - weekIndex;
        
        if (chartIndex >= 0) {
          weeklyVolume[chartIndex] = (weeklyVolume[chartIndex] ?? 0) + session.totalVolume;
        }
      }
    }
    
    // Convert to list format
    return List.generate(weeks, (index) {
      return {
        'x': index,
        'y': weeklyVolume[index] ?? 0.0,
        'label': 'Week ${index + 1}', // You might want actual dates here
      };
    });
  }

  /// Get muscle group distribution based on sets count
  Map<String, double> getMuscleGroupDistribution() {
    final Map<String, int> distribution = {};
    int totalSets = 0;

    for (final session in _workoutHistory) {
      // Use the session focus as a proxy for muscle group if detailed set data isn't enough
      // Or better, iterate through sets if we had muscle group data per exercise
      // For now, let's use the session focus
      final focus = session.focus;
      distribution[focus] = (distribution[focus] ?? 0) + session.totalSets;
      totalSets += session.totalSets;
    }

    if (totalSets == 0) return {};

    // Convert to percentage
    final Map<String, double> percentages = {};
    distribution.forEach((key, value) {
      percentages[key] = (value / totalSets) * 100;
    });

    return percentages;
  }

  /// Generate smart insights based on user data
  List<String> getSmartInsights() {
    final insights = <String>[];
    
    if (_workoutHistory.isEmpty) {
      insights.add("Complete your first workout to unlock insights! 🚀");
      return insights;
    }

    // 1. Day of week analysis
    final dayCounts = <int, int>{};
    for (final session in _workoutHistory) {
      final weekday = session.startTime.weekday;
      dayCounts[weekday] = (dayCounts[weekday] ?? 0) + 1;
    }
    
    if (dayCounts.isNotEmpty) {
      final bestDay = dayCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
      final dayName = _getDayName(bestDay.key);
      insights.add("You are most active on ${dayName}s! 🔥");
    }

    // 2. Volume trend
    final recentVolume = getVolumeProgression(weeks: 2);
    if (recentVolume.length >= 2) {
      final currentWeek = recentVolume.last['y'] as double;
      final lastWeek = recentVolume[recentVolume.length - 2]['y'] as double;
      
      if (currentWeek > lastWeek && lastWeek > 0) {
        final increase = ((currentWeek - lastWeek) / lastWeek * 100).toStringAsFixed(0);
        insights.add("Your volume is up $increase% this week! 💪");
      }
    }

    // 3. Streak insight
    if (_streakData.currentStreak > 3) {
      insights.add("You're on a ${_streakData.currentStreak} day streak! Keep it up! 🏃‍♂️");
    }

    // 4. PR Insight
    if (_personalRecords.isNotEmpty) {
      final latestPR = _personalRecords.values.reduce((a, b) => a.achievedDate.isAfter(b.achievedDate) ? a : b);
      final daysSince = DateTime.now().difference(latestPR.achievedDate).inDays;
      if (daysSince < 7) {
        insights.add("New PR on ${latestPR.exerciseName}: ${latestPR.maxWeight}kg! 🎉");
      }
    }

    return insights;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }
  
  // ---------------------------------------------------
  // FAVORITE EXERCISES (Quick Win Feature)
  // ---------------------------------------------------
  
  /// Toggle an exercise as favorite/unfavorite
  Future<void> toggleFavorite(String exerciseId) async {
    if (_favoriteExerciseIds.contains(exerciseId)) {
      _favoriteExerciseIds.remove(exerciseId);
      print('❤️ Removed from favorites: $exerciseId');
    } else {
      _favoriteExerciseIds.add(exerciseId);
      print('❤️ Added to favorites: $exerciseId');
    }
    
    await _saveFavoriteExercises();
    notifyListeners();
  }
  
  /// Check if an exercise is favorited
  bool isFavorite(String exerciseId) {
    return _favoriteExerciseIds.contains(exerciseId);
  }
  
  /// Get all favorite exercises
  List<Exercise> getFavoriteExercises() {
    return _allExercises
        .where((exercise) => _favoriteExerciseIds.contains(exercise.id))
        .toList();
  }
  
  /// Save favorite exercises to storage
  Future<void> _saveFavoriteExercises() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'favorite_exercises', 
        _favoriteExerciseIds.toList(),
      );
      print('✅ Saved ${_favoriteExerciseIds.length} favorite exercises');
    } catch (e) {
      print('❌ Error saving favorite exercises: $e');
    }
  }
  
  /// Load favorite exercises from storage
  Future<void> _loadFavoriteExercises() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorite_exercises');
      
      if (favorites != null) {
        _favoriteExerciseIds = Set<String>.from(favorites);
        print('✅ Loaded ${_favoriteExerciseIds.length} favorite exercises');
      }
    } catch (e) {
      print('❌ Error loading favorite exercises: $e');
      _favoriteExerciseIds = {};
    }
  }
}
