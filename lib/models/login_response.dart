import 'package:athlete_hub/helpers/imports.dart';

class LoginResponse {
  final String token;
  final String tokenType;
  final String expiresIn;
  final Users user;

  const LoginResponse({
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: (json['token'] ?? '').toString(),
      tokenType: (json['tokenType'] ?? 'Bearer').toString(),
      expiresIn: (json['expiresIn'] ?? '').toString(),
      user: Users.fromMap(json['user'] as Map<String, dynamic>),
    );
  }
}
