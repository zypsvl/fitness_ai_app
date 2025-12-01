import 'package:flutter_test/flutter_test.dart';
import 'package:gym_genius/models/saved_program_model.dart';
import 'package:gym_genius/models/weekly_plan_model.dart';
import 'package:gym_genius/models/exercise_model.dart';

void main() {
  group('SavedProgram Model', () {
    final mockExercise = Exercise(
      id: 'bench_press',
      name: 'Bench Press',
      mechanic: 'compound',
      equipmentTier: 'barbell',
      primaryMuscle: 'chest',
      secondaryMuscles: ['triceps'],
      bodyPart: 'upper',
      difficulty: 3,
    );

    final mockPlan = [
      WorkoutDay(
        dayName: 'Day 1',
        focus: 'Chest',
        exercises: [
          ScheduledExercise(
            exercise: mockExercise,
            sets: '3',
            reps: '10',
          ),
        ],
      ),
    ];

    test('create factory generates valid program', () {
      // Act
      final program = SavedProgram.create(
        name: 'Test Program',
        gender: 'male',
        goal: 'muscle building',
        level: 'beginner',
        location: 'gym',
        daysPerWeek: 3,
        plan: mockPlan,
      );

      // Assert
      expect(program.id.isNotEmpty, true); // UUID generated
      expect(program.name, 'Test Program');
      expect(program.gender, 'male');
      expect(program.goal, 'muscle building');
      expect(program.level, 'beginner');
      expect(program.location, 'gym');
      expect(program.daysPerWeek, 3);
      expect(program.plan.length, 1);
    });

    test('toJson serializes correctly', () {
      // Arrange
      final program = SavedProgram.create(
        name: 'Test',
        gender: 'female',
        goal: 'fat loss',
        level: 'intermediate',
        location: 'home',
        daysPerWeek: 4,
        plan: mockPlan,
      );

      // Act
      final json = program.toJson();

      // Assert
      expect(json['name'], 'Test');
      expect(json['gender'], 'female');
      expect(json['goal'], 'fat loss');
      expect(json['level'], 'intermediate');
      expect(json['location'], 'home');
      expect(json['daysPerWeek'], 4);
      expect(json['plan'] is List, true);
    });

    test('fromJson deserializes correctly', () {
      // Arrange
      final json = {
        'id': 'test-id-123',
        'name': 'Restored Program',
        'createdAt': DateTime.now().toIso8601String(),
        'gender': 'male',
        'goal': 'strength',
        'level': 'advanced',
        'location': 'gym',
        'daysPerWeek': 5,
        'plan': [
          {
            'day': 'Day 1',
            'focus': 'Chest',
            'exercises': [
              {
                'id': 'bench_press',
                'sets': '4',
                'reps': '8',
              },
            ],
          },
        ],
      };

      // Act
      final program = SavedProgram.fromJson(json, [mockExercise]);

      // Assert
      expect(program.id, 'test-id-123');
      expect(program.name, 'Restored Program');
      expect(program.gender, 'male');
      expect(program.daysPerWeek, 5);
      expect(program.plan.length, 1);
    });

    test('copyWith creates modified copy', () {
      // Arrange
      final original = SavedProgram.create(
        name: 'Old Name',
        gender: 'male',
        goal: 'fitness',
        level: 'beginner',
        location: 'gym',
        daysPerWeek: 3,
        plan: mockPlan,
      );

      // Act
      final modified = original.copyWith(name: 'New Name');

      // Assert
      expect(modified.name, 'New Name');
      expect(modified.id, original.id); // ID unchanged
      expect(modified.gender, original.gender);
    });

    test('totalExercises calculates correctly', () {
      // Arrange
      final planWithMultipleDays = [
        WorkoutDay(
          dayName: 'Day 1',
          focus: 'Chest',
          exercises: [
            ScheduledExercise(exercise: mockExercise, sets: '3', reps: '10'),
            ScheduledExercise(exercise: mockExercise, sets: '3', reps: '12'),
          ],
        ),
        WorkoutDay(
          dayName: 'Day 2',
          focus: 'Back',
          exercises: [
            ScheduledExercise(exercise: mockExercise, sets: '4', reps: '8'),
          ],
        ),
      ];

      final program = SavedProgram.create(
        name: 'Test',
        gender: 'male',
        goal: 'muscle',
        level: 'beginner',
        location: 'gym',
        daysPerWeek: 2,
        plan: planWithMultipleDays,
      );

      // Act & Assert
      expect(program.totalExercises, 3);
    });

    test('totalExercises returns 0 for empty plan', () {
      // Arrange
      final program = SavedProgram.create(
        name: 'Empty',
        gender: 'male',
        goal: 'fitness',
        level: 'beginner',
        location: 'gym',
        daysPerWeek: 0,
        plan: [],
      );

      // Act & Assert
      expect(program.totalExercises, 0);
    });
  });
}
