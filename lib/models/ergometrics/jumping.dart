import 'dart:convert';
import 'package:equatable/equatable.dart';

class Jumping extends Equatable {
  final String id;
  final String sessionId;

  final double? elasticUtilRatio;
  final double? armSwing;
  final double? biliteralDeficit;
  final double? singleLegJump;

  final double? squatJumpHeightCm;
  final double? squatJumpPowerW;

  final double? cmjHeightCm;
  final double? cmjPowerW;

  final double? cmjFreeHandsHeightCm;
  final double? cmjFreeHandsPowerW;

  final double? dropJumpHeightCm;
  final double? dropJumpRsi;

  final double? singleLegCmjRightHeightCm;
  final double? singleLegCmjRightPowerW;
  final double? singleLegCmjLeftHeightCm;
  final double? singleLegCmjLeftPowerW;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Jumping(
    this.id,
    this.sessionId,
    this.elasticUtilRatio,
    this.armSwing,
    this.biliteralDeficit,
    this.singleLegJump,
    this.squatJumpHeightCm,
    this.squatJumpPowerW,
    this.cmjHeightCm,
    this.cmjPowerW,
    this.cmjFreeHandsHeightCm,
    this.cmjFreeHandsPowerW,
    this.dropJumpHeightCm,
    this.dropJumpRsi,
    this.singleLegCmjRightHeightCm,
    this.singleLegCmjRightPowerW,
    this.singleLegCmjLeftHeightCm,
    this.singleLegCmjLeftPowerW,
    this.createdAt,
    this.updatedAt,
  );

  factory Jumping.initial() {
    return const Jumping(
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

  factory Jumping.fromMap(Map<String, dynamic> map) {
    return Jumping(
      (map['id'] ?? '').toString(),
      (map['session_id'] ?? '').toString(),
      (map['elastic_util_ratio'] as num?)?.toDouble(),
      (map['arm_swing'] as num?)?.toDouble(),
      (map['biliteral_deficit'] as num?)?.toDouble(),
      (map['single_leg_jump'] as num?)?.toDouble(),
      (map['squat_jump_height_cm'] as num?)?.toDouble(),
      (map['squat_jump_power_w'] as num?)?.toDouble(),
      (map['cmj_height_cm'] as num?)?.toDouble(),
      (map['cmj_power_w'] as num?)?.toDouble(),
      (map['cmj_free_hands_height_cm'] as num?)?.toDouble(),
      (map['cmj_free_hands_power_w'] as num?)?.toDouble(),
      (map['drop_jump_height_cm'] as num?)?.toDouble(),
      (map['drop_jump_rsi'] as num?)?.toDouble(),
      (map['single_leg_cmj_right_height_cm'] as num?)?.toDouble(),
      (map['single_leg_cmj_right_power_w'] as num?)?.toDouble(),
      (map['single_leg_cmj_left_height_cm'] as num?)?.toDouble(),
      (map['single_leg_cmj_left_power_w'] as num?)?.toDouble(),
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
      'elastic_util_ratio': elasticUtilRatio,
      'arm_swing': armSwing,
      'biliteral_deficit': biliteralDeficit,
      'single_leg_jump': singleLegJump,
      'squat_jump_height_cm': squatJumpHeightCm,
      'squat_jump_power_w': squatJumpPowerW,
      'cmj_height_cm': cmjHeightCm,
      'cmj_power_w': cmjPowerW,
      'cmj_free_hands_height_cm': cmjFreeHandsHeightCm,
      'cmj_free_hands_power_w': cmjFreeHandsPowerW,
      'drop_jump_height_cm': dropJumpHeightCm,
      'drop_jump_rsi': dropJumpRsi,
      'single_leg_cmj_right_height_cm': singleLegCmjRightHeightCm,
      'single_leg_cmj_right_power_w': singleLegCmjRightPowerW,
      'single_leg_cmj_left_height_cm': singleLegCmjLeftHeightCm,
      'single_leg_cmj_left_power_w': singleLegCmjLeftPowerW,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Jumping.fromJson(String source) =>
      Jumping.fromMap(json.decode(source) as Map<String, dynamic>);

  Jumping copyWith({
    String? id,
    String? sessionId,
    double? elasticUtilRatio,
    double? armSwing,
    double? biliteralDeficit,
    double? singleLegJump,
    double? squatJumpHeightCm,
    double? squatJumpPowerW,
    double? cmjHeightCm,
    double? cmjPowerW,
    double? cmjFreeHandsHeightCm,
    double? cmjFreeHandsPowerW,
    double? dropJumpHeightCm,
    double? dropJumpRsi,
    double? singleLegCmjRightHeightCm,
    double? singleLegCmjRightPowerW,
    double? singleLegCmjLeftHeightCm,
    double? singleLegCmjLeftPowerW,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Jumping(
      id ?? this.id,
      sessionId ?? this.sessionId,
      elasticUtilRatio ?? this.elasticUtilRatio,
      armSwing ?? this.armSwing,
      biliteralDeficit ?? this.biliteralDeficit,
      singleLegJump ?? this.singleLegJump,
      squatJumpHeightCm ?? this.squatJumpHeightCm,
      squatJumpPowerW ?? this.squatJumpPowerW,
      cmjHeightCm ?? this.cmjHeightCm,
      cmjPowerW ?? this.cmjPowerW,
      cmjFreeHandsHeightCm ?? this.cmjFreeHandsHeightCm,
      cmjFreeHandsPowerW ?? this.cmjFreeHandsPowerW,
      dropJumpHeightCm ?? this.dropJumpHeightCm,
      dropJumpRsi ?? this.dropJumpRsi,
      singleLegCmjRightHeightCm ?? this.singleLegCmjRightHeightCm,
      singleLegCmjRightPowerW ?? this.singleLegCmjRightPowerW,
      singleLegCmjLeftHeightCm ?? this.singleLegCmjLeftHeightCm,
      singleLegCmjLeftPowerW ?? this.singleLegCmjLeftPowerW,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sessionId,
    elasticUtilRatio,
    armSwing,
    biliteralDeficit,
    singleLegJump,
    squatJumpHeightCm,
    squatJumpPowerW,
    cmjHeightCm,
    cmjPowerW,
    cmjFreeHandsHeightCm,
    cmjFreeHandsPowerW,
    dropJumpHeightCm,
    dropJumpRsi,
    singleLegCmjRightHeightCm,
    singleLegCmjRightPowerW,
    singleLegCmjLeftHeightCm,
    singleLegCmjLeftPowerW,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
