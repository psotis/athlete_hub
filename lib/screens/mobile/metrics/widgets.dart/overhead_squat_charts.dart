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
    final latestNegative = latest != null ? negativeCount(latest) : null;
    final previousNegative = items.length >= 2
        ? negativeCount(items[items.length - 2])
        : null;
    final latestTotal = latest != null ? totalCount(latest) : null;
    final previousTotal = items.length >= 2
        ? totalCount(items[items.length - 2])
        : null;

    return ChartSection(
      title: 'Overhead Squat',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
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
        MetricDeltaCard(
          title: 'Positive Results Comparison',
          latestValue: latestPositive,
          previousValue: previousPositive,
          unit: '',
          decimals: 0,
          icon: Icons.check_circle_outline,
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
        MetricDeltaCard(
          title: 'Negative Results Comparison',
          latestValue: latestNegative,
          previousValue: previousNegative,
          unit: '',
          decimals: 0,
          lowerIsBetter: true,
          icon: Icons.cancel_outlined,
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
        const SizedBox(height: 12),
        MetricDeltaCard(
          title: 'Total Items Comparison',
          latestValue: latestTotal,
          previousValue: previousTotal,
          unit: '',
          decimals: 0,
          icon: Icons.format_list_numbered,
        ),
      ],
    );
  }
}
