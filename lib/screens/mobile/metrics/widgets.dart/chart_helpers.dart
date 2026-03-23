import 'package:athlete_hub/helpers/imports.dart';

extension ErgometricsChartX on List<ErgometricsDetails> {
  List<String> get sessionLabels {
    return map((e) {
      final date = e.session?.measurementDate;

      if (date == null) return '-';

      return "${date.year.toString().padLeft(4, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.day.toString().padLeft(2, '0')}";
    }).toList();
  }

  List<FlSpot> lineSpots(double? Function(ErgometricsDetails item) selector) {
    final spots = <FlSpot>[];

    for (int i = 0; i < length; i++) {
      final value = selector(this[i]);
      if (value != null) {
        spots.add(FlSpot(i.toDouble(), value));
      }
    }

    return spots;
  }

  List<double> barValues(double? Function(ErgometricsDetails item) selector) {
    final values = <double>[];

    for (final item in this) {
      final value = selector(item);
      if (value != null) {
        values.add(value);
      }
    }

    return values;
  }
}

double? numToDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
