import 'dart:convert';
import 'package:equatable/equatable.dart';

class Agility extends Equatable {
  final String id;
  final String sessionId;
  final double? test5105RightSec;
  final double? test5105LeftSec;
  final double? sprint010Sec;
  final double? sprint020Sec;
  final double? sprint030Sec;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Agility(
    this.id,
    this.sessionId,
    this.test5105RightSec,
    this.test5105LeftSec,
    this.sprint010Sec,
    this.sprint020Sec,
    this.sprint030Sec,
    this.createdAt,
    this.updatedAt,
  );

  factory Agility.initial() {
    return const Agility('', '', null, null, null, null, null, null, null);
  }

  factory Agility.fromMap(Map<String, dynamic> map) {
    return Agility(
      (map['id'] ?? '').toString(),
      (map['session_id'] ?? '').toString(),
      (map['test_5_10_5_right_sec'] as num?)?.toDouble(),
      (map['test_5_10_5_left_sec'] as num?)?.toDouble(),
      (map['sprint_0_10_sec'] as num?)?.toDouble(),
      (map['sprint_0_20_sec'] as num?)?.toDouble(),
      (map['sprint_0_30_sec'] as num?)?.toDouble(),
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
      'test_5_10_5_right_sec': test5105RightSec,
      'test_5_10_5_left_sec': test5105LeftSec,
      'sprint_0_10_sec': sprint010Sec,
      'sprint_0_20_sec': sprint020Sec,
      'sprint_0_30_sec': sprint030Sec,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Agility.fromJson(String source) =>
      Agility.fromMap(json.decode(source) as Map<String, dynamic>);

  Agility copyWith({
    String? id,
    String? sessionId,
    double? test5105RightSec,
    double? test5105LeftSec,
    double? sprint010Sec,
    double? sprint020Sec,
    double? sprint030Sec,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Agility(
      id ?? this.id,
      sessionId ?? this.sessionId,
      test5105RightSec ?? this.test5105RightSec,
      test5105LeftSec ?? this.test5105LeftSec,
      sprint010Sec ?? this.sprint010Sec,
      sprint020Sec ?? this.sprint020Sec,
      sprint030Sec ?? this.sprint030Sec,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sessionId,
    test5105RightSec,
    test5105LeftSec,
    sprint010Sec,
    sprint020Sec,
    sprint030Sec,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
