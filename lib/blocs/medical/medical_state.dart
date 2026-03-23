import 'package:athlete_hub/helpers/imports.dart';

enum MedicalStatus { initial, loading, success, failure }

enum MedicalActionStatus { initial, loading, success, failure }

class MedicalState extends Equatable {
  final MedicalStatus status;
  final MedicalActionStatus actionStatus;
  final List<MedicalHistory> data;
  final String? errorMessage;
  final String? actionMessage;

  const MedicalState({
    required this.status,
    required this.actionStatus,
    required this.data,
    this.errorMessage,
    this.actionMessage,
  });

  factory MedicalState.initial() {
    return const MedicalState(
      status: MedicalStatus.initial,
      actionStatus: MedicalActionStatus.initial,
      data: [],
      errorMessage: null,
      actionMessage: null,
    );
  }

  MedicalState copyWith({
    MedicalStatus? status,
    MedicalActionStatus? actionStatus,
    List<MedicalHistory>? data,
    String? errorMessage,
    String? actionMessage,
    bool clearError = false,
    bool clearActionMessage = false,
  }) {
    return MedicalState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionMessage: clearActionMessage
          ? null
          : (actionMessage ?? this.actionMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    data,
    errorMessage,
    actionMessage,
  ];
}
