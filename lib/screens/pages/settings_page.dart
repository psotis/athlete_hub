import 'package:athlete_hub/helpers/imports.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: SettingsMobile(),
      desktop: SettingsDesktop(),
    );
  }
}
