import 'package:flutter_test/flutter_test.dart';
import 'package:gym_genius/providers/workout_provider.dart';
import 'package:gym_genius/models/weekly_plan_model.dart';
import 'package:gym_genius/models/exercise_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Setup: Run before each test
  setUp(() {
    // Initialize mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
  });

  group('WorkoutProvider - Exercise Completion Tracking', () {
    test('markExerciseComplete adds exercise to completed set', () {
      // Arrange
      final provider = WorkoutProvider();
      const dayName = 'Day 1';
      const exerciseIndex = 0;

      // Act
      provider.markExerciseComplete(dayName, exerciseIndex);

      // Assert
      expect(provider.isExerciseCompleted(dayName, exerciseIndex), true);
      expect(provider.completedExercises.length, 1);
    });

    test('markExerciseComplete does not add duplicate', () {
      // Arrange
      final provider = WorkoutProvider();
      const dayName = 'Day 1';
      const exerciseIndex = 0;

      // Act
      provider.markExerciseComplete(dayName, exerciseIndex);
      provider.markExerciseComplete(dayName, exerciseIndex); // Duplicate

      // Assert
      expect(provider.completedExercises.length, 1);
    });

    test('isExerciseCompleted returns false for uncompleted exercise', () {
      // Arrange
      final provider = WorkoutProvider();

      // Assert
      expect(provider.isExerciseCompleted('Day 1', 0), false);
    });

    test('clearCompletedExercises removes all completed exercises', () {
      // Arrange
      final provider = WorkoutProvider();
      provider.markExerciseComplete('Day 1', 0);
      provider.markExerciseComplete('Day 1', 1);
      provider.markExerciseComplete('Day 2', 0);

      // Act
      provider.clearCompletedExercises();

      // Assert
      expect(provider.completedExercises.isEmpty, true);
    });
  });

  group('WorkoutProvider - Manual Program Creation', () {
    test('createManualProgram creates correct number of days', () {
      // Arrange
      final provider = WorkoutProvider();
      const programName = 'Test Program';
      const days = 5;

      // Act
      provider.createManualProgram(programName, days);

      // Assert
      expect(provider.weeklyPlan.length, days);
      expect(provider.currentProgramName, programName);
      expect(provider.isCurrentProgramSaved, false);
    });

    test('createManualProgram creates empty workout days', () {
      // Arrange
      final provider = WorkoutProvider();

      // Act
      provider.createManualProgram('Test', 3);

      // Assert
      for (final day in provider.weeklyPlan) {
        expect(day.exercises.isEmpty, true);
        expect(day.focus, 'Genel');
      }
    });

    test('createManualProgram sets loading state correctly', () async {
      // Arrange
      final provider = WorkoutProvider();
      
      // Act
      provider.createManualProgram('Test', 3);
      
      // Assert
      expect(provider.isLoading, false); // Should be false after completion
    });
  });

  group('WorkoutProvider - Program Management', () {
    test('saveCurrentProgram returns false when no plan exists', () async {
      // Arrange
      final provider = WorkoutProvider();

      // Act
      final result = await provider.saveCurrentProgram('Test');

      // Assert
      expect(result, false);
    });

    test('saveCurrentProgram returns false when already saved', () async {
      // Arrange
      final provider = WorkoutProvider();
      provider.createManualProgram('Test', 3);
      
      // First save
      await provider.saveCurrentProgram('Test Program');

      // Act - Try to save again
      final result = await provider.saveCurrentProgram('Test Program');

      // Assert
      expect(result, false);
    });

    test('saveCurrentProgram adds program to savedPrograms', () async {
      // Arrange
      final provider = WorkoutProvider();
      provider.createManualProgram('Test', 3);

      // Act
      final result = await provider.saveCurrentProgram('My Program');

      // Assert
      expect(result, true);
      expect(provider.savedPrograms.length, 1);
      expect(provider.savedPrograms.first.name, 'My Program');
      expect(provider.isCurrentProgramSaved, true);
    });

    test('deleteProgram removes program from list', () async {
      // Arrange
      final provider = WorkoutProvider();
      provider.createManualProgram('Test', 3);
      await provider.saveCurrentProgram('Program 1');
      final programId = provider.savedPrograms.first.id;

      // Act
      final result = await provider.deleteProgram(programId);

      // Assert
      expect(result, true);
      expect(provider.savedPrograms.isEmpty, true);
    });

    test('renameProgram updates program name', () async {
      // Arrange
      final provider = WorkoutProvider();
      provider.createManualProgram('Test', 3);
      await provider.saveCurrentProgram('Old Name');
      final programId = provider.savedPrograms.first.id;

      // Act
      final result = await provider.renameProgram(programId, 'New Name');

      // Assert
      expect(result, true);
      expect(provider.savedPrograms.first.name, 'New Name');
    });

    test('renameProgram returns false for non-existent program', () async {
      // Arrange
      final provider = WorkoutProvider();

      // Act
      final result = await provider.renameProgram('fake-id', 'New Name');

      // Assert
      expect(result, false);
    });
  });

  group('WorkoutProvider - Workout Statistics', () {
    test('getWeeklyWorkoutCount returns 0 initially', () {
      // Arrange
      final provider = WorkoutProvider();

      // Act
      final count = provider.getWeeklyWorkoutCount();

      // Assert
      expect(count, 0);
    });

    test('getMonthlyWorkoutCount returns 0 initially', () {
      // Arrange
      final provider = WorkoutProvider();

      // Act
      final count = provider.getMonthlyWorkoutCount();

      // Assert
      expect(count, 0);
    });
  });

  group('WorkoutProvider - Weekly Plan Updates', () {
    test('updateWeeklyPlan updates the plan', () {
      // Arrange
      final provider = WorkoutProvider();
      final newPlan = [
        WorkoutDay(
          dayName: 'Custom Day',
          focus: 'Upper Body',
          exercises: [],
        ),
      ];

      // Act
      provider.updateWeeklyPlan(newPlan);

      // Assert
      expect(provider.weeklyPlan.length, 1);
      expect(provider.weeklyPlan.first.dayName, 'Custom Day');
    });
  });

  group('WorkoutProvider - Initial State', () {
    test('initial state is correct', () {
      // Arrange & Act
      final provider = WorkoutProvider();

      // Assert
      expect(provider.weeklyPlan.isEmpty, true);
      expect(provider.isLoading, false);
      expect(provider.allExercises.isEmpty, true);
      expect(provider.savedPrograms.isEmpty, true);
      expect(provider.isCurrentProgramSaved, false);
      expect(provider.completedExercises.isEmpty, true);
    });
  });
}
