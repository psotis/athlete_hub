import 'package:athlete_hub/helpers/imports.dart';

class AthleteErgometricsData extends Equatable {
  final Users? athlete;
  final List<ErgometricsDetails> ergometrics;

  const AthleteErgometricsData({this.athlete, this.ergometrics = const []});

  factory AthleteErgometricsData.initial() {
    return const AthleteErgometricsData(athlete: null, ergometrics: []);
  }

  factory AthleteErgometricsData.fromMap(Object? source) {
    final map = source as Map<String, dynamic>? ?? {};

    return AthleteErgometricsData(
      athlete: map['athlete'] != null
          ? Users.fromMap(map['athlete'] as Map<String, dynamic>)
          : null,
      ergometrics: (map['ergometrics'] as List<dynamic>? ?? [])
          .map((e) => ErgometricsDetails.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [athlete, ergometrics];
}
