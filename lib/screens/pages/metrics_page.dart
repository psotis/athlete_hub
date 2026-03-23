import 'package:athlete_hub/helpers/imports.dart';

class MetricsPage extends StatelessWidget {
  const MetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: MetricsMobile(), desktop: MetricsDesktop());
  }
}
