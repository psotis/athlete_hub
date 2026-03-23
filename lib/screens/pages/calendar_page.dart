import 'package:athlete_hub/helpers/imports.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: CalendarMobile(),
      desktop: CalendarDesktop(),
    );
  }
}
