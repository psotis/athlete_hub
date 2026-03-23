import 'package:athlete_hub/helpers/imports.dart';

class GoniometricsCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const GoniometricsCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;

    return ChartSection(
      title: 'Goniometrics',
      children: [
        ChartCard(
          title: 'Hip Flexion Right',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.goniometrics?.hipFlexionRightDeg),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hip Flexion Left',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.goniometrics?.hipFlexionLeftDeg),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Knee Flexion Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.goniometrics?.kneeRlRatio),
            ),
            labels: labels,
          ),
        ),
      ],
    );
  }
}
