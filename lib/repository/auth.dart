import 'package:athlete_hub/blocs/auth/auth_bloc.dart';
import 'package:athlete_hub/helpers/imports.dart';

class AuthRepository {
  final AuthService authService;
  final TokenStorage tokenStorage;

  AuthRepository({required this.authService, required this.tokenStorage});

  Future<Users> login({required String email, required String password}) async {
    final loggedUser = await authService.login(
      email: email,
      password: password,
    );
    await tokenStorage.saveToken(loggedUser.token);
    await tokenStorage.saveUser(loggedUser.user);

    return loggedUser.user;
  }

  Future<void> signup() async {}
  Future<void> forgotPassword({required String email}) {
    return authService.forgotPassword(email: email);
  }

  Future<void> resetPassword({
    required String token,
    required String password,
  }) {
    return authService.resetPassword(token: token, password: password);
  }

  Future<void> logout() async {}
}
