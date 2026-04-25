import 'package:athlete_hub/helpers/imports.dart';

class EnduranceCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const EnduranceCharts({super.key, required this.items});

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
      title: 'Endurance',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Beep Test Level / Shuttles',
          comparisonTitle: 'Beep Test Level / Shuttles',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.endurance?.beepTestContinuousScore),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.endurance?.beepTestContinuousScore),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.format_list_numbered,
          spots: items.lineSpots(
            (e) => numToDouble(e.endurance?.beepTestContinuousScore),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Beep Test Distance',
          comparisonTitle: 'Beep Test Distance',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.endurance?.beepTestDistanceM),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.endurance?.beepTestDistanceM),
          ),
          unit: ' m',
          decimals: 0,
          icon: Icons.straighten,
          spots: items.lineSpots(
            (e) => numToDouble(e.endurance?.beepTestDistanceM),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Beep Test HR Max',
          comparisonTitle: 'Beep Test HR Max',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.endurance?.hrMax),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.endurance?.hrMax),
          ),
          unit: ' bpm',
          decimals: 0,
          icon: Icons.monitor_heart,
          spots: items.lineSpots((e) => numToDouble(e.endurance?.hrMax)),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Beep Test VO2max (ml/kg/min)',
          comparisonTitle: 'Beep Test VO2max',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.endurance?.beepTestVo2maxMlKgMin),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.endurance?.beepTestVo2maxMlKgMin),
          ),
          unit: ' ml/kg/min',
          decimals: 2,
          icon: Icons.air,
          spots: items.lineSpots(
            (e) => numToDouble(e.endurance?.beepTestVo2maxMlKgMin),
          ),
          labels: labels,
        ),
      ],
    );
  }
}
