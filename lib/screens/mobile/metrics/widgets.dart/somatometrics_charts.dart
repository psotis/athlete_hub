import 'package:athlete_hub/helpers/imports.dart';

class SomatometricsCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const SomatometricsCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    final latestWeight = latestMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.weightKg),
    );
    final previousWeight = previousMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.weightKg),
    );

    final latestBodyFat = latestMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.bodyFatPercent),
    );
    final previousBodyFat = previousMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.bodyFatPercent),
    );

    return ChartSection(
      title: 'Somatometrics',
      children: [
        SummaryStatCard(
          title: 'Latest Weight',
          value:
              '${numToDouble(latest?.somatometrics?.weightKg)?.toStringAsFixed(1) ?? '-'} kg',
          subtitle: latest?.session?.measurementDate != null
              ? _formatDate(latest!.session!.measurementDate!)
              : null,
          icon: Icons.monitor_weight,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Weight Change',
          latestValue: latestWeight,
          previousValue: previousWeight,
          unit: ' kg',
          decimals: 1,
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Body Fat Change',
          latestValue: latestBodyFat,
          previousValue: previousBodyFat,
          unit: '%',
          decimals: 1,
          lowerIsBetter: true,
          icon: Icons.percent,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Weight Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.somatometrics?.weightKg),
            ),
            labels: labels,
            yDecimals: 1,
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
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'BMI',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => numToDouble(e.somatometrics?.bmi)),
            labels: labels,
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Height vs Arm Span',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map((e) => numToDouble(e.somatometrics?.heightCm) ?? 0)
                .toList(),
            secondValues: items
                .map((e) => numToDouble(e.somatometrics?.armSpanCm) ?? 0)
                .toList(),
            firstLegend: 'Height',
            secondLegend: 'Arm Span',
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Ape Index',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.somatometrics?.apeIndex),
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
