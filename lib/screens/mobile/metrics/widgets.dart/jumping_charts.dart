import 'package:athlete_hub/helpers/imports.dart';

class JumpingCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const JumpingCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;

    return ChartSection(
      title: 'Jumping Ability',
      children: [
        ChartCard(
          title: 'Squat Jump Height (cm)',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.squatJumpHeightCm),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Squat Jump Power (W)',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.squatJumpPowerW),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'CMJ Height (cm)',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.cmjHeightCm),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'CMJ Power (W)',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.cmjPowerW),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'CMJ Free Hands Height (cm)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => e.jumpingAbility?.cmjFreeHandsHeightCm,
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'CMJ Free Hands Power (W)',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.cmjFreeHandsPowerW),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Drop Jump Height (cm)',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.dropJumpHeightCm),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Drop Jump RSI',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.dropJumpRsi),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Elastic Util Ratio',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.elasticUtilRatio),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Arm Swing',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.armSwing),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Biliteral Deficit',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.biliteralDeficit),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Single Leg Jump',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => e.jumpingAbility?.singleLegJump),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Single Leg CMJ Right Height (cm)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => e.jumpingAbility?.singleLegCmjRightHeightCm,
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Single Leg CMJ Right Power (W)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => e.jumpingAbility?.singleLegCmjRightPowerW,
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Single Leg CMJ Left Height (cm)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => e.jumpingAbility?.singleLegCmjLeftHeightCm,
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Single Leg CMJ Left Power (W)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => e.jumpingAbility?.singleLegCmjLeftPowerW,
            ),
            labels: labels,
          ),
        ),
      ],
    );
  }
}
