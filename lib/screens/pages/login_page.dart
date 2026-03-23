import 'package:athlete_hub/helpers/imports.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ResponsiveLayout(mobile: LoginMobile(), desktop: LoginDesktop()),
    );
  }
}
