import 'package:uuid/uuid.dart';

class BodyMeasurement {
  final String id;
  final DateTime date;
  final double weight; // in kg
  final double? chest; // in cm
  final double? waist; // in cm
  final double? hips; // in cm
  final double? arms; // in cm
  final double? thighs; // in cm
  final String? notes;

  BodyMeasurement({
    required this.id,
    required this.date,
    required this.weight,
    this.chest,
    this.waist,
    this.hips,
    this.arms,
    this.thighs,
    this.notes,
  });

  factory BodyMeasurement.create({
    required double weight,
    double? chest,
    double? waist,
    double? hips,
    double? arms,
    double? thighs,
    String? notes,
  }) {
    return BodyMeasurement(
      id: const Uuid().v4(),
      date: DateTime.now(),
      weight: weight,
      chest: chest,
      waist: waist,
      hips: hips,
      arms: arms,
      thighs: thighs,
      notes: notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
      'chest': chest,
      'waist': waist,
      'hips': hips,
      'arms': arms,
      'thighs': thighs,
      'notes': notes,
    };
  }

  factory BodyMeasurement.fromJson(Map<String, dynamic> json) {
    return BodyMeasurement(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num).toDouble(),
      chest: json['chest'] as double?,
      waist: json['waist'] as double?,
      hips: json['hips'] as double?,
      arms: json['arms'] as double?,
      thighs: json['thighs'] as double?,
      notes: json['notes'] as String?,
    );
  }

  BodyMeasurement copyWith({
    String? id,
    DateTime? date,
    double? weight,
    double? chest,
    double? waist,
    double? hips,
    double? arms,
    double? thighs,
    String? notes,
  }) {
    return BodyMeasurement(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      hips: hips ?? this.hips,
      arms: arms ?? this.arms,
      thighs: thighs ?? this.thighs,
      notes: notes ?? this.notes,
    );
  }

  // Calculate percentage change from another measurement
  double getWeightChange(BodyMeasurement other) {
    if (other.weight == 0) return 0;
    return ((weight - other.weight) / other.weight) * 100;
  }

  double? getChestChange(BodyMeasurement other) {
    if (chest == null || other.chest == null || other.chest == 0) return null;
    return ((chest! - other.chest!) / other.chest!) * 100;
  }

  double? getWaistChange(BodyMeasurement other) {
    if (waist == null || other.waist == null || other.waist == 0) return null;
    return ((waist! - other.waist!) / other.waist!) * 100;
  }

  double? getHipsChange(BodyMeasurement other) {
    if (hips == null || other.hips == null || other.hips == 0) return null;
    return ((hips! - other.hips!) / other.hips!) * 100;
  }

  double? getArmsChange(BodyMeasurement other) {
    if (arms == null || other.arms == null || other.arms == 0) return null;
    return ((arms! - other.arms!) / other.arms!) * 100;
  }

  double? getThighsChange(BodyMeasurement other) {
    if (thighs == null || other.thighs == null || other.thighs == 0) return null;
    return ((thighs! - other.thighs!) / other.thighs!) * 100;
  }
}
