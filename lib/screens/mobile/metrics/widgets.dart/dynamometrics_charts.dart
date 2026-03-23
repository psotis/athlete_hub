import 'package:athlete_hub/helpers/imports.dart';

class DynamometricsCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const DynamometricsCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    final latestGrip = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.handGripRightN),
    );
    final previousGrip = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.handGripRightN),
    );

    final latestMidThigh = latestMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.midThighPullN),
    );
    final previousMidThigh = previousMetricValue(
      items,
      (e) => numToDouble(e.dynamometrics?.midThighPullN),
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
        SummaryStatCard(
          title: 'Latest Hand Grip Right',
          value:
              '${numToDouble(latest?.dynamometrics?.handGripRightN)?.toStringAsFixed(1) ?? '-'} N',
          subtitle: latest?.session?.measurementDate != null
              ? _formatDate(latest!.session!.measurementDate!)
              : null,
          icon: Icons.fitness_center,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hand Grip Right Change',
          latestValue: latestGrip,
          previousValue: previousGrip,
          unit: ' N',
          decimals: 1,
          icon: Icons.pan_tool_alt,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Mid Thigh Pull Change',
          latestValue: latestMidThigh,
          previousValue: previousMidThigh,
          unit: ' N',
          decimals: 1,
          icon: Icons.straighten,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Shoulder External Ratio Change',
          latestValue: latestShoulderExtRatio,
          previousValue: previousShoulderExtRatio,
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
        ),
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
        ChartCard(
          title: 'Knee Extension Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) => numToDouble(e.dynamometrics?.kneeExtensionRightN) ?? 0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) => numToDouble(e.dynamometrics?.kneeExtensionLeftN) ?? 0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Knee Flexion Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) => numToDouble(e.dynamometrics?.kneeFlexionRightN) ?? 0,
                )
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
        ChartCard(
          title: 'Shoulder Internal Rotation Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) =>
                      numToDouble(
                        e.dynamometrics?.shoulderInternalRotationRightN,
                      ) ??
                      0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) =>
                      numToDouble(
                        e.dynamometrics?.shoulderInternalRotationLeftN,
                      ) ??
                      0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Shoulder External Rotation Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) =>
                      numToDouble(
                        e.dynamometrics?.shoulderExternalRotationRightN,
                      ) ??
                      0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) =>
                      numToDouble(
                        e.dynamometrics?.shoulderExternalRotationLeftN,
                      ) ??
                      0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 0,
          ),
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
        ChartCard(
          title: 'Hand R/L Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.dynamometrics?.handRlRatio),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Leg R/L Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.dynamometrics?.legRlRatio),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Knee R/L Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.dynamometrics?.kneeRlRatio),
            ),
            labels: labels,
            yDecimals: 2,
          ),
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
      ],
    );
  }
}

String _formatDate(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.day.toString().padLeft(2, '0')}";
}
