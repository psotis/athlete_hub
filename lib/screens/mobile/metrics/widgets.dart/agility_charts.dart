import 'package:athlete_hub/helpers/imports.dart';

class AgilityCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const AgilityCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    final latestTestRight = latestMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.test5105RightSec),
    );
    final previousTestRight = previousMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.test5105RightSec),
    );
    final latestTestLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.test5105LeftSec),
    );
    final previousTestLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.test5105LeftSec),
    );

    final latestSprint10 = latestMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.sprint010Sec),
    );
    final previousSprint10 = previousMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.sprint010Sec),
    );
    final latestSprint20 = latestMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.sprint020Sec),
    );
    final previousSprint20 = previousMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.sprint020Sec),
    );
    final latestSprint30 = latestMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.sprint030Sec),
    );
    final previousSprint30 = previousMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.sprint030Sec),
    );

    return ChartSection(
      title: 'Agility & Speed',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        ChartCard(
          title: '5-10-5 Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map((e) => numToDouble(e.agilitySpeed?.test5105RightSec) ?? 0)
                .toList(),
            secondValues: items
                .map((e) => numToDouble(e.agilitySpeed?.test5105LeftSec) ?? 0)
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: '5-10-5 Right Comparison',
          latestValue: latestTestRight,
          previousValue: previousTestRight,
          unit: ' s',
          decimals: 2,
          lowerIsBetter: true,
          icon: Icons.timer,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: '5-10-5 Left Comparison',
          latestValue: latestTestLeft,
          previousValue: previousTestLeft,
          unit: ' s',
          decimals: 2,
          lowerIsBetter: true,
          icon: Icons.timer_outlined,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Sprint 0-10 Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.agilitySpeed?.sprint010Sec),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Sprint 0-10 Comparison',
          latestValue: latestSprint10,
          previousValue: previousSprint10,
          unit: ' s',
          decimals: 2,
          lowerIsBetter: true,
          icon: Icons.directions_run,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Sprint 0-20 Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.agilitySpeed?.sprint020Sec),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Sprint 0-20 Comparison',
          latestValue: latestSprint20,
          previousValue: previousSprint20,
          unit: ' s',
          decimals: 2,
          lowerIsBetter: true,
          icon: Icons.speed,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Sprint 0-30 Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.agilitySpeed?.sprint030Sec),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Sprint 0-30 Comparison',
          latestValue: latestSprint30,
          previousValue: previousSprint30,
          unit: ' s',
          decimals: 2,
          lowerIsBetter: true,
          icon: Icons.ssid_chart,
        ),
      ],
    );
  }
}
