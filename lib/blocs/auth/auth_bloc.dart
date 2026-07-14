import '../../helpers/imports.dart';

part 'auth_event.dart';
part 'auth_state.dart';

abstract class TokenStorage {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();

  Future<void> saveUser(Users user);
  Future<Users?> getUser();
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final TokenStorage tokenStorage;

  AuthBloc({required this.tokenStorage, required this.authRepository})
    : super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoggedIn>(_onLoggedIn);
    on<AuthLoggedOut>(_onLoggedOut);
    on<AuthUserUpdated>(_onUserUpdated);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthChecking());
    final token = await tokenStorage.getToken();
    final user = await tokenStorage.getUser();

    if (token != null && token.isNotEmpty && user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading());

      final user = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (event.notifyServer) await authRepository.logout();
    } catch (_) {
      // Local logout must still complete if the session already expired.
    } finally {
      await tokenStorage.clearToken();
    }
    emit(const AuthUnauthenticated());
  }

  Future<void> _onUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    await tokenStorage.saveUser(event.user);
    emit(AuthAuthenticated(event.user));
  }
}
