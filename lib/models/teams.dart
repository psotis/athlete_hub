import 'dart:convert';
import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final String? sport;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Team({
    required this.id,
    required this.name,
    this.sport,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Team.initial() {
    return const Team(
      id: '',
      name: '',
      sport: null,
      isActive: true,
      createdAt: null,
      updatedAt: null,
    );
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      sport: map['sport']?.toString(),
      isActive: map['is_active'] is bool
          ? map['is_active'] as bool
          : (map['is_active']?.toString() == 'true' ||
                map['is_active']?.toString() == '1'),
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
      'name': name,
      'sport': sport,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Team.fromJson(String source) =>
      Team.fromMap(json.decode(source) as Map<String, dynamic>);

  Team copyWith({
    String? id,
    String? name,
    String? sport,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      sport: sport ?? this.sport,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, sport, isActive, createdAt, updatedAt];

  @override
  bool get stringify => true;
}
