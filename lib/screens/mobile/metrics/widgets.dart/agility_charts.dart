import 'package:athlete_hub/helpers/imports.dart';

class AgilityCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const AgilityCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;

    return ChartSection(
      title: 'Agility & Speed',
      children: [
        ChartCard(
          title: '5-10-5 Right (sec)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.agilitySpeed?.test5105RightSec),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: '5-10-5 Left (sec)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.agilitySpeed?.test5105LeftSec),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Sprint 0-10 (sec)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.agilitySpeed?.sprint010Sec),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Sprint 0-20 (sec)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.agilitySpeed?.sprint020Sec),
            ),
            labels: labels,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Sprint 0-30 (sec)',
          chart: SimpleLineChart(
            spots: items.lineSpots(
              (e) => numToDouble(e.agilitySpeed?.sprint030Sec),
            ),
            labels: labels,
          ),
        ),
      ],
    );
  }
}
