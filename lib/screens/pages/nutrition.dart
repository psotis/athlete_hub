import 'package:athlete_hub/helpers/imports.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: NutritionMobile(),
      desktop: NutritionDesktop(),
    );
  }
}
