import '../models/exercise_model.dart';
import '../models/weekly_plan_model.dart';

/// Abstract interface for AI services that generate workout plans
/// This allows easy switching between different AI providers (Gemini, Groq, etc.)
abstract class AIService {
  /// Creates a weekly workout plan based on user preferences
  /// 
  /// Parameters:
  /// - [allExercises]: Complete list of available exercises
  /// - [userGoal]: User's fitness goal (e.g., "Lose Weight", "Build Muscle")
  /// - [level]: User's fitness level ("Beginner", "Intermediate", "Advanced")
  /// - [daysAvailable]: Number of workout days per week (1-7)
  /// - [location]: Workout location ("Gym" or "Home")
  /// - [gender]: User's gender ("Male" or "Female")
  /// 
  /// Returns a list of [WorkoutDay] objects representing the weekly plan
  /// Throws an [Exception] if the plan cannot be generated
  Future<List<WorkoutDay>> createWeeklyWorkout(
    List<Exercise> allExercises,
    String userGoal,
    String level,
    int daysAvailable,
    String location,
    String gender,
  );
}
