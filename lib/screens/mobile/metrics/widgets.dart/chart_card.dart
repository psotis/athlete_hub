import 'package:athlete_hub/helpers/imports.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final double height;
  final Widget? trailing;

  const ChartCard({
    super.key,
    required this.title,
    required this.chart,
    this.height = 320,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(height: height, child: chart),
          ],
        ),
      ),
    );
  }
}

class SummaryStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;

  const SummaryStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 28),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Text(value, style: Theme.of(context).textTheme.headlineSmall),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SparklineCard extends StatelessWidget {
  final String title;
  final String value;
  final List<FlSpot> spots;
  final double height;

  const SparklineCard({
    super.key,
    required this.title,
    required this.value,
    required this.spots,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SizedBox(
              height: height,
              child: spots.isEmpty
                  ? const Center(child: Text('No data'))
                  : LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: (spots.length - 1).toDouble(),
                        minY: 0,
                        maxY: _paddedMaxFromSpots(spots),
                        titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> labels;
  final String bottomTitlePrefix;
  final int yDecimals;
  final bool showDots;

  const SimpleLineChart({
    super.key,
    required this.spots,
    required this.labels,
    this.bottomTitlePrefix = '',
    this.yDecimals = 0,
    this.showDots = true,
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return const Center(child: Text('No data'));
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: 0,
        maxY: _paddedMaxFromSpots(spots),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(yDecimals),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              interval: labels.length > 6 ? 2 : 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= labels.length) {
                  return const SizedBox.shrink();
                }

                if (labels.length > 6 && index.isOdd) {
                  return const SizedBox.shrink();
                }

                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  angle: -0.6,
                  child: Text(
                    '$bottomTitlePrefix${labels[index]}',
                    style: const TextStyle(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            dotData: FlDotData(show: showDots),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final int yDecimals;

  const SimpleBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.yDecimals = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Center(child: Text('No data'));
    }

    return BarChart(
      BarChartData(
        minY: 0,
        maxY: _paddedMaxFromValues(values),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(yDecimals),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= labels.length) {
                  return const SizedBox.shrink();
                }

                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  angle: -0.6,
                  child: Text(
                    labels[index],
                    style: const TextStyle(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
        barGroups: List.generate(
          values.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: values[index],
                width: 18,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupedBarChart extends StatelessWidget {
  final List<String> labels;
  final List<double> firstValues;
  final List<double> secondValues;
  final String firstLegend;
  final String secondLegend;
  final int yDecimals;

  const GroupedBarChart({
    super.key,
    required this.labels,
    required this.firstValues,
    required this.secondValues,
    required this.firstLegend,
    required this.secondLegend,
    this.yDecimals = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty || firstValues.isEmpty || secondValues.isEmpty) {
      return const Center(child: Text('No data'));
    }

    final maxY = _paddedMaxFromValues([...firstValues, ...secondValues]);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(label: firstLegend),
            const SizedBox(width: 16),
            _LegendDot(label: secondLegend),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: maxY,
              groupsSpace: 12,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(yDecimals),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= labels.length) {
                        return const SizedBox.shrink();
                      }

                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        angle: -0.6,
                        child: Text(
                          labels[index],
                          style: const TextStyle(fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: true),
              barGroups: List.generate(
                labels.length,
                (index) => BarChartGroupData(
                  x: index,
                  barsSpace: 6,
                  barRods: [
                    BarChartRodData(
                      toY: index < firstValues.length ? firstValues[index] : 0,
                      width: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: index < secondValues.length
                          ? secondValues[index]
                          : 0,
                      width: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MetricDeltaCard extends StatelessWidget {
  final String title;
  final double? latestValue;
  final double? previousValue;
  final String unit;
  final int decimals;
  final bool lowerIsBetter;
  final IconData? icon;

  const MetricDeltaCard({
    super.key,
    required this.title,
    required this.latestValue,
    required this.previousValue,
    this.unit = '',
    this.decimals = 1,
    this.lowerIsBetter = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final latestText = latestValue != null
        ? '${latestValue!.toStringAsFixed(decimals)}$unit'
        : '-';

    final previousText = previousValue != null
        ? '${previousValue!.toStringAsFixed(decimals)}$unit'
        : '-';

    final delta = (latestValue != null && previousValue != null)
        ? latestValue! - previousValue!
        : null;

    final deltaText = delta == null
        ? '-'
        : '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(decimals)}$unit';

    final isImproved = delta == null
        ? null
        : lowerIsBetter
        ? delta < 0
        : delta > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 28),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _MetricMiniInfo(label: 'Latest', value: latestText),
                      _MetricMiniInfo(label: 'Previous', value: previousText),
                      _MetricMiniInfo(
                        label: 'Delta',
                        value: deltaText,
                        icon: isImproved == null
                            ? null
                            : isImproved
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricMiniInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _MetricMiniInfo({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14),
              const SizedBox(width: 4),
            ],
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final String label;

  const _LegendDot({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(radius: 4),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

double _paddedMaxFromSpots(List<FlSpot> spots) {
  final maxYValue = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
  return maxYValue == 0 ? 10.0 : maxYValue * 1.15;
}

double _paddedMaxFromValues(List<double> values) {
  final maxYValue = values.reduce((a, b) => a > b ? a : b);
  return maxYValue == 0 ? 10.0 : maxYValue * 1.15;
}

double? latestMetricValue(
  List<ErgometricsDetails> items,
  double? Function(ErgometricsDetails item) selector,
) {
  for (int i = items.length - 1; i >= 0; i--) {
    final value = selector(items[i]);
    if (value != null) return value;
  }
  return null;
}

double? previousMetricValue(
  List<ErgometricsDetails> items,
  double? Function(ErgometricsDetails item) selector,
) {
  bool foundLatest = false;

  for (int i = items.length - 1; i >= 0; i--) {
    final value = selector(items[i]);
    if (value == null) continue;

    if (!foundLatest) {
      foundLatest = true;
      continue;
    }

    return value;
  }

  return null;
}
