import 'package:athlete_hub/helpers/imports.dart';

class JumpingCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const JumpingCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    final latestCmjHeight = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.cmjHeightCm),
    );
    final previousCmjHeight = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.cmjHeightCm),
    );
    final latestCmjPower = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.cmjPowerW),
    );
    final previousCmjPower = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.cmjPowerW),
    );

    final latestSquatHeight = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.squatJumpHeightCm),
    );
    final previousSquatHeight = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.squatJumpHeightCm),
    );
    final latestSquatPower = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.squatJumpPowerW),
    );
    final previousSquatPower = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.squatJumpPowerW),
    );

    final latestFreeHandsHeight = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsHeightCm),
    );
    final previousFreeHandsHeight = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsHeightCm),
    );
    final latestFreeHandsPower = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsPowerW),
    );
    final previousFreeHandsPower = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsPowerW),
    );

    final latestDropHeight = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.dropJumpHeightCm),
    );
    final previousDropHeight = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.dropJumpHeightCm),
    );
    final latestRsi = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.dropJumpRsi),
    );
    final previousRsi = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.dropJumpRsi),
    );

    final latestSingleLegHeightRight = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.singleLegCmjRightHeightCm),
    );
    final previousSingleLegHeightRight = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.singleLegCmjRightHeightCm),
    );
    final latestSingleLegHeightLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftHeightCm),
    );
    final previousSingleLegHeightLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftHeightCm),
    );

    final latestSingleLegPowerRight = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.singleLegCmjRightPowerW),
    );
    final previousSingleLegPowerRight = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.singleLegCmjRightPowerW),
    );
    final latestSingleLegPowerLeft = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftPowerW),
    );
    final previousSingleLegPowerLeft = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftPowerW),
    );

    final latestElasticUtilRatio = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.elasticUtilRatio),
    );
    final previousElasticUtilRatio = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.elasticUtilRatio),
    );

    final latestArmSwing = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.armSwing),
    );
    final previousArmSwing = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.armSwing),
    );

    final latestBiliteralDeficit = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.biliteralDeficit),
    );
    final previousBiliteralDeficit = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.biliteralDeficit),
    );

    final latestSingleLegJump = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.singleLegJump),
    );
    final previousSingleLegJump = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.singleLegJump),
    );

    return ChartSection(
      title: 'Jumping Ability',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        ChartCard(
          title: 'CMJ',
          height: 440,
          chart: _JumpingMetricPairChart(
            labels: labels,
            firstTitle: 'Height (cm)',
            firstSpots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.cmjHeightCm),
            ),
            firstDecimals: 1,
            secondTitle: 'Power (W)',
            secondSpots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.cmjPowerW),
            ),
            secondDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'CMJ Height Comparison',
          latestValue: latestCmjHeight,
          previousValue: previousCmjHeight,
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'CMJ Power Comparison',
          latestValue: latestCmjPower,
          previousValue: previousCmjPower,
          unit: ' W',
          decimals: 0,
          icon: Icons.bolt,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Squat Jump',
          height: 440,
          chart: _JumpingMetricPairChart(
            labels: labels,
            firstTitle: 'Height (cm)',
            firstSpots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.squatJumpHeightCm),
            ),
            firstDecimals: 1,
            secondTitle: 'Power (W)',
            secondSpots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.squatJumpPowerW),
            ),
            secondDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Squat Jump Height Comparison',
          latestValue: latestSquatHeight,
          previousValue: previousSquatHeight,
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Squat Jump Power Comparison',
          latestValue: latestSquatPower,
          previousValue: previousSquatPower,
          unit: ' W',
          decimals: 0,
          icon: Icons.bolt,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'CMJ Free Hands',
          height: 440,
          chart: _JumpingMetricPairChart(
            labels: labels,
            firstTitle: 'Height (cm)',
            firstSpots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsHeightCm),
            ),
            firstDecimals: 1,
            secondTitle: 'Power (W)',
            secondSpots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsPowerW),
            ),
            secondDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'CMJ Free Hands Height Comparison',
          latestValue: latestFreeHandsHeight,
          previousValue: previousFreeHandsHeight,
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'CMJ Free Hands Power Comparison',
          latestValue: latestFreeHandsPower,
          previousValue: previousFreeHandsPower,
          unit: ' W',
          decimals: 0,
          icon: Icons.bolt,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Drop Jump Height',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.dropJumpHeightCm),
            ),
            labels: labels,
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Drop Jump Height Comparison',
          latestValue: latestDropHeight,
          previousValue: previousDropHeight,
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Drop Jump RSI',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.dropJumpRsi),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Drop Jump RSI Comparison',
          latestValue: latestRsi,
          previousValue: previousRsi,
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Single Leg CMJ Height Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map((e) => numToDouble(e.jumpingAbility?.singleLegCmjRightHeightCm) ?? 0)
                .toList(),
            secondValues: items
                .map((e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftHeightCm) ?? 0)
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Single Leg CMJ Height Right Comparison',
          latestValue: latestSingleLegHeightRight,
          previousValue: previousSingleLegHeightRight,
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Single Leg CMJ Height Left Comparison',
          latestValue: latestSingleLegHeightLeft,
          previousValue: previousSingleLegHeightLeft,
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Single Leg CMJ Power Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map((e) => numToDouble(e.jumpingAbility?.singleLegCmjRightPowerW) ?? 0)
                .toList(),
            secondValues: items
                .map((e) => numToDouble(e.jumpingAbility?.singleLegCmjLeftPowerW) ?? 0)
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Single Leg CMJ Power Right Comparison',
          latestValue: latestSingleLegPowerRight,
          previousValue: previousSingleLegPowerRight,
          unit: ' W',
          decimals: 0,
          icon: Icons.bolt,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Single Leg CMJ Power Left Comparison',
          latestValue: latestSingleLegPowerLeft,
          previousValue: previousSingleLegPowerLeft,
          unit: ' W',
          decimals: 0,
          icon: Icons.bolt,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Elastic Util Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.elasticUtilRatio),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Elastic Util Ratio Comparison',
          latestValue: latestElasticUtilRatio,
          previousValue: previousElasticUtilRatio,
          unit: '',
          decimals: 2,
          icon: Icons.show_chart,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Arm Swing',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.armSwing),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Arm Swing Comparison',
          latestValue: latestArmSwing,
          previousValue: previousArmSwing,
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Biliteral Deficit',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.biliteralDeficit),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Biliteral Deficit Comparison',
          latestValue: latestBiliteralDeficit,
          previousValue: previousBiliteralDeficit,
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Single Leg Jump',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.singleLegJump),
            ),
            labels: labels,
            yDecimals: 2,
          ),
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Single Leg Jump Comparison',
          latestValue: latestSingleLegJump,
          previousValue: previousSingleLegJump,
          unit: '',
          decimals: 2,
          icon: Icons.show_chart,
        ),
      ],
    );
  }
}

class _JumpingMetricPairChart extends StatelessWidget {
  final List<String> labels;
  final String firstTitle;
  final List<FlSpot> firstSpots;
  final int firstDecimals;
  final String secondTitle;
  final List<FlSpot> secondSpots;
  final int secondDecimals;

  const _JumpingMetricPairChart({
    required this.labels,
    required this.firstTitle,
    required this.firstSpots,
    required this.firstDecimals,
    required this.secondTitle,
    required this.secondSpots,
    required this.secondDecimals,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PairChartLabel(title: firstTitle),
        const SizedBox(height: 8),
        Expanded(
          child: SimpleLineChart(
            spots: firstSpots,
            labels: labels,
            yDecimals: firstDecimals,
          ),
        ),
        const SizedBox(height: 16),
        _PairChartLabel(title: secondTitle),
        const SizedBox(height: 8),
        Expanded(
          child: SimpleLineChart(
            spots: secondSpots,
            labels: labels,
            yDecimals: secondDecimals,
          ),
        ),
      ],
    );
  }
}

class _PairChartLabel extends StatelessWidget {
  final String title;

  const _PairChartLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
