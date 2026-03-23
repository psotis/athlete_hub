import 'package:athlete_hub/helpers/imports.dart';

class JumpingCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const JumpingCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    final latestCmj = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.cmjHeightCm),
    );
    final previousCmj = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.cmjHeightCm),
    );

    final latestSquatJump = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.squatJumpHeightCm),
    );
    final previousSquatJump = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.squatJumpHeightCm),
    );

    final latestRsi = latestMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.dropJumpRsi),
    );
    final previousRsi = previousMetricValue(
      items,
      (e) => numToDouble(e.jumpingAbility?.dropJumpRsi),
    );

    return ChartSection(
      title: 'Jumping Ability',
      children: [
        SummaryStatCard(
          title: 'Latest CMJ Height',
          value:
              '${numToDouble(latest?.jumpingAbility?.cmjHeightCm)?.toStringAsFixed(1) ?? '-'} cm',
          subtitle: latest?.session?.measurementDate != null
              ? _formatDate(latest!.session!.measurementDate!)
              : null,
          icon: Icons.arrow_upward,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'CMJ Height Change',
          latestValue: latestCmj,
          previousValue: previousCmj,
          unit: ' cm',
          decimals: 1,
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Squat Jump Height Change',
          latestValue: latestSquatJump,
          previousValue: previousSquatJump,
          unit: ' cm',
          decimals: 1,
          icon: Icons.height,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Drop Jump RSI Change',
          latestValue: latestRsi,
          previousValue: previousRsi,
          unit: '',
          decimals: 2,
          icon: Icons.compare_arrows,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'CMJ Height Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.cmjHeightCm),
            ),
            labels: labels,
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'CMJ Power Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.cmjPowerW),
            ),
            labels: labels,
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Squat Jump Height Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.squatJumpHeightCm),
            ),
            labels: labels,
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Squat Jump Power Trend',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.squatJumpPowerW),
            ),
            labels: labels,
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'CMJ Free Hands Height',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsHeightCm),
            ),
            labels: labels,
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'CMJ Free Hands Power',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.jumpingAbility?.cmjFreeHandsPowerW),
            ),
            labels: labels,
            yDecimals: 0,
          ),
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
        ChartCard(
          title: 'Single Leg CMJ Height Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) =>
                      numToDouble(
                        e.jumpingAbility?.singleLegCmjRightHeightCm,
                      ) ??
                      0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) =>
                      numToDouble(e.jumpingAbility?.singleLegCmjLeftHeightCm) ??
                      0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 1,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Single Leg CMJ Power Right vs Left',
          chart: GroupedBarChart(
            labels: labels,
            firstValues: items
                .map(
                  (e) =>
                      numToDouble(e.jumpingAbility?.singleLegCmjRightPowerW) ??
                      0,
                )
                .toList(),
            secondValues: items
                .map(
                  (e) =>
                      numToDouble(e.jumpingAbility?.singleLegCmjLeftPowerW) ??
                      0,
                )
                .toList(),
            firstLegend: 'Right',
            secondLegend: 'Left',
            yDecimals: 0,
          ),
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
      ],
    );
  }
}

String _formatDate(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.day.toString().padLeft(2, '0')}";
}
