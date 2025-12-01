class Exercise {
  final String id;
  final String name;
  final String mechanic;
  final String equipmentTier;
  final String primaryMuscle;
  final List<String> secondaryMuscles;
  final String bodyPart;
  final int difficulty;

  Exercise({
    required this.id,
    required this.name,
    required this.mechanic,
    required this.equipmentTier,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.bodyPart,
    required this.difficulty,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      mechanic: json['mechanic'],
      equipmentTier: json['equipment_tier'],
      primaryMuscle: json['primary_muscle'],
      secondaryMuscles:
          (json['secondary_muscles'] as List).map((e) => e.toString()).toList(),
      bodyPart: json['body_part'],
      difficulty: json['difficulty'],
    );
  }

  String get assetPath {
    return "assets/img/${id.toLowerCase()}.gif";
  }
}
