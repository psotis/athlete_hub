// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'internet_connection_cubit.dart';

enum InternetConnectionStatus { loading, connect, disconnected }

class InternetConnectionState extends Equatable {
  final InternetConnectionStatus internetConnectionStatus;
  const InternetConnectionState({required this.internetConnectionStatus});

  factory InternetConnectionState.initial() {
    return InternetConnectionState(
      internetConnectionStatus: InternetConnectionStatus.connect,
    );
  }

  @override
  List<Object> get props => [internetConnectionStatus];

  InternetConnectionState copyWith({
    InternetConnectionStatus? internetConnectionStatus,
  }) {
    return InternetConnectionState(
      internetConnectionStatus:
          internetConnectionStatus ?? this.internetConnectionStatus,
    );
  }

  @override
  bool get stringify => true;
}
