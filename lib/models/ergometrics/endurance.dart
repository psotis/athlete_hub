import 'dart:convert';
import 'package:equatable/equatable.dart';

class Endurance extends Equatable {
  final String id;
  final String sessionId;
  final int? beepTestLevel;
  final int? beepTestShuttles;
  final int? hrMax;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Endurance(
    this.id,
    this.sessionId,
    this.beepTestLevel,
    this.beepTestShuttles,
    this.hrMax,
    this.createdAt,
    this.updatedAt,
  );

  factory Endurance.initial() {
    return const Endurance('', '', null, null, null, null, null);
  }

  factory Endurance.fromMap(Map<String, dynamic> map) {
    return Endurance(
      (map['id'] ?? '').toString(),
      (map['session_id'] ?? '').toString(),
      (map['beep_test_level'] as num?)?.toInt(),
      (map['beep_test_shuttles'] as num?)?.toInt(),
      (map['hr_max'] as num?)?.toInt(),
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
      'beep_test_level': beepTestLevel,
      'beep_test_shuttles': beepTestShuttles,
      'hr_max': hrMax,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Endurance(
      id ?? this.id,
      sessionId ?? this.sessionId,
      beepTestLevel ?? this.beepTestLevel,
      beepTestShuttles ?? this.beepTestShuttles,
      hrMax ?? this.hrMax,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sessionId,
    beepTestLevel,
    beepTestShuttles,
    hrMax,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
