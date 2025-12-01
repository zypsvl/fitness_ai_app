import 'package:flutter_test/flutter_test.dart';
import 'package:gym_genius/models/weekly_plan_model.dart';
import 'package:gym_genius/models/exercise_model.dart';

void main() {
  group('WorkoutDay Model', () {
    test('creates workout day with all fields', () {
      // Arrange & Act
      final day = WorkoutDay(
        dayName: 'Monday',
        focus: 'Chest & Triceps',
        exercises: [],
      );

      // Assert
      expect(day.dayName, 'Monday');
      expect(day.focus, 'Chest & Triceps');
      expect(day.exercises.isEmpty, true);
    });

    test('fromJson creates workout day correctly', () {
      // Arrange
      final mockExercise = Exercise(
        id: 'squat',
        name: 'Squat',
        mechanic: 'compound',
        equipmentTier: 'barbell',
        primaryMuscle: 'quadriceps',
        secondaryMuscles: ['glutes', 'hamstrings'],
        bodyPart: 'legs',
        difficulty: 4,
      );

      final json = {
        'day': 'Leg Day',
        'focus': 'Lower Body',
        'exercises': [
          {'id': 'squat', 'sets': '4', 'reps': '6-8'},
        ],
      };

      // Act
      final day = WorkoutDay.fromJson(json, [mockExercise]);

      // Assert
      expect(day.dayName, 'Leg Day');
      expect(day.focus, 'Lower Body');
      expect(day.exercises.length, 1);
      expect(day.exercises.first.exercise.id, 'squat');
      expect(day.exercises.first.sets, '4');
      expect(day.exercises.first.reps, '6-8');
    });

    test('fromJson handles multiple exercises', () {
      // Arrange
      final exercises = [
        Exercise(
          id: 'bench',
          name: 'Bench Press',
          mechanic: 'compound',
          equipmentTier: 'barbell',
          primaryMuscle: 'chest',
          secondaryMuscles: [],
          bodyPart: 'upper',
          difficulty: 3,
        ),
        Exercise(
          id: 'dips',
          name: 'Dips',
          mechanic: 'compound',
          equipmentTier: 'bodyweight',
          primaryMuscle: 'triceps',
          secondaryMuscles: [],
          bodyPart: 'upper',
          difficulty: 3,
        ),
      ];

      final json = {
        'day': 'Push Day',
        'focus': 'Push Muscles',
        'exercises': [
          {'id': 'bench', 'sets': '3', 'reps': '10'},
          {'id': 'dips', 'sets': '3', 'reps': '12'},
        ],
      };

      // Act
      final day = WorkoutDay.fromJson(json, exercises);

      // Assert
      expect(day.exercises.length, 2);
      expect(day.exercises[0].exercise.name, 'Bench Press');
      expect(day.exercises[1].exercise.name, 'Dips');
    });
  });

  group('ScheduledExercise Model', () {
    test('creates scheduled exercise with all fields', () {
      // Arrange
      final exercise = Exercise(
        id: 'deadlift',
        name: 'Deadlift',
        mechanic: 'compound',
        equipmentTier: 'barbell',
        primaryMuscle: 'back',
        secondaryMuscles: ['hamstrings', 'glutes'],
        bodyPart: 'posterior chain',
        difficulty: 5,
      );

      // Act
      final scheduled = ScheduledExercise(
        exercise: exercise,
        sets: '5',
        reps: '5',
      );

      // Assert
      expect(scheduled.exercise.id, 'deadlift');
      expect(scheduled.sets, '5');
      expect(scheduled.reps, '5');
    });

    test('stores exercise reference correctly', () {
      // Arrange
      final exercise = Exercise(
        id: 'pullup',
        name: 'Pull-up',
        mechanic: 'compound',
        equipmentTier: 'bodyweight',
        primaryMuscle: 'lats',
        secondaryMuscles: ['biceps'],
        bodyPart: 'back',
        difficulty: 4,
      );

      // Act
      final scheduled = ScheduledExercise(
        exercise: exercise,
        sets: '3',
        reps: 'Max',
      );

      // Assert
      expect(scheduled.exercise.name, 'Pull-up');
      expect(scheduled.exercise.primaryMuscle, 'lats');
      expect(scheduled.reps, 'Max');
    });
  });
}
