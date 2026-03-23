import 'package:athlete_hub/helpers/imports.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: DashboardMobile(),
      desktop: DashboardDesktop(),
    );
  }
}
