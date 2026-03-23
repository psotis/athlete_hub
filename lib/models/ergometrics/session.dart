import 'dart:convert';
import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final String id;
  final String athleteId;
  final String measuredById;
  final DateTime? measurementDate;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Session(
    this.id,
    this.athleteId,
    this.measuredById,
    this.measurementDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
  );

  factory Session.initial() {
    return const Session('', '', '', null, null, null, null);
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      (map['id'] ?? '').toString(),
      (map['athlete_id'] ?? '').toString(),
      (map['measured_by_id'] ?? '').toString(),
      map['measurement_date'] != null
          ? DateTime.tryParse(map['measurement_date'].toString())
          : null,
      map['notes']?.toString(),
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
      'measured_by_id': measuredById,
      'measurement_date': measurementDate?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source) as Map<String, dynamic>);

  Session copyWith({
    String? id,
    String? athleteId,
    String? measuredById,
    DateTime? measurementDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Session(
      id ?? this.id,
      athleteId ?? this.athleteId,
      measuredById ?? this.measuredById,
      measurementDate ?? this.measurementDate,
      notes ?? this.notes,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    athleteId,
    measuredById,
    measurementDate,
    notes,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
