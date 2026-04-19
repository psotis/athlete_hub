import 'package:athlete_hub/helpers/imports.dart';

class DynamometricsCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const DynamometricsCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    final latestGripRight = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.handGripRightN),
    );
    final previousGripRight = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.handGripRightN),
    );
    final latestGripLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.handGripLeftN),
    );
    final previousGripLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.handGripLeftN),
    );

    final latestKneeExtensionRight = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.kneeExtensionRightN),
    );
    final previousKneeExtensionRight = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.kneeExtensionRightN),
    );
    final latestKneeExtensionLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.kneeExtensionLeftN),
    );
    final previousKneeExtensionLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.kneeExtensionLeftN),
    );

    final latestKneeFlexionRight = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.kneeFlexionRightN),
    );
    final previousKneeFlexionRight = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.kneeFlexionRightN),
    );
    final latestKneeFlexionLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.kneeFlexionLeftN),
    );
    final previousKneeFlexionLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.kneeFlexionLeftN),
    );

    final latestShoulderIntRight = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationRightN),
    );
    final previousShoulderIntRight = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationRightN),
    );
    final latestShoulderIntLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationLeftN),
    );
    final previousShoulderIntLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationLeftN),
    );

    final latestShoulderExtRight = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationRightN),
    );
    final previousShoulderExtRight = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationRightN),
    );
    final latestShoulderExtLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationLeftN),
    );
    final previousShoulderExtLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationLeftN),
    );

    final latestMidThigh = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.midThighPullN),
    );
    final previousMidThigh = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.midThighPullN),
    );

    final latestHandRatio = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.handRlRatio),
    );
    final previousHandRatio = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.handRlRatio),
    );

    final latestLegRatio = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.legRlRatio),
    );
    final previousLegRatio = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.legRlRatio),
    );

    final latestKneeRatio = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.kneeRlRatio),
    );
    final previousKneeRatio = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.kneeRlRatio),
    );

    final latestShoulderIntRatio = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderIntRatio),
    );
    final previousShoulderIntRatio = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderIntRatio),
    );

    final latestShoulderExtRatio = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderExtRatio),
    );
    final previousShoulderExtRatio = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.shoulderExtRatio),
    );

    return ChartSection(
      title: 'Dynamometrics',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hand Grip Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map((e) => numToDouble(e.dynamometrics?.handGripRightN) ?? 0)
                .toList(),
            secondValues: items
                .map((e) => numToDouble(e.dynamometrics?.handGripLeftN) ?? 0)
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hand Grip Right Comparison',
          latestValue: latestGripRight,
          previousValue: previousGripRight,
          unit: ' N',
          decimals: 1,
          icon: Icons.pan_tool_alt,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hand Grip Left Comparison',
          latestValue: latestGripLeft,
          previousValue: previousGripLeft,
          unit: ' N',
          decimals: 1,
          icon: Icons.pan_tool,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Knee Extension Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map((e) => numToDouble(e.dynamometrics?.kneeExtensionRightN) ?? 0)
                .toList(),
            secondValues: items
                .map((e) => numToDouble(e.dynamometrics?.kneeExtensionLeftN) ?? 0)
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Knee Extension Right Comparison',
          latestValue: latestKneeExtensionRight,
          previousValue: previousKneeExtensionRight,
          unit: ' N',
          decimals: 1,
          icon: Icons.fitness_center,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Knee Extension Left Comparison',
          latestValue: latestKneeExtensionLeft,
          previousValue: previousKneeExtensionLeft,
          unit: ' N',
          decimals: 1,
          icon: Icons.fitness_center,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Knee Flexion Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map((e) => numToDouble(e.dynamometrics?.kneeFlexionRightN) ?? 0)
                .toList(),
            secondValues: items
                .map((e) => numToDouble(e.dynamometrics?.kneeFlexionLeftN) ?? 0)
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Knee Flexion Right Comparison',
          latestValue: latestKneeFlexionRight,
          previousValue: previousKneeFlexionRight,
          unit: ' N',
          decimals: 1,
          icon: Icons.fitness_center,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Knee Flexion Left Comparison',
          latestValue: latestKneeFlexionLeft,
          previousValue: previousKneeFlexionLeft,
          unit: ' N',
          decimals: 1,
          icon: Icons.fitness_center,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Shoulder Internal Rotation Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationRightN) ?? 0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) => numToDouble(e.dynamometrics?.shoulderInternalRotationLeftN) ?? 0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Shoulder Internal Rotation Right Comparison',
          latestValue: latestShoulderIntRight,
          previousValue: previousShoulderIntRight,
          unit: ' N',
          decimals: 1,
          icon: Icons.sports_gymnastics,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Shoulder Internal Rotation Left Comparison',
          latestValue: latestShoulderIntLeft,
          previousValue: previousShoulderIntLeft,
          unit: ' N',
          decimals: 1,
          icon: Icons.sports_gymnastics,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Shoulder External Rotation Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationRightN) ?? 0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) => numToDouble(e.dynamometrics?.shoulderExternalRotationLeftN) ?? 0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Shoulder External Rotation Right Comparison',
          latestValue: latestShoulderExtRight,
          previousValue: previousShoulderExtRight,
          unit: ' N',
          decimals: 1,
          icon: Icons.sports_gymnastics,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Shoulder External Rotation Left Comparison',
          latestValue: latestShoulderExtLeft,
          previousValue: previousShoulderExtLeft,
          unit: ' N',
          decimals: 1,
          icon: Icons.sports_gymnastics,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Mid Thigh Pull Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.dynamometrics?.midThighPullN),
            ),
            labels: labels,
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Mid Thigh Pull Comparison',
          latestValue: latestMidThigh,
          previousValue: previousMidThigh,
          unit: ' N',
          decimals: 1,
          icon: Icons.straighten,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hand R/L Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => numToDouble(e.dynamometrics?.handRlRatio)),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hand R/L Ratio Comparison',
          latestValue: latestHandRatio,
          previousValue: previousHandRatio,
          unit: '',
          decimals: 2,
          icon: Icons.balance,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Leg R/L Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => numToDouble(e.dynamometrics?.legRlRatio)),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Leg R/L Ratio Comparison',
          latestValue: latestLegRatio,
          previousValue: previousLegRatio,
          unit: '',
          decimals: 2,
          icon: Icons.balance,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Knee R/L Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => numToDouble(e.dynamometrics?.kneeRlRatio)),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Knee R/L Ratio Comparison',
          latestValue: latestKneeRatio,
          previousValue: previousKneeRatio,
          unit: '',
          decimals: 2,
          icon: Icons.balance,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Shoulder Internal Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.dynamometrics?.shoulderIntRatio),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Shoulder Internal Ratio Comparison',
          latestValue: latestShoulderIntRatio,
          previousValue: previousShoulderIntRatio,
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Shoulder External Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.dynamometrics?.shoulderExtRatio),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Shoulder External Ratio Comparison',
          latestValue: latestShoulderExtRatio,
          previousValue: previousShoulderExtRatio,
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
        ),
      ],
    );
  }
}
