import 'package:athlete_hub/helpers/imports.dart';

class ChartSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ChartSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}
