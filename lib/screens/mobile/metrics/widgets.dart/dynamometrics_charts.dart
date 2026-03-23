import 'package:athlete_hub/helpers/imports.dart';

class DynamometricsCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const DynamometricsCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;

    return ChartSection(
      title: 'Dynamometrics',
      children: [
        ChartCard(
          title: 'Hand Grip Right',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.dynamometrics?.handGripRightN),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hand Grip Left',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.dynamometrics?.handGripLeftN),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Mid Thigh Pull',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.dynamometrics?.midThighPullN),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hand R/L Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.dynamometrics?.handRlRatio),
            ),
            labels: labels,
          ),
        ),
      ],
    );
  }
}
