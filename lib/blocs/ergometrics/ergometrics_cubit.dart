import 'package:athlete_hub/blocs/ergometrics/ergometrics_state.dart';
import 'package:athlete_hub/helpers/imports.dart';

class ErgometricsCubit extends Cubit<ErgometricsState> {
  final ErgometricsRepository _repository;

  ErgometricsCubit(this._repository) : super(ErgometricsState.initial());

  Future<void> getAthleteErgometrics(Users user) async {
    emit(state.copyWith(status: ErgometricsStatus.loading, clearError: true));

    try {
      final response = await _repository.getErgometricsPerUser(user.id);

      emit(
        state.copyWith(
          status: ErgometricsStatus.success,
          data: response,
          clearError: true,
          selectedUser: user,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ErgometricsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void clearErgometrics() {
    emit(ErgometricsState.initial());
  }
}
