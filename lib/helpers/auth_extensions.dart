import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';

extension AuthContextX on BuildContext {
  AuthState get authState => watch<AuthBloc>().state;

  Users? get currentUser {
    final state = authState;
    return state is AuthAuthenticated ? state.user : null;
  }

  bool get isLoggedIn => authState is AuthAuthenticated;

  bool get isCustomer => currentUser?.isCustomer ?? false;
  bool get isTrainer => currentUser?.isTrainer ?? false;
  bool get isNutritionist => currentUser?.isNutritionist ?? false;
  bool get isAdmin => currentUser?.isAdmin ?? false;
}

extension AuthContextReadX on BuildContext {
  Users? get currentUserRead {
    final state = read<AuthBloc>().state;
    return state is AuthAuthenticated ? state.user : null;
  }
}
