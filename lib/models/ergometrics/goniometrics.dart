import 'dart:convert';
import 'package:equatable/equatable.dart';

class Goniometrics extends Equatable {
  final String id;
  final String sessionId;

  final double? legRlRatio;
  final double? kneeRlRatio;
  final double? hipTotal;

  final double? hipFlexionRightDeg;
  final double? hipFlexionLeftDeg;

  final double? kneeFlexionRightDeg;
  final double? kneeFlexionLeftDeg;

  final double? hipInternalRotationRightDeg;
  final double? hipInternalRotationLeftDeg;

  final double? hipExternalRotationRightDeg;
  final double? hipExternalRotationLeftDeg;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Goniometrics(
    this.id,
    this.sessionId,
    this.legRlRatio,
    this.kneeRlRatio,
    this.hipTotal,
    this.hipFlexionRightDeg,
    this.hipFlexionLeftDeg,
    this.kneeFlexionRightDeg,
    this.kneeFlexionLeftDeg,
    this.hipInternalRotationRightDeg,
    this.hipInternalRotationLeftDeg,
    this.hipExternalRotationRightDeg,
    this.hipExternalRotationLeftDeg,
    this.createdAt,
    this.updatedAt,
  );

  factory Goniometrics.initial() {
    return const Goniometrics(
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
      null,
      null,
      null,
      null,
      null,
    );
  }

  factory Goniometrics.fromMap(Map<String, dynamic> map) {
    return Goniometrics(
      (map['id'] ?? '').toString(),
      (map['session_id'] ?? '').toString(),

      (map['leg_rl_ratio'] as num?)?.toDouble(),
      (map['knee_rl_ratio'] as num?)?.toDouble(),
      (map['hip_total'] as num?)?.toDouble(),

      (map['hip_flexion_right_deg'] as num?)?.toDouble(),
      (map['hip_flexion_left_deg'] as num?)?.toDouble(),

      (map['knee_flexion_right_deg'] as num?)?.toDouble(),
      (map['knee_flexion_left_deg'] as num?)?.toDouble(),

      (map['hip_internal_rotation_right_deg'] as num?)?.toDouble(),
      (map['hip_internal_rotation_left_deg'] as num?)?.toDouble(),

      (map['hip_external_rotation_right_deg'] as num?)?.toDouble(),
      (map['hip_external_rotation_left_deg'] as num?)?.toDouble(),

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

      'leg_rl_ratio': legRlRatio,
      'knee_rl_ratio': kneeRlRatio,
      'hip_total': hipTotal,

      'hip_flexion_right_deg': hipFlexionRightDeg,
      'hip_flexion_left_deg': hipFlexionLeftDeg,

      'knee_flexion_right_deg': kneeFlexionRightDeg,
      'knee_flexion_left_deg': kneeFlexionLeftDeg,

      'hip_internal_rotation_right_deg': hipInternalRotationRightDeg,
      'hip_internal_rotation_left_deg': hipInternalRotationLeftDeg,

      'hip_external_rotation_right_deg': hipExternalRotationRightDeg,
      'hip_external_rotation_left_deg': hipExternalRotationLeftDeg,

      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Goniometrics.fromJson(String source) =>
      Goniometrics.fromMap(json.decode(source) as Map<String, dynamic>);

  Goniometrics copyWith({
    String? id,
    String? sessionId,
    double? legRlRatio,
    double? kneeRlRatio,
    double? hipTotal,
    double? hipFlexionRightDeg,
    double? hipFlexionLeftDeg,
    double? kneeFlexionRightDeg,
    double? kneeFlexionLeftDeg,
    double? hipInternalRotationRightDeg,
    double? hipInternalRotationLeftDeg,
    double? hipExternalRotationRightDeg,
    double? hipExternalRotationLeftDeg,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goniometrics(
      id ?? this.id,
      sessionId ?? this.sessionId,
      legRlRatio ?? this.legRlRatio,
      kneeRlRatio ?? this.kneeRlRatio,
      hipTotal ?? this.hipTotal,
      hipFlexionRightDeg ?? this.hipFlexionRightDeg,
      hipFlexionLeftDeg ?? this.hipFlexionLeftDeg,
      kneeFlexionRightDeg ?? this.kneeFlexionRightDeg,
      kneeFlexionLeftDeg ?? this.kneeFlexionLeftDeg,
      hipInternalRotationRightDeg ?? this.hipInternalRotationRightDeg,
      hipInternalRotationLeftDeg ?? this.hipInternalRotationLeftDeg,
      hipExternalRotationRightDeg ?? this.hipExternalRotationRightDeg,
      hipExternalRotationLeftDeg ?? this.hipExternalRotationLeftDeg,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sessionId,
    legRlRatio,
    kneeRlRatio,
    hipTotal,
    hipFlexionRightDeg,
    hipFlexionLeftDeg,
    kneeFlexionRightDeg,
    kneeFlexionLeftDeg,
    hipInternalRotationRightDeg,
    hipInternalRotationLeftDeg,
    hipExternalRotationRightDeg,
    hipExternalRotationLeftDeg,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
