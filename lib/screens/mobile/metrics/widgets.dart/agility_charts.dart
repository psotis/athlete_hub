import 'package:athlete_hub/helpers/imports.dart';

class AgilityCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const AgilityCharts({super.key, required this.items});

  List<Widget> _metricBlock({
    required String title,
    required String comparisonTitle,
    required double? latestValue,
    required double? previousValue,
    required List<FlSpot> spots,
    required List<String> labels,
    IconData icon = Icons.timer,
  }) {
    return [
      MetricDeltaCard(
        title: comparisonTitle,
        latestValue: latestValue,
        previousValue: previousValue,
        unit: ' s',
        decimals: 2,
        lowerIsBetter: true,
        icon: icon,
      ),
      const SizedBox(height: 12),
      ChartCard(
        title: title,
        chart: SimpleLineChart(spots: spots, labels: labels, yDecimals: 2),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    return ChartSection(
      title: 'Agility & Speed',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: '5-10-5 Right',
          comparisonTitle: '5-10-5 Right',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.agilitySpeed?.test5105RightSec),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.agilitySpeed?.test5105RightSec),
          ),
          spots: items.lineSpots(
            (e) => numToDouble(e.agilitySpeed?.test5105RightSec),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: '5-10-5 Left',
          comparisonTitle: '5-10-5 Left',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.agilitySpeed?.test5105LeftSec),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.agilitySpeed?.test5105LeftSec),
          ),
          spots: items.lineSpots(
            (e) => numToDouble(e.agilitySpeed?.test5105LeftSec),
          ),
          labels: labels,
          icon: Icons.timer_outlined,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Sprint 0-10 m',
          comparisonTitle: 'Sprint 0-10 m',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.agilitySpeed?.sprint010Sec),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.agilitySpeed?.sprint010Sec),
          ),
          spots: items.lineSpots(
            (e) => numToDouble(e.agilitySpeed?.sprint010Sec),
          ),
          labels: labels,
          icon: Icons.directions_run,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Sprint 0-20 m',
          comparisonTitle: 'Sprint 0-20 m',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.agilitySpeed?.sprint020Sec),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.agilitySpeed?.sprint020Sec),
          ),
          spots: items.lineSpots(
            (e) => numToDouble(e.agilitySpeed?.sprint020Sec),
          ),
          labels: labels,
          icon: Icons.speed,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Sprint 0-30 m',
          comparisonTitle: 'Sprint 0-30 m',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.agilitySpeed?.sprint030Sec),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.agilitySpeed?.sprint030Sec),
          ),
          spots: items.lineSpots(
            (e) => numToDouble(e.agilitySpeed?.sprint030Sec),
          ),
          labels: labels,
          icon: Icons.ssid_chart,
        ),
      ],
    );
  }
}
