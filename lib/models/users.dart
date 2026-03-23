import 'package:athlete_hub/helpers/imports.dart';

class Users extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final int userType;
  final DateTime? birthDate;
  final String? phone;
  final int? gender;
  final String? sport;
  final String? team;
  final String? photoUrl;
  final bool isActive;
  final int tokenVersion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Users(
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.birthDate,
    this.phone,
    this.gender,
    this.sport,
    this.team,
    this.photoUrl,
    this.isActive,
    this.tokenVersion,
    this.createdAt,
    this.updatedAt,
  );

  factory Users.initial() {
    return const Users(
      '',
      '',
      '',
      '',
      0,
      null,
      null,
      null,
      null,
      null,
      null,
      false,
      0,
      null,
      null,
    );
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      (map['id'] ?? '').toString(),
      (map['first_name'] ?? '').toString(),
      (map['last_name'] ?? '').toString(),
      (map['email'] ?? '').toString(),
      (map['user_type'] as num?)?.toInt() ?? 0,
      map['birth_date'] != null
          ? DateTime.tryParse(map['birth_date'].toString())
          : null,
      map['phone']?.toString(),
      (map['gender'] as num?)?.toInt(),
      map['sport']?.toString(),
      map['team']?.toString(),
      map['photo_url']?.toString(),
      map['is_active'] as bool? ?? false,
      (map['token_version'] as num?)?.toInt() ?? 0,
      map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
      map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'user_type': userType,
      'birth_date': birthDate?.toIso8601String(),
      'phone': phone,
      'gender': gender,
      'sport': sport,
      'team': team,
      'photo_url': photoUrl,
      'is_active': isActive,
      'token_version': tokenVersion,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) =>
      Users.fromMap(json.decode(source) as Map<String, dynamic>);

  Users copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    int? userType,
    DateTime? birthDate,
    String? phone,
    int? gender,
    String? sport,
    String? team,
    String? photoUrl,
    bool? isActive,
    int? tokenVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Users(
      id ?? this.id,
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      email ?? this.email,
      userType ?? this.userType,
      birthDate ?? this.birthDate,
      phone ?? this.phone,
      gender ?? this.gender,
      sport ?? this.sport,
      team ?? this.team,
      photoUrl ?? this.photoUrl,
      isActive ?? this.isActive,
      tokenVersion ?? this.tokenVersion,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName';

  bool get isCustomer => userType == 0;
  bool get isTrainer => userType == 1;
  bool get isNutritionist => userType == 2;
  bool get isAdmin => userType == 3;

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    userType,
    birthDate,
    phone,
    gender,
    sport,
    team,
    photoUrl,
    isActive,
    tokenVersion,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
