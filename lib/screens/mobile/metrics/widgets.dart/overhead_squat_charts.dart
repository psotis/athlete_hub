import 'package:athlete_hub/helpers/imports.dart';

class OverheadSquatCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const OverheadSquatCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.map((e) {
      final date = e.session?.measurementDate;
      return date?.toString() ?? '-';
    }).toList();

    final totalValues = items.map((e) {
      return e.overheadSquatAssessmentItems.length.toDouble();
    }).toList();

    final positiveValues = items.map((e) {
      return e.overheadSquatAssessmentItems
          .where((item) => item.result == true)
          .length
          .toDouble();
    }).toList();

    final negativeValues = items.map((e) {
      return e.overheadSquatAssessmentItems
          .where((item) => item.result == false)
          .length
          .toDouble();
    }).toList();

    return ChartSection(
      title: 'Overhead Squat',
      children: [
        ChartCard(
          title: 'Total Assessment Items',
          chart: SimpleBarChart(values: totalValues, labels: labels),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Positive Results',
          chart: SimpleBarChart(values: positiveValues, labels: labels),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Negative Results',
          chart: SimpleBarChart(values: negativeValues, labels: labels),
        ),
      ],
    );
  }
}
