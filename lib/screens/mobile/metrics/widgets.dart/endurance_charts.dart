import 'package:athlete_hub/helpers/imports.dart';

class EnduranceCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const EnduranceCharts({super.key, required this.items});

  bool _hasVo2Test(ErgometricsDetails item) {
    final endurance = item.endurance;
    return endurance?.maxSpeed != null ||
        endurance?.hrMaxVo != null ||
        endurance?.vo2Max != null;
  }

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
    final vo2Items = items.where(_hasVo2Test).toList();
    final relevantItems = vo2Items.isNotEmpty ? vo2Items : items;
    final labels = relevantItems.sessionLabels;
    final latest = relevantItems.isNotEmpty ? relevantItems.last : null;
    final showVo2 = vo2Items.isNotEmpty;

    return ChartSection(
      title: 'Endurance',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        if (showVo2) ...[
          ..._metricBlock(
            title: 'VO2 Max Speed',
            comparisonTitle: 'VO2 Max Speed',
            latestValue: latestMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.maxSpeed),
            ),
            previousValue: previousMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.maxSpeed),
            ),
            unit: ' km/h',
            decimals: 2,
            icon: Icons.speed,
            spots: relevantItems.lineSpots(
              (e) => numToDouble(e.endurance?.maxSpeed),
            ),
            labels: labels,
          ),
          const SizedBox(height: 12),
          ..._metricBlock(
            title: 'VO2 HR Max',
            comparisonTitle: 'VO2 HR Max',
            latestValue: latestMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.hrMaxVo),
            ),
            previousValue: previousMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.hrMaxVo),
            ),
            unit: ' bpm',
            decimals: 0,
            icon: Icons.monitor_heart,
            spots: relevantItems.lineSpots(
              (e) => numToDouble(e.endurance?.hrMaxVo),
            ),
            labels: labels,
          ),
          const SizedBox(height: 12),
          ..._metricBlock(
            title: 'VO2max (ml/kg/min)',
            comparisonTitle: 'VO2max',
            latestValue: latestMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.vo2Max),
            ),
            previousValue: previousMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.vo2Max),
            ),
            unit: ' ml/kg/min',
            decimals: 2,
            icon: Icons.air,
            spots: relevantItems.lineSpots(
              (e) => numToDouble(e.endurance?.vo2Max),
            ),
            labels: labels,
          ),
        ] else ...[
          ..._metricBlock(
            title: 'Beep Test Level / Shuttles',
            comparisonTitle: 'Beep Test Level / Shuttles',
            latestValue: latestMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.beepTestContinuousScore),
            ),
            previousValue: previousMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.beepTestContinuousScore),
            ),
            unit: '',
            decimals: 2,
            icon: Icons.format_list_numbered,
            spots: relevantItems.lineSpots(
              (e) => numToDouble(e.endurance?.beepTestContinuousScore),
            ),
            labels: labels,
          ),
          const SizedBox(height: 12),
          ..._metricBlock(
            title: 'Beep Test Distance',
            comparisonTitle: 'Beep Test Distance',
            latestValue: latestMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.beepTestDistanceM),
            ),
            previousValue: previousMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.beepTestDistanceM),
            ),
            unit: ' m',
            decimals: 0,
            icon: Icons.straighten,
            spots: relevantItems.lineSpots(
              (e) => numToDouble(e.endurance?.beepTestDistanceM),
            ),
            labels: labels,
          ),
          const SizedBox(height: 12),
          ..._metricBlock(
            title: 'Beep Test HR Max',
            comparisonTitle: 'Beep Test HR Max',
            latestValue: latestMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.hrMax),
            ),
            previousValue: previousMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.hrMax),
            ),
            unit: ' bpm',
            decimals: 0,
            icon: Icons.monitor_heart,
            spots: relevantItems.lineSpots(
              (e) => numToDouble(e.endurance?.hrMax),
            ),
            labels: labels,
          ),
          const SizedBox(height: 12),
          ..._metricBlock(
            title: 'Beep Test VO2max (ml/kg/min)',
            comparisonTitle: 'Beep Test VO2max',
            latestValue: latestMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.beepTestVo2maxMlKgMin),
            ),
            previousValue: previousMetricValue(
              relevantItems,
              (e) => numToDouble(e.endurance?.beepTestVo2maxMlKgMin),
            ),
            unit: ' ml/kg/min',
            decimals: 2,
            icon: Icons.air,
            spots: relevantItems.lineSpots(
              (e) => numToDouble(e.endurance?.beepTestVo2maxMlKgMin),
            ),
            labels: labels,
          ),
        ],
      ],
    );
  }
}
