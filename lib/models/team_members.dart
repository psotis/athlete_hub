import 'package:athlete_hub/helpers/imports.dart';

class TeamMember extends Equatable {
  final String id;
  final String userId;
  final String teamId;
  final bool isActive;
  final DateTime? joinedAt;
  final DateTime? leftAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final Users? user;
  final Team? team;

  const TeamMember({
    required this.id,
    required this.userId,
    required this.teamId,
    required this.isActive,
    this.joinedAt,
    this.leftAt,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.team,
  });

  factory TeamMember.initial() {
    return const TeamMember(
      id: '',
      userId: '',
      teamId: '',
      isActive: true,
      joinedAt: null,
      leftAt: null,
      createdAt: null,
      updatedAt: null,
      user: null,
      team: null,
    );
  }

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      id: (map['id'] ?? '').toString(),
      userId: (map['user_id'] ?? '').toString(),
      teamId: (map['team_id'] ?? '').toString(),
      isActive: map['is_active'] is bool
          ? map['is_active'] as bool
          : (map['is_active']?.toString() == 'true' ||
                map['is_active']?.toString() == '1'),
      joinedAt: map['joined_at'] != null
          ? DateTime.tryParse(map['joined_at'].toString())
          : null,
      leftAt: map['left_at'] != null
          ? DateTime.tryParse(map['left_at'].toString())
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'].toString())
          : null,
      user: map['user'] != null
          ? Users.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      team: map['team'] != null
          ? Team.fromMap(map['team'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'team_id': teamId,
      'is_active': isActive,
      'joined_at': joinedAt?.toIso8601String(),
      'left_at': leftAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user': user?.toMap(),
      'team': team?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory TeamMember.fromJson(String source) =>
      TeamMember.fromMap(json.decode(source) as Map<String, dynamic>);

  TeamMember copyWith({
    String? id,
    String? userId,
    String? teamId,
    bool? isActive,
    DateTime? joinedAt,
    DateTime? leftAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Users? user,
    Team? team,
  }) {
    return TeamMember(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      teamId: teamId ?? this.teamId,
      isActive: isActive ?? this.isActive,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      team: team ?? this.team,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    teamId,
    isActive,
    joinedAt,
    leftAt,
    createdAt,
    updatedAt,
    user,
    team,
  ];

  @override
  bool get stringify => true;
}
