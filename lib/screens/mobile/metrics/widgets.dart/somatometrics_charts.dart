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

    final latestBmi = latestMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.bmi),
    );
    final previousBmi = previousMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.bmi),
    );

    final latestHeight = latestMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.heightCm),
    );
    final previousHeight = previousMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.heightCm),
    );

    final latestArmSpan = latestMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.armSpanCm),
    );
    final previousArmSpan = previousMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.armSpanCm),
    );

    final latestApeIndex = latestMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.apeIndex),
    );
    final previousApeIndex = previousMetricValue(
      items,
      (e) => numToDouble(e.somatometrics?.apeIndex),
    );

    return ChartSection(
      title: 'Somatometrics',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
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
        MetricDeltaCard(
          title: 'Weight Comparison',
          latestValue: latestWeight,
          previousValue: previousWeight,
          unit: ' kg',
          decimals: 1,
          icon: Icons.monitor_weight,
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
        MetricDeltaCard(
          title: 'Body Fat Comparison',
          latestValue: latestBodyFat,
          previousValue: previousBodyFat,
          unit: ' %',
          decimals: 1,
          lowerIsBetter: true,
          icon: Icons.percent,
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
        MetricDeltaCard(
          title: 'BMI Comparison',
          latestValue: latestBmi,
          previousValue: previousBmi,
          unit: '',
          decimals: 1,
          icon: Icons.insights,
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
        MetricDeltaCard(
          title: 'Height Comparison',
          latestValue: latestHeight,
          previousValue: previousHeight,
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Arm Span Comparison',
          latestValue: latestArmSpan,
          previousValue: previousArmSpan,
          unit: ' cm',
          decimals: 1,
          icon: Icons.straighten,
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
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Ape Index Comparison',
          latestValue: latestApeIndex,
          previousValue: previousApeIndex,
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
        ),
      ],
    );
  }
}
