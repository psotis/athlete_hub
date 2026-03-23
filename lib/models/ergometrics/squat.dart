import 'dart:convert';
import 'package:equatable/equatable.dart';

class Squat extends Equatable {
  final String id;
  final String sessionId;

  final String? viewName;
  final String? checkpointName;
  final String? compensation;
  final bool? result;
  final String? notes;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Squat(
    this.id,
    this.sessionId,
    this.viewName,
    this.checkpointName,
    this.compensation,
    this.result,
    this.notes,
    this.createdAt,
    this.updatedAt,
  );

  factory Squat.initial() {
    return const Squat('', '', null, null, null, null, null, null, null);
  }

  factory Squat.fromMap(Map<String, dynamic> map) {
    return Squat(
      (map['id'] ?? '').toString(),
      (map['session_id'] ?? '').toString(),
      map['view_name']?.toString(),
      map['checkpoint_name']?.toString(),
      map['compensation']?.toString(),
      map['result'] as bool?,
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
      'session_id': sessionId,
      'view_name': viewName,
      'checkpoint_name': checkpointName,
      'compensation': compensation,
      'result': result,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Squat.fromJson(String source) =>
      Squat.fromMap(json.decode(source) as Map<String, dynamic>);

  Squat copyWith({
    String? id,
    String? sessionId,
    String? viewName,
    String? checkpointName,
    String? compensation,
    bool? result,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Squat(
      id ?? this.id,
      sessionId ?? this.sessionId,
      viewName ?? this.viewName,
      checkpointName ?? this.checkpointName,
      compensation ?? this.compensation,
      result ?? this.result,
      notes ?? this.notes,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sessionId,
    viewName,
    checkpointName,
    compensation,
    result,
    notes,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
