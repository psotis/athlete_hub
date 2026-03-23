import 'package:athlete_hub/helpers/imports.dart';

class ErgometricsRepository {
  final ErgometricsService ergometricsService;

  ErgometricsRepository({required this.ergometricsService});

  Future<AthleteErgometricsData> getErgometricsPerUser(
    String? athleteId,
  ) async {
    final ergometrics = await ergometricsService.getErgometricsPerUser(
      athleteId!,
    );

    return ergometrics.data!;
  }
}
