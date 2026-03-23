import 'package:athlete_hub/helpers/imports.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: ProfileMobile(), desktop: ProfileDesktop());
  }
}
