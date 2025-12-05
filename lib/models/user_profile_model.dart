class UserProfile {
  final String id;
  final String name;
  final String? username; // Unique username like @johndoe
  final int? age;
  final String? gender;
  final double? height; // in cm
  final double? targetWeight; // in kg
  final String? activeProgramId;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  UserProfile({
    required this.id,
    required this.name,
    this.username,
    this.age,
    this.gender,
    this.height,
    this.targetWeight,
    this.activeProgramId,
    required this.createdAt,
    this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'age': age,
      'gender': gender,
      'height': height,
      'targetWeight': targetWeight,
      'activeProgramId': activeProgramId,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      height: json['height'] as double?,
      targetWeight: json['targetWeight'] as double?,
      activeProgramId: json['activeProgramId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? username,
    int? age,
    String? gender,
    double? height,
    double? targetWeight,
    String? activeProgramId,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      targetWeight: targetWeight ?? this.targetWeight,
      activeProgramId: activeProgramId ?? this.activeProgramId,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Calculate BMI if height and current weight are available
  double? calculateBMI(double? currentWeight) {
    if (height == null || currentWeight == null || height! <= 0) {
      return null;
    }
    final heightInMeters = height! / 100;
    return currentWeight / (heightInMeters * heightInMeters);
  }

  // Get BMI category
  String getBMICategory(double? bmi) {
    if (bmi == null) return 'Bilinmiyor';
    if (bmi < 18.5) return 'Zayıf';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Fazla Kilolu';
    return 'Obez';
  }
}
