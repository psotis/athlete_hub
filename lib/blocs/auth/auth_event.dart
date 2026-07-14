part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;
  const AuthLoggedIn(this.email, this.password);
}

class AuthLoggedOut extends AuthEvent {
  final bool notifyServer;

  const AuthLoggedOut({this.notifyServer = true});

  @override
  List<Object> get props => [notifyServer];
}

class AuthUserUpdated extends AuthEvent {
  final Users user;
  const AuthUserUpdated(this.user);

  @override
  List<Object> get props => [user];
}
