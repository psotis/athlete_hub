import 'package:athlete_hub/helpers/imports.dart';

class SomatometricsCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const SomatometricsCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;

    return ChartSection(
      title: 'Somatometrics',
      children: [
        ChartCard(
          title: 'Weight (kg)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.somatometrics?.weightKg),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Body Fat (%)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.somatometrics?.bodyFatPercent),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'BMI',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => numToDouble(e.somatometrics?.bmi)),
            labels: labels,
          ),
        ),
      ],
    );
  }
}
