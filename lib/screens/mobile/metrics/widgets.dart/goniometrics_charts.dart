import 'package:athlete_hub/helpers/imports.dart';

class GoniometricsCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const GoniometricsCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    final latestHipFlexionRight = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipFlexionRightDeg),
    );
    final previousHipFlexionRight = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipFlexionRightDeg),
    );
    final latestHipFlexionLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipFlexionLeftDeg),
    );
    final previousHipFlexionLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipFlexionLeftDeg),
    );

    final latestKneeFlexionRight = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.kneeFlexionRightDeg),
    );
    final previousKneeFlexionRight = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.kneeFlexionRightDeg),
    );
    final latestKneeFlexionLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.kneeFlexionLeftDeg),
    );
    final previousKneeFlexionLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.kneeFlexionLeftDeg),
    );

    final latestHipInternalRight = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipInternalRotationRightDeg),
    );
    final previousHipInternalRight = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipInternalRotationRightDeg),
    );
    final latestHipInternalLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipInternalRotationLeftDeg),
    );
    final previousHipInternalLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipInternalRotationLeftDeg),
    );

    final latestHipExternalRight = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipExternalRotationRightDeg),
    );
    final previousHipExternalRight = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipExternalRotationRightDeg),
    );
    final latestHipExternalLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipExternalRotationLeftDeg),
    );
    final previousHipExternalLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipExternalRotationLeftDeg),
    );

    final latestLegRatio = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.legRlRatio),
    );
    final previousLegRatio = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.legRlRatio),
    );

    final latestKneeRatio = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.kneeRlRatio),
    );
    final previousKneeRatio = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.kneeRlRatio),
    );

    final latestHipTotal = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipTotal),
    );
    final previousHipTotal = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.hipTotal),
    );

    return ChartSection(
      title: 'Goniometrics',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hip Flexion Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map((e) => numToDouble(e.goniometrics?.hipFlexionRightDeg) ?? 0)
                .toList(),
            secondValues: items
                .map((e) => numToDouble(e.goniometrics?.hipFlexionLeftDeg) ?? 0)
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hip Flexion Right Comparison',
          latestValue: latestHipFlexionRight,
          previousValue: previousHipFlexionRight,
          unit: '°',
          decimals: 1,
          icon: Icons.straighten,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hip Flexion Left Comparison',
          latestValue: latestHipFlexionLeft,
          previousValue: previousHipFlexionLeft,
          unit: '°',
          decimals: 1,
          icon: Icons.straighten,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Knee Flexion Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map((e) => numToDouble(e.goniometrics?.kneeFlexionRightDeg) ?? 0)
                .toList(),
            secondValues: items
                .map((e) => numToDouble(e.goniometrics?.kneeFlexionLeftDeg) ?? 0)
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Knee Flexion Right Comparison',
          latestValue: latestKneeFlexionRight,
          previousValue: previousKneeFlexionRight,
          unit: '°',
          decimals: 1,
          icon: Icons.straighten,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Knee Flexion Left Comparison',
          latestValue: latestKneeFlexionLeft,
          previousValue: previousKneeFlexionLeft,
          unit: '°',
          decimals: 1,
          icon: Icons.straighten,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hip Internal Rotation Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) => numToDouble(e.goniometrics?.hipInternalRotationRightDeg) ?? 0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) => numToDouble(e.goniometrics?.hipInternalRotationLeftDeg) ?? 0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hip Internal Rotation Right Comparison',
          latestValue: latestHipInternalRight,
          previousValue: previousHipInternalRight,
          unit: '°',
          decimals: 1,
          icon: Icons.rotate_right,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hip Internal Rotation Left Comparison',
          latestValue: latestHipInternalLeft,
          previousValue: previousHipInternalLeft,
          unit: '°',
          decimals: 1,
          icon: Icons.rotate_left,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hip External Rotation Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) => numToDouble(e.goniometrics?.hipExternalRotationRightDeg) ?? 0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) => numToDouble(e.goniometrics?.hipExternalRotationLeftDeg) ?? 0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hip External Rotation Right Comparison',
          latestValue: latestHipExternalRight,
          previousValue: previousHipExternalRight,
          unit: '°',
          decimals: 1,
          icon: Icons.rotate_right,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hip External Rotation Left Comparison',
          latestValue: latestHipExternalLeft,
          previousValue: previousHipExternalLeft,
          unit: '°',
          decimals: 1,
          icon: Icons.rotate_left,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Leg R/L Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => numToDouble(e.goniometrics?.legRlRatio)),
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
            spots: items.lineSpots((e) => numToDouble(e.goniometrics?.kneeRlRatio)),
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
          title: 'Hip Total',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => numToDouble(e.goniometrics?.hipTotal)),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hip Total Comparison',
          latestValue: latestHipTotal,
          previousValue: previousHipTotal,
          unit: '',
          decimals: 2,
          icon: Icons.show_chart,
        ),
      ],
    );
  }
}
