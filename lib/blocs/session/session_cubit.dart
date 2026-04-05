import 'package:athlete_hub/blocs/session/session_state.dart';
import 'package:athlete_hub/helpers/imports.dart';

class SessionCubit extends Cubit<SessionState> {
  final SessionRepository _repository;
  SessionCubit(this._repository) : super(SessionState.initial());

  Future<void> startSession(Users user, String userid) async {
    emit(state.copyWith(status: SessionStatus.loading, clearError: true));

    try {
      final response = await _repository.startSession(user.id, userid);

      emit(
        state.copyWith(
          status: SessionStatus.success,
          session: response,
          clearError: true,
          selectedUser: user,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SessionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void clearErgometrics() {
    emit(SessionState.initial());
  }
}
