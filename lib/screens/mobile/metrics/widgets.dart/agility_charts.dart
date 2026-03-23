import 'package:athlete_hub/helpers/imports.dart';

class AgilityCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const AgilityCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    final latestSprint10 = latestMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.sprint010Sec),
    );
    final previousSprint10 = previousMetricValue(
      items,
      (e) => numToDouble(e.agilitySpeed?.sprint010Sec),
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
        SummaryStatCard(
          title: 'Latest Sprint 0-10',
          value:
              '${numToDouble(latest?.agilitySpeed?.sprint010Sec)?.toStringAsFixed(2) ?? '-'} s',
          subtitle: latest?.session?.measurementDate != null
              ? _formatDate(latest!.session!.measurementDate!)
              : null,
          icon: Icons.directions_run,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Sprint 0-10 Change',
          latestValue: latestSprint10,
          previousValue: previousSprint10,
          unit: ' s',
          decimals: 2,
          lowerIsBetter: true,
          icon: Icons.timer,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Sprint 0-30 Change',
          latestValue: latestSprint30,
          previousValue: previousSprint30,
          unit: ' s',
          decimals: 2,
          lowerIsBetter: true,
          icon: Icons.speed,
        ),
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
      ],
    );
  }
}

String _formatDate(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.day.toString().padLeft(2, '0')}";
}
