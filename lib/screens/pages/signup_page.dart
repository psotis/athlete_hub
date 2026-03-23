import 'package:athlete_hub/helpers/imports.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: SignupMobile(), desktop: SignupDesktop());
  }
}
