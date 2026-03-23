import 'package:athlete_hub/helpers/imports.dart';

class EnduranceCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const EnduranceCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;

    return ChartSection(
      title: 'Endurance',
      children: [
        ChartCard(
          title: 'Beep Test Level',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.endurance?.beepTestLevel),
            ),
            labels: labels,
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
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'HR Max',
          chart: SimpleLineChart(
            spots: items.lineSpots((e) => numToDouble(e.endurance?.hrMax)),
            labels: labels,
          ),
        ),
      ],
    );
  }
}
