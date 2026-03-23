import 'package:athlete_hub/helpers/imports.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ResponsiveLayout(mobile: HomeMobile(), desktop: HomeDesktop()),
    );
  }
}
