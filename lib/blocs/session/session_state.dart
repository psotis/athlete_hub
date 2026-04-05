// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:athlete_hub/helpers/imports.dart';

enum SessionStatus { initial, loading, success, failure }

class SessionState extends Equatable {
  final SessionStatus status;
  final Session session;
  final String? errorMessage;
  final Users? selectedUser;
  const SessionState({
    required this.status,
    required this.session,
    this.errorMessage,
    this.selectedUser,
  });

  factory SessionState.initial() {
    return SessionState(
      status: SessionStatus.initial,
      session: Session.initial(),
      errorMessage: null,
      selectedUser: Users.initial(),
    );
  }

  SessionState copyWith({
    SessionStatus? status,
    Session? session,
    String? errorMessage,
    bool clearError = false,
    Users? selectedUser,
  }) {
    return SessionState(
      status: status ?? this.status,
      session: session ?? this.session,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [status, session, errorMessage, selectedUser];
}
