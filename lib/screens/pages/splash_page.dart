import 'package:athlete_hub/helpers/imports.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: SplashMobile(), desktop: SplashDesktop());
  }
}
