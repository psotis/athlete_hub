import 'package:athlete_hub/helpers/imports.dart';

class EnduranceCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const EnduranceCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    final latestScore = latestMetricValue(
      items,
      (e) => numToDouble(e.endurance?.beepTestContinuousScore),
    );
    final previousScore = previousMetricValue(
      items,
      (e) => numToDouble(e.endurance?.beepTestContinuousScore),
    );

    final latestDistance = latestMetricValue(
      items,
      (e) => numToDouble(e.endurance?.beepTestDistanceM),
    );
    final previousDistance = previousMetricValue(
      items,
      (e) => numToDouble(e.endurance?.beepTestDistanceM),
    );

    final latestVo2 = latestMetricValue(
      items,
      (e) => numToDouble(e.endurance?.beepTestVo2maxMlKgMin),
    );
    final previousVo2 = previousMetricValue(
      items,
      (e) => numToDouble(e.endurance?.beepTestVo2maxMlKgMin),
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
          title: 'Latest Beep Test Score',
          value: latestScore?.toStringAsFixed(2) ?? '-',
          subtitle: latest?.session?.measurementDate != null
              ? _formatDate(latest!.session!.measurementDate!)
              : null,
          icon: Icons.favorite,
        ),
        const SizedBox(height: 12),

        MetricDeltaCard(
          title: 'Beep Test Score Change',
          latestValue: latestScore,
          previousValue: previousScore,
          unit: '',
          decimals: 2,
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 12),

        MetricDeltaCard(
          title: 'Distance Change',
          latestValue: latestDistance,
          previousValue: previousDistance,
          unit: ' m',
          decimals: 0,
          icon: Icons.straighten,
        ),
        const SizedBox(height: 12),

        MetricDeltaCard(
          title: 'VO2max Change',
          latestValue: latestVo2,
          previousValue: previousVo2,
          unit: ' ml/kg/min',
          decimals: 2,
          icon: Icons.air,
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
          title: 'Beep Test Score Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.endurance?.beepTestContinuousScore),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),

        ChartCard(
          title: 'Distance Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.endurance?.beepTestDistanceM),
            ),
            labels: labels,
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),

        ChartCard(
          title: 'VO2max Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.endurance?.beepTestVo2maxMlKgMin),
            ),
            labels: labels,
            yDecimals: 2,
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
