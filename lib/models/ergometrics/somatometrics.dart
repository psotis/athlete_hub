import 'dart:convert';
import 'package:equatable/equatable.dart';

class Somatometrics extends Equatable {
  final String id;
  final String sessionId;

  final double? apeIndex;
  final double? bmi;

  final double? heightCm;
  final double? armSpanCm;
  final double? weightKg;
  final double? bodyFatPercent;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Somatometrics(
    this.id,
    this.sessionId,
    this.apeIndex,
    this.bmi,
    this.heightCm,
    this.armSpanCm,
    this.weightKg,
    this.bodyFatPercent,
    this.createdAt,
    this.updatedAt,
  );

  factory Somatometrics.initial() {
    return const Somatometrics(
      '',
      '',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    );
  }

  factory Somatometrics.fromMap(Map<String, dynamic> map) {
    return Somatometrics(
      (map['id'] ?? '').toString(),
      (map['session_id'] ?? '').toString(),

      (map['ape_index'] as num?)?.toDouble(),
      (map['bmi'] as num?)?.toDouble(),

      (map['height_cm'] as num?)?.toDouble(),
      (map['arm_span_cm'] as num?)?.toDouble(),
      (map['weight_kg'] as num?)?.toDouble(),
      (map['body_fat_percent'] as num?)?.toDouble(),

      map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
      map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,

      'ape_index': apeIndex,
      'bmi': bmi,

      'height_cm': heightCm,
      'arm_span_cm': armSpanCm,
      'weight_kg': weightKg,
      'body_fat_percent': bodyFatPercent,

      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Somatometrics.fromJson(String source) =>
      Somatometrics.fromMap(json.decode(source) as Map<String, dynamic>);

  Somatometrics copyWith({
    String? id,
    String? sessionId,
    double? apeIndex,
    double? bmi,
    double? heightCm,
    double? armSpanCm,
    double? weightKg,
    double? bodyFatPercent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Somatometrics(
      id ?? this.id,
      sessionId ?? this.sessionId,
      apeIndex ?? this.apeIndex,
      bmi ?? this.bmi,
      heightCm ?? this.heightCm,
      armSpanCm ?? this.armSpanCm,
      weightKg ?? this.weightKg,
      bodyFatPercent ?? this.bodyFatPercent,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sessionId,
    apeIndex,
    bmi,
    heightCm,
    armSpanCm,
    weightKg,
    bodyFatPercent,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
