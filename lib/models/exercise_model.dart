class Exercise {
  final String id;
  final String name;
  final String mechanic;
  final String equipmentTier;
  final String primaryMuscle;
  final List<String> secondaryMuscles;
  final String bodyPart;
  final int difficulty;
  
  // New fields for exercise instructions
  final String? videoUrl;
  final String? gifUrl;
  final List<String>? instructions;
  final List<String>? tips;
  final List<String>? commonMistakes;

  Exercise({
    required this.id,
    required this.name,
    required this.mechanic,
    required this.equipmentTier,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.bodyPart,
    required this.difficulty,
    this.videoUrl,
    this.gifUrl,
    this.instructions,
    this.tips,
    this.commonMistakes,
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
      videoUrl: json['video_url'] as String?,
      gifUrl: json['gif_url'] as String?,
      instructions: json['instructions'] != null
          ? (json['instructions'] as List).map((e) => e.toString()).toList()
          : null,
      tips: json['tips'] != null
          ? (json['tips'] as List).map((e) => e.toString()).toList()
          : null,
      commonMistakes: json['common_mistakes'] != null
          ? (json['common_mistakes'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }

  String get assetPath {
    return "assets/img/${id.toLowerCase()}.gif";
  }
  
  // Difficulty label helper
  String get difficultyLabel {
    switch (difficulty) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Advanced';
      default:
        return 'Intermediate';
    }
  }
  
  // Check if exercise has detailed instructions
  bool get hasInstructions => instructions != null && instructions!.isNotEmpty;
  bool get hasTips => tips != null && tips!.isNotEmpty;
  bool get hasCommonMistakes => commonMistakes != null && commonMistakes!.isNotEmpty;
  bool get hasMedia => videoUrl != null || gifUrl != null;
}
