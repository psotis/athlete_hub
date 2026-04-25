import 'package:athlete_hub/helpers/imports.dart';

class OverheadSquatCharts extends StatelessWidget {
  final List<ErgometricsDetails> items;

  const OverheadSquatCharts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    ErgometricsDetails? latest;
    for (final item in items.reversed) {
      if (item.overheadSquatAssessmentItems.isNotEmpty) {
        latest = item;
        break;
      }
    }

    final squatItems = latest?.overheadSquatAssessmentItems ?? const <Squat>[];
    final groupedItems = <String, List<Squat>>{};

    for (final item in squatItems) {
      final rawView = item.viewName?.trim();
      final view = rawView == null || rawView.isEmpty ? 'Unknown' : rawView;
      groupedItems.putIfAbsent(view, () => []).add(item);
    }

    return ChartSection(
      title: 'Movement Quality',
      children: [
        LatestMeasurementDateCard(date: latest?.session?.measurementDate),
        const SizedBox(height: 12),
        if (squatItems.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No movement quality assessment found'),
            ),
          )
        else
          Card(
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _OverheadTable.totalWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _OverheadHeaderRow(),
                    for (final entry in groupedItems.entries)
                      _OverheadViewSection(
                        viewName: entry.key,
                        items: entry.value,
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _OverheadTable {
  static const double viewWidth = 150;
  static const double checkpointWidth = 150;
  static const double compensationWidth = 230;
  static const double resultWidth = 90;
  static const double totalWidth =
      viewWidth + checkpointWidth + compensationWidth + resultWidth;
}

class _OverheadHeaderRow extends StatelessWidget {
  const _OverheadHeaderRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: const Row(
        children: [
          _HeaderCell(label: 'VIEW', width: _OverheadTable.viewWidth),
          _HeaderCell(
            label: 'CHECKPOINT',
            width: _OverheadTable.checkpointWidth,
          ),
          _HeaderCell(
            label: 'COMPENSATION',
            width: _OverheadTable.compensationWidth,
          ),
          _HeaderCell(
            label: 'RESULT',
            width: _OverheadTable.resultWidth,
            showRightBorder: false,
          ),
        ],
      ),
    );
  }
}

class _OverheadViewSection extends StatelessWidget {
  final String viewName;
  final List<Squat> items;

  const _OverheadViewSection({required this.viewName, required this.items});

  @override
  Widget build(BuildContext context) {
    final safeViewName = viewName.trim().isEmpty
        ? 'UNKNOWN'
        : viewName.toUpperCase();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: _OverheadTable.viewWidth,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(
                right: BorderSide(color: Colors.white24),
                bottom: BorderSide(color: Colors.white24),
              ),
            ),
            child: Text(
              safeViewName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 4,
              ),
            ),
          ),
          SizedBox(
            width: _OverheadTable.totalWidth - _OverheadTable.viewWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final item in items) _OverheadDataRow(item: item),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverheadDataRow extends StatelessWidget {
  final Squat item;

  const _OverheadDataRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPositive = item.result == true;
    final resultText = isPositive ? 'YES' : 'NO';
    final resultColor = isPositive
        ? Colors.green.shade700
        : Colors.red.shade700;
    final checkpoint = (item.checkpointName ?? '').trim();
    final compensation = (item.compensation ?? '').trim();

    return Row(
      children: [
        _DataCell(
          label: checkpoint.isEmpty ? '-' : checkpoint,
          width: _OverheadTable.checkpointWidth,
        ),
        _DataCell(
          label: compensation.isEmpty ? '-' : compensation,
          width: _OverheadTable.compensationWidth,
        ),
        Container(
          width: _OverheadTable.resultWidth,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.black12),
              bottom: BorderSide(color: Colors.black12),
            ),
          ),
          child: Text(
            resultText,
            textAlign: TextAlign.center,
            style: TextStyle(color: resultColor, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final double width;
  final bool showRightBorder;

  const _HeaderCell({
    required this.label,
    required this.width,
    this.showRightBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: showRightBorder
            ? const Border(right: BorderSide(color: Colors.white24))
            : null,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String label;
  final double width;

  const _DataCell({required this.label, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          left: BorderSide(color: Colors.white24),
          bottom: BorderSide(color: Colors.white24),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
