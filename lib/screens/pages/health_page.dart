import 'package:athlete_hub/helpers/imports.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: HealthMobile(), desktop: HealthDesktop());
  }
}
