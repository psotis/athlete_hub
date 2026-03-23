import 'package:athlete_hub/blocs/auth/auth_bloc.dart';
import 'package:athlete_hub/helpers/imports.dart';

class SecureTokenStorage implements TokenStorage {
  static const _kToken = 'token';
  static const _kUser = 'user_json';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _kToken, value: token);
  }

  @override
  Future<String?> getToken() async {
    return _storage.read(key: _kToken);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kUser);
  }

  @override
  Future<void> saveUser(Users user) async {
    await _storage.write(key: _kUser, value: jsonEncode(user.toMap()));
  }

  @override
  Future<Users?> getUser() async {
    final raw = await _storage.read(key: _kUser);
    if (raw == null || raw.isEmpty) return null;

    final map = jsonDecode(raw) as Map<String, dynamic>;
    return Users.fromMap(map);
  }
}
