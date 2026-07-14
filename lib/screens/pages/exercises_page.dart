import 'package:athlete_hub/helpers/imports.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) => const ResponsiveLayout(
        mobile: ExercisesMobile(),
        desktop: ExercisesDesktop(),
      );
}
