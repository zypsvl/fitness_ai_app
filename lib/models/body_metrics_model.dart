import 'dart:math';

class BodyMetrics {
  final double height; // cm
  final double weight; // kg
  final double? neck; // cm (for body fat calculation)
  final double? waist; // cm
  final double? hip; // cm (for women's body fat and waist-to-hip ratio)
  final DateTime date;
  final String gender; // 'male' or 'female'

  BodyMetrics({
    required this.height,
    required this.weight,
    required this.gender,
    this.neck,
    this.waist,
    this.hip,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  /// Calculate Body Mass Index (BMI)
  /// Formula: weight (kg) / (height (m))^2
  double get bmi {
    if (height <= 0) return 0;
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  String get bmiCategory {
    if (bmi < 18.5) return 'underweight';
    if (bmi < 25) return 'normal';
    if (bmi < 30) return 'overweight';
    return 'obese';
  }

  /// Calculate Body Fat Percentage using Navy Method
  /// Men: 495 / (1.0324 - 0.19077 * log(waist - neck) + 0.15456 * log(height)) - 450
  /// Women: 495 / (1.29579 - 0.35004 * log(waist + hip - neck) + 0.22100 * log(height)) - 450
  double? get bodyFatPercentage {
    if (neck == null || waist == null) return null;
    if (neck! <= 0 || waist! <= 0 || height <= 0) return null;

    try {
      if (gender.toLowerCase() == 'male' || gender.toLowerCase() == 'erkek') {
        // Navy Method for Men
        final logWaistMinusNeck = log(waist! - neck!) / ln10;
        final logHeight = log(height) / ln10;
        final bodyFat = 495 / (1.0324 - 0.19077 * logWaistMinusNeck + 0.15456 * logHeight) - 450;
        return bodyFat.clamp(0, 100);
      } else {
        // Navy Method for Women
        if (hip == null || hip! <= 0) return null;
        final logWaistPlusHipMinusNeck = log(waist! + hip! - neck!) / ln10;
        final logHeight = log(height) / ln10;
        final bodyFat = 495 / (1.29579 - 0.35004 * logWaistPlusHipMinusNeck + 0.22100 * logHeight) - 450;
        return bodyFat.clamp(0, 100);
      }
    } catch (e) {
      return null;
    }
  }

  /// Get body fat category
  String? get bodyFatCategory {
    final bf = bodyFatPercentage;
    if (bf == null) return null;

    if (gender.toLowerCase() == 'male' || gender.toLowerCase() == 'erkek') {
      // Male body fat categories
      if (bf < 6) return 'essential';
      if (bf < 14) return 'athlete';
      if (bf < 18) return 'fitness';
      if (bf < 25) return 'average';
      return 'obese';
    } else {
      // Female body fat categories
      if (bf < 14) return 'essential';
      if (bf < 21) return 'athlete';
      if (bf < 25) return 'fitness';
      if (bf < 32) return 'average';
      return 'obese';
    }
  }

  /// Calculate Waist-to-Hip Ratio (WHR)
  /// Formula: waist / hip
  /// Health risk indicator (higher ratio = higher risk)
  double? get waistToHipRatio {
    if (waist == null || hip == null) return null;
    if (hip! <= 0) return null;
    return waist! / hip!;
  }

  /// Get WHR health risk category
  String? get whrCategory {
    final whr = waistToHipRatio;
    if (whr == null) return null;

    if (gender.toLowerCase() == 'male' || gender.toLowerCase() == 'erkek') {
      // Male WHR categories
      if (whr < 0.95) return 'low_risk';
      if (whr < 1.0) return 'moderate_risk';
      return 'high_risk';
    } else {
      // Female WHR categories
      if (whr < 0.80) return 'low_risk';
      if (whr < 0.85) return 'moderate_risk';
      return 'high_risk';
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'neck': neck,
      'waist': waist,
      'hip': hip,
      'date': date.toIso8601String(),
      'gender': gender,
    };
  }

  /// Create from JSON
  factory BodyMetrics.fromJson(Map<String, dynamic> json) {
    return BodyMetrics(
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      gender: json['gender'] as String,
      neck: json['neck'] != null ? (json['neck'] as num).toDouble() : null,
      waist: json['waist'] != null ? (json['waist'] as num).toDouble() : null,
      hip: json['hip'] != null ? (json['hip'] as num).toDouble() : null,
      date: DateTime.parse(json['date'] as String),
    );
  }

  /// Copy with updated values
  BodyMetrics copyWith({
    double? height,
    double? weight,
    String? gender,
    double? neck,
    double? waist,
    double? hip,
    DateTime? date,
  }) {
    return BodyMetrics(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      neck: neck ?? this.neck,
      waist: waist ?? this.waist,
      hip: hip ?? this.hip,
      date: date ?? this.date,
    );
  }
}
