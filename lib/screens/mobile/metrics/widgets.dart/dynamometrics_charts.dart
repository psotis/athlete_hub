import 'package:athlete_hub/helpers/imports.dart';

class DynamometricsCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const DynamometricsCharts({super.key, required this.items});

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
      title: 'Dynamometrics',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Handgrip Strength Test Right Hand',
          comparisonTitle: 'Handgrip Strength Test Right Hand',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.handGripRightN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.handGripRightN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.pan_tool_alt,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.handGripRightN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Handgrip Strength Test Left Hand',
          comparisonTitle: 'Handgrip Strength Test Left Hand',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.handGripLeftN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.handGripLeftN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.pan_tool,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.handGripLeftN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Handgrip Right / Left Ratio',
          comparisonTitle: 'Handgrip Right / Left Ratio',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.handRlRatio),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.handRlRatio),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.balance,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.handRlRatio),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Mid Thigh Pull',
          comparisonTitle: 'Mid Thigh Pull',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.midThighPullN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.midThighPullN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.straighten,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.midThighPullN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Leg Extension 90 deg Right',
          comparisonTitle: 'Leg Extension 90 deg Right',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.kneeExtensionRightN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.kneeExtensionRightN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.fitness_center,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.kneeExtensionRightN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Leg Extension 90 deg Left',
          comparisonTitle: 'Leg Extension 90 deg Left',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.kneeExtensionLeftN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.kneeExtensionLeftN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.fitness_center,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.kneeExtensionLeftN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Leg Extension Right / Left Ratio',
          comparisonTitle: 'Leg Extension Right / Left Ratio',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.legRlRatio),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.legRlRatio),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.balance,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.legRlRatio),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Knee Flexion Prone 90 deg Right',
          comparisonTitle: 'Knee Flexion Prone 90 deg Right',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.kneeFlexionRightN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.kneeFlexionRightN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.fitness_center,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.kneeFlexionRightN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Knee Flexion Prone 90 deg Left',
          comparisonTitle: 'Knee Flexion Prone 90 deg Left',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.kneeFlexionLeftN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.kneeFlexionLeftN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.fitness_center,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.kneeFlexionLeftN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Knee Flexion Right / Left Ratio',
          comparisonTitle: 'Knee Flexion Right / Left Ratio',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.kneeRlRatio),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.kneeRlRatio),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.balance,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.kneeRlRatio),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Shoulder Internal Rotation Seated Right',
          comparisonTitle: 'Shoulder Internal Rotation Seated Right',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationRightN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationRightN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.sports_gymnastics,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationRightN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Shoulder Internal Rotation Seated Left',
          comparisonTitle: 'Shoulder Internal Rotation Seated Left',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationLeftN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationLeftN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.sports_gymnastics,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationLeftN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Shoulder Internal Rotation Right / Left Ratio',
          comparisonTitle: 'Shoulder Internal Rotation Right / Left Ratio',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderIntRatio),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderIntRatio),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.balance,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.shoulderIntRatio),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Shoulder External Rotation Seated Right',
          comparisonTitle: 'Shoulder External Rotation Seated Right',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationRightN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationRightN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.sports_gymnastics,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationRightN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Shoulder External Rotation Seated Left',
          comparisonTitle: 'Shoulder External Rotation Seated Left',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationLeftN),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationLeftN),
          ),
          unit: ' N',
          decimals: 1,
          icon: Icons.sports_gymnastics,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationLeftN),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Shoulder External Rotation Right / Left Ratio',
          comparisonTitle: 'Shoulder External Rotation Right / Left Ratio',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderExtRatio),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.dynamometrics?.shoulderExtRatio),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.balance,
          spots: items.lineSpots(
            (e) => numToDouble(e.dynamometrics?.shoulderExtRatio),
          ),
          labels: labels,
        ),
      ],
    );
  }
}
