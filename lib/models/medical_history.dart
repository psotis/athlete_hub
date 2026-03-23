import 'dart:convert';
import 'package:equatable/equatable.dart';

class MedicalHistory extends Equatable {
  final String id;
  final String athleteId;
  final int itemType;
  final String? title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final String createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MedicalHistory(
    this.id,
    this.athleteId,
    this.itemType,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.isActive,
    this.createdById,
    this.createdAt,
    this.updatedAt,
  );

  factory MedicalHistory.initial() {
    return const MedicalHistory(
      '',
      '',
      0,
      null,
      null,
      null,
      null,
      false,
      '',
      null,
      null,
    );
  }

  factory MedicalHistory.fromMap(Map<String, dynamic> map) {
    return MedicalHistory(
      (map['id'] ?? '').toString(),
      (map['athlete_id'] ?? '').toString(),
      (map['item_type'] as num?)?.toInt() ?? 0,
      map['title']?.toString(),
      map['description']?.toString(),
      map['start_date'] != null
          ? DateTime.tryParse(map['start_date'].toString())
          : null,
      map['end_date'] != null
          ? DateTime.tryParse(map['end_date'].toString())
          : null,
      map['is_active'] as bool? ?? false,
      (map['created_by_id'] ?? '').toString(),
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
      'item_type': itemType,
      'title': title,
      'description': description,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'created_by_id': createdById,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory MedicalHistory.fromJson(String source) =>
      MedicalHistory.fromMap(json.decode(source) as Map<String, dynamic>);

  MedicalHistory copyWith({
    String? id,
    String? athleteId,
    int? itemType,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalHistory(
      id ?? this.id,
      athleteId ?? this.athleteId,
      itemType ?? this.itemType,
      title ?? this.title,
      description ?? this.description,
      startDate ?? this.startDate,
      endDate ?? this.endDate,
      isActive ?? this.isActive,
      createdById ?? this.createdById,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  /// Optional helpers (like you did before)
  bool get isInjury => itemType == 1;
  bool get isSurgery => itemType == 2;
  bool get isCondition => itemType == 3;

  @override
  List<Object?> get props => [
    id,
    athleteId,
    itemType,
    title,
    description,
    startDate,
    endDate,
    isActive,
    createdById,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}

// enum MedicalType { injury, surgery, condition }

// MedicalType get type {
//   switch (itemType) {
//     case 2:
//       return MedicalType.surgery;
//     case 3:
//       return MedicalType.condition;
//     default:
//       return MedicalType.injury;
//   }
// }
