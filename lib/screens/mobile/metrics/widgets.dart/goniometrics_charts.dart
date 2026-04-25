import 'package:athlete_hub/helpers/imports.dart';

class GoniometricsCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const GoniometricsCharts({super.key, required this.items});

  List<Widget> _metricBlock({
    required String title,
    required String comparisonTitle,
    required double? latestValue,
    required double? previousValue,
    required String unit,
    required int decimals,
    required IconData icon,
    required List<FlSpot> spots,
    required List<String> labels,
  }) {
    return [
      MetricDeltaCard(
        title: comparisonTitle,
        latestValue: latestValue,
        previousValue: previousValue,
        unit: unit,
        decimals: decimals,
        icon: icon,
      ),
      const SizedBox(height: 12),
      ChartCard(
        title: title,
        chart: SimpleLineChart(
          spots: spots,
          labels: labels,
          yDecimals: decimals,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    return ChartSection(
      title: 'Goniometrics',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Straight Leg Raise (SLR) Right',
          comparisonTitle: 'Straight Leg Raise (SLR) Right',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipFlexionRightDeg),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipFlexionRightDeg),
          ),
          unit: ' deg',
          decimals: 1,
          icon: Icons.straighten,
          spots: items.lineSpots(
            (e) => numToDouble(e.goniometrics?.hipFlexionRightDeg),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Straight Leg Raise (SLR) Left',
          comparisonTitle: 'Straight Leg Raise (SLR) Left',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipFlexionLeftDeg),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipFlexionLeftDeg),
          ),
          unit: ' deg',
          decimals: 1,
          icon: Icons.straighten,
          spots: items.lineSpots(
            (e) => numToDouble(e.goniometrics?.hipFlexionLeftDeg),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Straight Leg Raise Right / Left Ratio',
          comparisonTitle: 'Straight Leg Raise Right / Left Ratio',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.legRlRatio),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.legRlRatio),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.balance,
          spots: items.lineSpots(
            (e) => numToDouble(e.goniometrics?.legRlRatio),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Knee Flexion Right',
          comparisonTitle: 'Knee Flexion Right',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.kneeFlexionRightDeg),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.kneeFlexionRightDeg),
          ),
          unit: ' deg',
          decimals: 1,
          icon: Icons.straighten,
          spots: items.lineSpots(
            (e) => numToDouble(e.goniometrics?.kneeFlexionRightDeg),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Knee Flexion Left',
          comparisonTitle: 'Knee Flexion Left',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.kneeFlexionLeftDeg),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.kneeFlexionLeftDeg),
          ),
          unit: ' deg',
          decimals: 1,
          icon: Icons.straighten,
          spots: items.lineSpots(
            (e) => numToDouble(e.goniometrics?.kneeFlexionLeftDeg),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Knee Flexion Right / Left Ratio',
          comparisonTitle: 'Knee Flexion Right / Left Ratio',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.kneeRlRatio),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.kneeRlRatio),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.balance,
          spots: items.lineSpots(
            (e) => numToDouble(e.goniometrics?.kneeRlRatio),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Internal Hip Rotation Right',
          comparisonTitle: 'Internal Hip Rotation Right',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipInternalRotationRightDeg),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipInternalRotationRightDeg),
          ),
          unit: ' deg',
          decimals: 1,
          icon: Icons.rotate_right,
          spots: items.lineSpots(
            (e) => numToDouble(e.goniometrics?.hipInternalRotationRightDeg),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Internal Hip Rotation Left',
          comparisonTitle: 'Internal Hip Rotation Left',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipInternalRotationLeftDeg),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipInternalRotationLeftDeg),
          ),
          unit: ' deg',
          decimals: 1,
          icon: Icons.rotate_left,
          spots: items.lineSpots(
            (e) => numToDouble(e.goniometrics?.hipInternalRotationLeftDeg),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'External Hip Rotation Right',
          comparisonTitle: 'External Hip Rotation Right',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipExternalRotationRightDeg),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipExternalRotationRightDeg),
          ),
          unit: ' deg',
          decimals: 1,
          icon: Icons.rotate_right,
          spots: items.lineSpots(
            (e) => numToDouble(e.goniometrics?.hipExternalRotationRightDeg),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'External Hip Rotation Left',
          comparisonTitle: 'External Hip Rotation Left',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipExternalRotationLeftDeg),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipExternalRotationLeftDeg),
          ),
          unit: ' deg',
          decimals: 1,
          icon: Icons.rotate_left,
          spots: items.lineSpots(
            (e) => numToDouble(e.goniometrics?.hipExternalRotationLeftDeg),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Total Hip Rotation Right / Left Ratio',
          comparisonTitle: 'Total Hip Rotation Right / Left Ratio',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipTotal),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.goniometrics?.hipTotal),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.balance,
          spots: items.lineSpots((e) => numToDouble(e.goniometrics?.hipTotal)),
          labels: labels,
        ),
      ],
    );
  }
}
