import 'dart:convert';
import 'package:equatable/equatable.dart';

class Assignment extends Equatable {
  final String id;
  final String athleteId;
  final String staffId;
  final int roleType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Assignment(
    this.id,
    this.athleteId,
    this.staffId,
    this.roleType,
    this.createdAt,
    this.updatedAt,
  );

  factory Assignment.initial() {
    return const Assignment('', '', '', 0, null, null);
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      (map['id'] ?? '').toString(),
      (map['athlete_id'] ?? '').toString(),
      (map['staff_id'] ?? '').toString(),
      (map['role_type'] as num?)?.toInt() ?? 0,
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
      'athlete_id': athleteId,
      'staff_id': staffId,
      'role_type': roleType,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Assignment.fromJson(String source) =>
      Assignment.fromMap(json.decode(source) as Map<String, dynamic>);

  Assignment copyWith({
    String? id,
    String? athleteId,
    String? staffId,
    int? roleType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Assignment(
      id ?? this.id,
      athleteId ?? this.athleteId,
      staffId ?? this.staffId,
      roleType ?? this.roleType,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  bool get isTrainer => roleType == 1;
  bool get isNutritionist => roleType == 2;
  bool get isAdmin => roleType == 3;

  @override
  List<Object?> get props => [
    id,
    athleteId,
    staffId,
    roleType,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
