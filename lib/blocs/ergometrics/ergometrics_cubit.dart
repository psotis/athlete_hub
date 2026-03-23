import 'package:athlete_hub/blocs/ergometrics/ergometrics_state.dart';
import 'package:athlete_hub/helpers/imports.dart';

class ErgometricsCubit extends Cubit<ErgometricsState> {
  final ErgometricsRepository _repository;

  ErgometricsCubit(this._repository) : super(ErgometricsState.initial());

  Future<void> getAthleteErgometrics(String athleteId) async {
    emit(state.copyWith(status: ErgometricsStatus.loading, clearError: true));

    try {
      final response = await _repository.getErgometricsPerUser(athleteId);

      emit(
        state.copyWith(
          status: ErgometricsStatus.success,
          data: response,
          clearError: true,
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
