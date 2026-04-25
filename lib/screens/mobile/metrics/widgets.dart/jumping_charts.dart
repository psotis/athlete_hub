import 'package:athlete_hub/helpers/imports.dart';

class JumpingCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const JumpingCharts({super.key, required this.items});

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
      title: 'Jumping Ability',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Squat Jump Height (cm)',
          comparisonTitle: 'Squat Jump Height',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.squatJumpHeightCm),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.squatJumpHeightCm),
          ),
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.squatJumpHeightCm),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Squat Jump Power (watt)',
          comparisonTitle: 'Squat Jump Power',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.squatJumpPowerW),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.squatJumpPowerW),
          ),
          unit: ' W',
          decimals: 0,
          icon: Icons.bolt,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.squatJumpPowerW),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Counter Movement Jump Height (cm)',
          comparisonTitle: 'Counter Movement Jump Height',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.cmjHeightCm),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.cmjHeightCm),
          ),
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.cmjHeightCm),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Counter Movement Jump Power (watt)',
          comparisonTitle: 'Counter Movement Jump Power',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.cmjPowerW),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.cmjPowerW),
          ),
          unit: ' W',
          decimals: 0,
          icon: Icons.bolt,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.cmjPowerW),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Counter Movement Jump Free Hands Height (cm)',
          comparisonTitle: 'Counter Movement Jump Free Hands Height',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsHeightCm),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsHeightCm),
          ),
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsHeightCm),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Counter Movement Jump Free Hands Power (watt)',
          comparisonTitle: 'Counter Movement Jump Free Hands Power',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsPowerW),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsPowerW),
          ),
          unit: ' W',
          decimals: 0,
          icon: Icons.bolt,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsPowerW),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Drop Jump Height (cm)',
          comparisonTitle: 'Drop Jump Height',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.dropJumpHeightCm),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.dropJumpHeightCm),
          ),
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.dropJumpHeightCm),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Drop Jump RSI',
          comparisonTitle: 'Drop Jump RSI',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.dropJumpRsi),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.dropJumpRsi),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.dropJumpRsi),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Single Leg CMJ Right Height (cm)',
          comparisonTitle: 'Single Leg CMJ Right Height',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjRightHeightCm),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjRightHeightCm),
          ),
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjRightHeightCm),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Single Leg CMJ Right Power (watt)',
          comparisonTitle: 'Single Leg CMJ Right Power',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjRightPowerW),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjRightPowerW),
          ),
          unit: ' W',
          decimals: 0,
          icon: Icons.bolt,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjRightPowerW),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Single Leg CMJ Left Height (cm)',
          comparisonTitle: 'Single Leg CMJ Left Height',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftHeightCm),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftHeightCm),
          ),
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftHeightCm),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Single Leg CMJ Left Power (watt)',
          comparisonTitle: 'Single Leg CMJ Left Power',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftPowerW),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftPowerW),
          ),
          unit: ' W',
          decimals: 0,
          icon: Icons.bolt,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftPowerW),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Elastic Utilization Ratio',
          comparisonTitle: 'Elastic Utilization Ratio',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.elasticUtilRatio),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.elasticUtilRatio),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.show_chart,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.elasticUtilRatio),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Arm Swing Contribution',
          comparisonTitle: 'Arm Swing Contribution',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.armSwing),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.armSwing),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.armSwing),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Bilateral Deficit',
          comparisonTitle: 'Bilateral Deficit',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.biliteralDeficit),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.biliteralDeficit),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.biliteralDeficit),
          ),
          labels: labels,
        ),
        const SizedBox(height: 12),
        ..._metricBlock(
          title: 'Single Leg Jumps Ratio',
          comparisonTitle: 'Single Leg Jumps Ratio',
          latestValue: latestMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.singleLegJump),
          ),
          previousValue: previousMetricValue(
            items,
            (e) => numToDouble(e.jumpingAbility?.singleLegJump),
          ),
          unit: '',
          decimals: 2,
          icon: Icons.show_chart,
          spots: items.lineSpots(
            (e) => numToDouble(e.jumpingAbility?.singleLegJump),
          ),
          labels: labels,
        ),
      ],
    );
  }
}
