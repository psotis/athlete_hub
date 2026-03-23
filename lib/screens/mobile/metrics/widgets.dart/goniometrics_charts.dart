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

    final latestKneeRatio = latestMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.kneeRlRatio),
    );
    final previousKneeRatio = previousMetricValue(
      items,
      (e) => numToDouble(e.goniometrics?.kneeRlRatio),
    );

    return ChartSection(
      title: 'Goniometrics',
      children: [
        SummaryStatCard(
          title: 'Latest Hip Flexion Right',
          value:
              '${numToDouble(latest?.goniometrics?.hipFlexionRightDeg)?.toStringAsFixed(1) ?? '-'}°',
          subtitle: latest?.session?.measurementDate != null
              ? _formatDate(latest!.session!.measurementDate!)
              : null,
          icon: Icons.straighten,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Hip Flexion Right Change',
          latestValue: latestHipFlexionRight,
          previousValue: previousHipFlexionRight,
          unit: '°',
          decimals: 1,
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Knee R/L Ratio Change',
          latestValue: latestKneeRatio,
          previousValue: previousKneeRatio,
          unit: '',
          decimals: 2,
          icon: Icons.balance,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hip Flexion Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) => numToDouble(e.goniometrics?.hipFlexionRightDeg) ?? 0,
                )
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
        ChartCard(
          title: 'Knee Flexion Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) => numToDouble(e.goniometrics?.kneeFlexionRightDeg) ?? 0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) => numToDouble(e.goniometrics?.kneeFlexionLeftDeg) ?? 0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hip Internal Rotation Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) =>
                      numToDouble(
                        e.goniometrics?.hipInternalRotationRightDeg,
                      ) ??
                      0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) =>
                      numToDouble(e.goniometrics?.hipInternalRotationLeftDeg) ??
                      0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hip External Rotation Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) =>
                      numToDouble(
                        e.goniometrics?.hipExternalRotationRightDeg,
                      ) ??
                      0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) =>
                      numToDouble(e.goniometrics?.hipExternalRotationLeftDeg) ??
                      0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Leg R/L Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.goniometrics?.legRlRatio),
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
              (e) => numToDouble(e.goniometrics?.kneeRlRatio),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Hip Total',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.goniometrics?.hipTotal),
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
