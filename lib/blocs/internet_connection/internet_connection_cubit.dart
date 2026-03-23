import 'package:athlete_hub/helpers/imports.dart';

part 'internet_connection_state.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  late final StreamSubscription<InternetStatus> _subscription;
  InternetConnectionCubit() : super(InternetConnectionState.initial()) {
    _monitorConnection();
  }

  void _monitorConnection() {
    _subscription = InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          emit(
            state.copyWith(
              internetConnectionStatus: InternetConnectionStatus.connect,
            ),
          );
          break;
        case InternetStatus.disconnected:
          emit(
            state.copyWith(
              internetConnectionStatus: InternetConnectionStatus.disconnected,
            ),
          );
          break;
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
