import 'package:athlete_hub/helpers/imports.dart';

class SessionRepository {
  final SessionService sessionService;

  SessionRepository({required this.sessionService});

  Future<Session> startSession(String? athleteId, String? userid) async {
    final session = await sessionService.startSession(athleteId!, userid!);

    return session.data!;
  }
}
