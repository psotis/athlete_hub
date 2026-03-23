import 'package:athlete_hub/helpers/imports.dart';

class SignupMobile extends StatelessWidget {
  const SignupMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
        ),
      ),
    );
  }
}
