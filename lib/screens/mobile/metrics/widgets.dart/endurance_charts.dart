import 'package:athlete_hub/helpers/imports.dart';

class EnduranceCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const EnduranceCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    final latestBeep = latestMetricValue(
      items,
      (e) => numToDouble(e.endurance?.beepTestLevel),
    );
    final previousBeep = previousMetricValue(
      items,
      (e) => numToDouble(e.endurance?.beepTestLevel),
    );

    final latestHr = latestMetricValue(
      items,
      (e) => numToDouble(e.endurance?.hrMax),
    );
    final previousHr = previousMetricValue(
      items,
      (e) => numToDouble(e.endurance?.hrMax),
    );

    return ChartSection(
      title: 'Endurance',
      children: [
        SummaryStatCard(
          title: 'Latest Beep Test Level',
          value:
              numToDouble(
                latest?.endurance?.beepTestLevel,
              )?.toStringAsFixed(0) ??
              '-',
          subtitle: latest?.session?.measurementDate != null
              ? _formatDate(latest!.session!.measurementDate!)
              : null,
          icon: Icons.favorite,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Beep Test Level Change',
          latestValue: latestBeep,
          previousValue: previousBeep,
          unit: '',
          decimals: 0,
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'HR Max Change',
          latestValue: latestHr,
          previousValue: previousHr,
          unit: ' bpm',
          decimals: 0,
          icon: Icons.monitor_heart,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Beep Test Level Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.endurance?.beepTestLevel),
            ),
            labels: labels,
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Beep Test Shuttles',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.endurance?.beepTestShuttles),
            ),
            labels: labels,
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'HR Max Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => numToDouble(e.endurance?.hrMax)),
            labels: labels,
            yDecimals: 0,
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
