import 'package:athlete_hub/helpers/imports.dart';

enum ErgometricsStatus { initial, loading, success, failure }

class ErgometricsState extends Equatable {
  final ErgometricsStatus status;
  final AthleteErgometricsData data;
  final String? errorMessage;
  final Users? selectedUser;

  const ErgometricsState({
    required this.status,
    required this.data,
    this.errorMessage,
    this.selectedUser,
  });

  factory ErgometricsState.initial() {
    return ErgometricsState(
      status: ErgometricsStatus.initial,
      data: AthleteErgometricsData.initial(),
      errorMessage: null,
      selectedUser: Users.initial(),
    );
  }

  ErgometricsState copyWith({
    ErgometricsStatus? status,
    AthleteErgometricsData? data,
    String? errorMessage,
    bool clearError = false,
    Users? selectedUser,
  }) {
    return ErgometricsState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage, selectedUser];
}
