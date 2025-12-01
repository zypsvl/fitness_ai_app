import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise_model.dart';
import '../models/weekly_plan_model.dart';
import '../models/saved_program_model.dart';
import '../models/workout_session_model.dart';
import '../models/workout_progress_model.dart';
import '../services/groq_service.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Exercise> _allExercises = [];
  List<WorkoutDay> _weeklyPlan = [];
  bool _isLoading = false;
  
  // Saved programs management
  List<SavedProgram> _savedPrograms = [];
  
  // Workout tracking
  List<WorkoutSession> _workoutHistory = [];
  Map<String, WorkoutProgress> _programProgress = {};
  
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

  List<WorkoutDay> get weeklyPlan => _weeklyPlan;
  bool get isLoading => _isLoading;
  List<Exercise> get allExercises => _allExercises;
  List<SavedProgram> get savedPrograms => _savedPrograms;
  bool get isCurrentProgramSaved => _isCurrentProgramSaved;
  List<WorkoutSession> get workoutHistory => _workoutHistory;
  Map<String, WorkoutProgress> get programProgress => _programProgress;
  Set<String> get completedExercises => _completedExercises;
  String get currentProgramName => _currentProgramName;

  // ---------------------------------------------------
  // EXERCISE COMPLETION TRACKING
  // ---------------------------------------------------
  
  void markExerciseComplete(String dayName, int exerciseIndex) {
    final key = "${dayName}_$exerciseIndex";
    if (!_completedExercises.contains(key)) {
      _completedExercises.add(key);
      notifyListeners();
    }
  }
  
  bool isExerciseCompleted(String dayName, int exerciseIndex) {
    return _completedExercises.contains("${dayName}_$exerciseIndex");
  }
  
  void clearCompletedExercises() {
    _completedExercises.clear();
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
      final currentProgress = _programProgress[programId] ?? WorkoutProgress(programId: programId);
      final updatedProgress = currentProgress.afterWorkout(session.dayName, session.startTime);
      
      // Check for personal records
      WorkoutProgress progressWithPRs = updatedProgress;
      for (final set in session.completedSets) {
        if (set.weight != null && set.weight! > 0) {
          final exercise = _allExercises.firstWhere(
            (ex) => ex.id == set.exerciseId,
            orElse: () => _allExercises.first,
          );
          
          final pr = PersonalRecord(
            exerciseId: set.exerciseId,
            exerciseName: exercise.name,
            weight: set.weight!,
            reps: set.reps,
            date: set.timestamp,
          );
          
          progressWithPRs = progressWithPRs.addPersonalRecord(pr);
        }
      }
      
      _programProgress[programId] = progressWithPRs;
      await _saveProgress();
      
      notifyListeners();
      print("✅ Workout session saved: ${session.id}");
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
  WorkoutProgress? getProgressForProgram(String programId) {
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
            WorkoutProgress.fromJson(value as Map<String, dynamic>),
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
}
