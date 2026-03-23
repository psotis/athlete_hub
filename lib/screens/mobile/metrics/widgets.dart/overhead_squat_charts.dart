import 'package:athlete_hub/helpers/imports.dart';

class OverheadSquatCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const OverheadSquatCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final labels = items.sessionLabels;
    final latest = items.isNotEmpty ? items.last : null;

    double positiveCount(ErgometricsDetails e) => e.overheadSquatAssessmentItems
        .where((item) => item.result == true)
        .length
        .toDouble();

    double negativeCount(ErgometricsDetails e) => e.overheadSquatAssessmentItems
        .where((item) => item.result == false)
        .length
        .toDouble();

    double totalCount(ErgometricsDetails e) =>
        e.overheadSquatAssessmentItems.length.toDouble();

    final latestPositive = latest != null ? positiveCount(latest) : null;
    final previousPositive = items.length >= 2
        ? positiveCount(items[items.length - 2])
        : null;

    return ChartSection(
      title: 'Overhead Squat',
      children: [
        SummaryStatCard(
          title: 'Latest Positive Results',
          value: latestPositive?.toStringAsFixed(0) ?? '-',
          subtitle: latest?.session?.measurementDate != null
              ? _formatDate(latest!.session!.measurementDate!)
              : null,
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Positive Results Change',
          latestValue: latestPositive,
          previousValue: previousPositive,
          unit: '',
          decimals: 0,
          icon: Icons.compare_arrows,
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Positive Results',
          chart: SimpleBarChart(
            values: items.map(positiveCount).toList(),
            labels: labels,
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Negative Results',
          chart: SimpleBarChart(
            values: items.map(negativeCount).toList(),
            labels: labels,
            yDecimals: 0,
          ),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: 'Total Assessment Items',
          chart: SimpleBarChart(
            values: items.map(totalCount).toList(),
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
