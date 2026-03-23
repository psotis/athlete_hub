import 'dart:convert';
import 'package:equatable/equatable.dart';

class Dynamometrics extends Equatable {
  final String id;
  final String sessionId;

  final double? handRlRatio;
  final double? legRlRatio;
  final double? kneeRlRatio;
  final double? shoulderIntRatio;
  final double? shoulderExtRatio;

  final double? handGripRightN;
  final double? handGripLeftN;
  final double? midThighPullN;

  final double? kneeExtensionRightN;
  final double? kneeExtensionLeftN;
  final double? kneeFlexionRightN;
  final double? kneeFlexionLeftN;

  final double? shoulderInternalRotationRightN;
  final double? shoulderInternalRotationLeftN;
  final double? shoulderExternalRotationRightN;
  final double? shoulderExternalRotationLeftN;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Dynamometrics(
    this.id,
    this.sessionId,
    this.handRlRatio,
    this.legRlRatio,
    this.kneeRlRatio,
    this.shoulderIntRatio,
    this.shoulderExtRatio,
    this.handGripRightN,
    this.handGripLeftN,
    this.midThighPullN,
    this.kneeExtensionRightN,
    this.kneeExtensionLeftN,
    this.kneeFlexionRightN,
    this.kneeFlexionLeftN,
    this.shoulderInternalRotationRightN,
    this.shoulderInternalRotationLeftN,
    this.shoulderExternalRotationRightN,
    this.shoulderExternalRotationLeftN,
    this.createdAt,
    this.updatedAt,
  );

  factory Dynamometrics.initial() {
    return const Dynamometrics(
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
      null,
      null,
      null,
      null,
      null,
    );
  }

  factory Dynamometrics.fromMap(Map<String, dynamic> map) {
    return Dynamometrics(
      (map['id'] ?? '').toString(),
      (map['session_id'] ?? '').toString(),

      (map['hand_rl_ratio'] as num?)?.toDouble(),
      (map['leg_rl_ratio'] as num?)?.toDouble(),
      (map['knee_rl_ratio'] as num?)?.toDouble(),
      (map['shoulder_int_ratio'] as num?)?.toDouble(),
      (map['shoulder_ext_ratio'] as num?)?.toDouble(),

      (map['hand_grip_right_n'] as num?)?.toDouble(),
      (map['hand_grip_left_n'] as num?)?.toDouble(),
      (map['mid_thigh_pull_n'] as num?)?.toDouble(),

      (map['knee_extension_right_n'] as num?)?.toDouble(),
      (map['knee_extension_left_n'] as num?)?.toDouble(),
      (map['knee_flexion_right_n'] as num?)?.toDouble(),
      (map['knee_flexion_left_n'] as num?)?.toDouble(),

      (map['shoulder_internal_rotation_right_n'] as num?)?.toDouble(),
      (map['shoulder_internal_rotation_left_n'] as num?)?.toDouble(),
      (map['shoulder_external_rotation_right_n'] as num?)?.toDouble(),
      (map['shoulder_external_rotation_left_n'] as num?)?.toDouble(),

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

      'hand_rl_ratio': handRlRatio,
      'leg_rl_ratio': legRlRatio,
      'knee_rl_ratio': kneeRlRatio,
      'shoulder_int_ratio': shoulderIntRatio,
      'shoulder_ext_ratio': shoulderExtRatio,

      'hand_grip_right_n': handGripRightN,
      'hand_grip_left_n': handGripLeftN,
      'mid_thigh_pull_n': midThighPullN,

      'knee_extension_right_n': kneeExtensionRightN,
      'knee_extension_left_n': kneeExtensionLeftN,
      'knee_flexion_right_n': kneeFlexionRightN,
      'knee_flexion_left_n': kneeFlexionLeftN,

      'shoulder_internal_rotation_right_n': shoulderInternalRotationRightN,
      'shoulder_internal_rotation_left_n': shoulderInternalRotationLeftN,
      'shoulder_external_rotation_right_n': shoulderExternalRotationRightN,
      'shoulder_external_rotation_left_n': shoulderExternalRotationLeftN,

      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Dynamometrics.fromJson(String source) =>
      Dynamometrics.fromMap(json.decode(source) as Map<String, dynamic>);

  Dynamometrics copyWith({
    String? id,
    String? sessionId,
    double? handRlRatio,
    double? legRlRatio,
    double? kneeRlRatio,
    double? shoulderIntRatio,
    double? shoulderExtRatio,
    double? handGripRightN,
    double? handGripLeftN,
    double? midThighPullN,
    double? kneeExtensionRightN,
    double? kneeExtensionLeftN,
    double? kneeFlexionRightN,
    double? kneeFlexionLeftN,
    double? shoulderInternalRotationRightN,
    double? shoulderInternalRotationLeftN,
    double? shoulderExternalRotationRightN,
    double? shoulderExternalRotationLeftN,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Dynamometrics(
      id ?? this.id,
      sessionId ?? this.sessionId,
      handRlRatio ?? this.handRlRatio,
      legRlRatio ?? this.legRlRatio,
      kneeRlRatio ?? this.kneeRlRatio,
      shoulderIntRatio ?? this.shoulderIntRatio,
      shoulderExtRatio ?? this.shoulderExtRatio,
      handGripRightN ?? this.handGripRightN,
      handGripLeftN ?? this.handGripLeftN,
      midThighPullN ?? this.midThighPullN,
      kneeExtensionRightN ?? this.kneeExtensionRightN,
      kneeExtensionLeftN ?? this.kneeExtensionLeftN,
      kneeFlexionRightN ?? this.kneeFlexionRightN,
      kneeFlexionLeftN ?? this.kneeFlexionLeftN,
      shoulderInternalRotationRightN ?? this.shoulderInternalRotationRightN,
      shoulderInternalRotationLeftN ?? this.shoulderInternalRotationLeftN,
      shoulderExternalRotationRightN ?? this.shoulderExternalRotationRightN,
      shoulderExternalRotationLeftN ?? this.shoulderExternalRotationLeftN,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sessionId,
    handRlRatio,
    legRlRatio,
    kneeRlRatio,
    shoulderIntRatio,
    shoulderExtRatio,
    handGripRightN,
    handGripLeftN,
    midThighPullN,
    kneeExtensionRightN,
    kneeExtensionLeftN,
    kneeFlexionRightN,
    kneeFlexionLeftN,
    shoulderInternalRotationRightN,
    shoulderInternalRotationLeftN,
    shoulderExternalRotationRightN,
    shoulderExternalRotationLeftN,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
