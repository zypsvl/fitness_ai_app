import 'package:flutter_test/flutter_test.dart';
import 'package:gym_genius/models/exercise_model.dart';

void main() {
  group('Exercise Model', () {
    test('fromJson creates Exercise with all fields', () {
      // Arrange
      final json = {
        'id': 'exercise_1',
        'name': 'Bench Press',
        'mechanic': 'compound',
        'equipment_tier': 'barbell',
        'primary_muscle': 'chest',
        'secondary_muscles': ['triceps', 'shoulders'],
        'body_part': 'upper body',
        'difficulty': 3,
      };

      // Act
      final exercise = Exercise.fromJson(json);

      // Assert
      expect(exercise.id, 'exercise_1');
      expect(exercise.name, 'Bench Press');
      expect(exercise.mechanic, 'compound');
      expect(exercise.equipmentTier, 'barbell');
      expect(exercise.primaryMuscle, 'chest');
      expect(exercise.secondaryMuscles, ['triceps', 'shoulders']);
      expect(exercise.bodyPart, 'upper body');
      expect(exercise.difficulty, 3);
    });

    test('fromJson handles empty secondary muscles', () {
      // Arrange
      final json = {
        'id': 'exercise_2',
        'name': 'Plank',
        'mechanic': 'isolation',
        'equipment_tier': 'bodyweight',
        'primary_muscle': 'core',
        'secondary_muscles': [],
        'body_part': 'core',
        'difficulty': 1,
      };

      // Act
      final exercise = Exercise.fromJson(json);

      // Assert
      expect(exercise.secondaryMuscles.isEmpty, true);
    });

    test('assetPath returns correct path', () {
      // Arrange
      final exercise = Exercise(
        id: 'BENCH_PRESS_123',
        name: 'Bench Press',
        mechanic: 'compound',
        equipmentTier: 'barbell',
        primaryMuscle: 'chest',
        secondaryMuscles: [],
        bodyPart: 'upper',
        difficulty: 3,
      );

      // Act
      final path = exercise.assetPath;

      // Assert
      expect(path, 'assets/img/bench_press_123.gif');
    });
  });
}
