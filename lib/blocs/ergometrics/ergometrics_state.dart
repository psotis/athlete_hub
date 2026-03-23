import 'package:athlete_hub/helpers/imports.dart';

enum ErgometricsStatus { initial, loading, success, failure }

class ErgometricsState extends Equatable {
  final ErgometricsStatus status;
  final AthleteErgometricsData data;
  final String? errorMessage;

  const ErgometricsState({
    required this.status,
    required this.data,
    this.errorMessage,
  });

  factory ErgometricsState.initial() {
    return ErgometricsState(
      status: ErgometricsStatus.initial,
      data: AthleteErgometricsData.initial(),
      errorMessage: null,
    );
  }

  ErgometricsState copyWith({
    ErgometricsStatus? status,
    AthleteErgometricsData? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ErgometricsState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}
