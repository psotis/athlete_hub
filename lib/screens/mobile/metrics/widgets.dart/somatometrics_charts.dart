import 'package:athlete_hub/helpers/imports.dart';

class SomatometricsCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const SomatometricsCharts({super.key, required this.items});

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
    bool lowerIsBetter = false,
  }) {
    return [
      MetricDeltaCard(
        title: comparisonTitle,
        latestValue: latestValue,
        previousValue: previousValue,
        unit: unit,
        decimals: decimals,
        lowerIsBetter: lowerIsBetter,
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
      title: 'Somatometrics',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Height',
          comparisonTitle: 'Height',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.heightCm),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.heightCm),
          ),
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
          spots: items.lineSpots((e) => numToDouble(e.somatometrics?.heightCm)),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Wingspan',
          comparisonTitle: 'Wingspan',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.armSpanCm),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.armSpanCm),
          ),
          unit: ' cm',
          decimals: 1,
          icon: Icons.straighten,
          spots: items.lineSpots(
            (e) => numToDouble(e.somatometrics?.armSpanCm),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Ape Index',
          comparisonTitle: 'Ape Index',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.apeIndex),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.apeIndex),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
          spots: items.lineSpots((e) => numToDouble(e.somatometrics?.apeIndex)),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Weight',
          comparisonTitle: 'Weight',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.weightKg),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.weightKg),
          ),
          unit: ' kg',
          decimals: 1,
          icon: Icons.monitor_weight,
          spots: items.lineSpots((e) => numToDouble(e.somatometrics?.weightKg)),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'BMI',
          comparisonTitle: 'BMI',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.bmi),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.bmi),
          ),
          unit: '',
          decimals: 1,
          icon: Icons.insights,
          spots: items.lineSpots((e) => numToDouble(e.somatometrics?.bmi)),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Body Fat %',
          comparisonTitle: 'Body Fat %',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.bodyFatPercent),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.somatometrics?.bodyFatPercent),
          ),
          unit: ' %',
          decimals: 1,
          icon: Icons.percent,
          lowerIsBetter: true,
          spots: items.lineSpots(
            (e) => numToDouble(e.somatometrics?.bodyFatPercent),
          ),
          labels: labels,
        ),
      ],
    );
  }
}
