import 'dart:convert';
import 'package:equatable/equatable.dart';

class Endurance extends Equatable {
  final String id;
  final String sessionId;
  final int? beepTestLevel;
  final int? beepTestShuttles;
  final int? hrMax;
  final double? beepTestTimeSec;
  final int? beepTestDistanceM;
  final double? beepTestSpeedKmh;
  final double? beepTestContinuousScore;
  final double? beepTestVo2maxMlKgMin;

  final double? maxSpeed;
  final double? hrMaxVo;
  final double? vo2Max;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Endurance({
    required this.id,
    required this.sessionId,
    required this.beepTestLevel,
    required this.beepTestShuttles,
    required this.hrMax,
    required this.beepTestTimeSec,
    required this.beepTestDistanceM,
    required this.beepTestSpeedKmh,
    required this.beepTestContinuousScore,
    required this.beepTestVo2maxMlKgMin,
    required this.maxSpeed,
    required this.hrMaxVo,
    required this.vo2Max,
    this.createdAt,
    this.updatedAt,
  });

  factory Endurance.initial() {
    return const Endurance(
      id: '',
      sessionId: '',
      beepTestLevel: 1,
      beepTestShuttles: 1,
      hrMax: 0,
      beepTestTimeSec: 0,
      beepTestDistanceM: 0,
      beepTestSpeedKmh: 0,
      beepTestContinuousScore: 0,
      beepTestVo2maxMlKgMin: 0,
      maxSpeed: 0,
      hrMaxVo: 0,
      vo2Max: 0,
      createdAt: null,
      updatedAt: null,
    );
  }

  factory Endurance.fromMap(Map<String, dynamic> map) {
    return Endurance(
      id: (map['id'] ?? '').toString(),
      sessionId: (map['session_id'] ?? '').toString(),
      beepTestLevel: (map['beep_test_level'] as num?)?.toInt(),
      beepTestShuttles: (map['beep_test_shuttles'] as num?)?.toInt(),
      hrMax: (map['hr_max'] as num?)?.toInt(),
      beepTestTimeSec: (map['beep_test_time_sec'] as num?)?.toDouble(),
      beepTestDistanceM: (map['beep_test_distance_m'] as num?)?.toInt(),
      beepTestSpeedKmh: (map['beep_test_speed_kmh'] as num?)?.toDouble(),
      beepTestContinuousScore: (map['beep_test_continuous_score'] as num?)
          ?.toDouble(),
      beepTestVo2maxMlKgMin: (map['beep_test_vo2max_ml_kg_min'] as num?)
          ?.toDouble(),
      maxSpeed: (map['max_speed'] as num?)?.toDouble(),
      hrMaxVo: (map['hr_max_vo'] as num?)?.toDouble(),
      vo2Max: (map['vo2max'] as num?)?.toDouble(),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'beep_test_level': beepTestLevel,
      'beep_test_shuttles': beepTestShuttles,
      'hr_max': hrMax,
      'beep_test_time_sec': beepTestTimeSec,
      'beep_test_distance_m': beepTestDistanceM,
      'beep_test_speed_kmh': beepTestSpeedKmh,
      'beep_test_continuous_score': beepTestContinuousScore,
      'beep_test_vo2max_ml_kg_min': beepTestVo2maxMlKgMin,
      'max_speed': maxSpeed,
      'hr_max_vo': hrMaxVo,
      'vo2max': vo2Max,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Endurance.fromJson(String source) =>
      Endurance.fromMap(json.decode(source) as Map<String, dynamic>);

  Endurance copyWith({
    String? id,
    String? sessionId,
    int? beepTestLevel,
    int? beepTestShuttles,
    int? hrMax,
    double? beepTestTimeSec,
    int? beepTestDistanceM,
    double? beepTestSpeedKmh,
    double? beepTestContinuousScore,
    double? beepTestVo2maxMlKgMin,
    double? maxSpeed,
    double? hrMaxVo,
    double? vo2Max,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Endurance(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      beepTestLevel: beepTestLevel ?? this.beepTestLevel,
      beepTestShuttles: beepTestShuttles ?? this.beepTestShuttles,
      hrMax: hrMax ?? this.hrMax,
      beepTestTimeSec: beepTestTimeSec ?? this.beepTestTimeSec,
      beepTestDistanceM: beepTestDistanceM ?? this.beepTestDistanceM,
      beepTestSpeedKmh: beepTestSpeedKmh ?? this.beepTestSpeedKmh,
      beepTestContinuousScore:
          beepTestContinuousScore ?? this.beepTestContinuousScore,
      beepTestVo2maxMlKgMin:
          beepTestVo2maxMlKgMin ?? this.beepTestVo2maxMlKgMin,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      hrMaxVo: hrMaxVo ?? this.hrMaxVo,
      vo2Max: vo2Max ?? this.vo2Max,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sessionId,
    beepTestLevel,
    beepTestShuttles,
    hrMax,
    beepTestTimeSec,
    beepTestDistanceM,
    beepTestSpeedKmh,
    beepTestContinuousScore,
    beepTestVo2maxMlKgMin,
    maxSpeed,
    hrMaxVo,
    vo2Max,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
