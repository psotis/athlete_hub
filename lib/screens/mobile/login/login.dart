import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
      AuthLoggedIn(_emailCtrl.text.trim(), _passCtrl.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading || state is AuthChecking;

        return AuthShell(
          eyebrow: 'Welcome Back',
          title: 'Train smarter with your data close by.',
          subtitle:
              'Log in to review athlete progress, health history and performance metrics.',
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IotTextFormField(
                  controller: _emailCtrl,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  prefixIcon: const Icon(Icons.mail_outline),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Enter your e-mail';
                    if (!text.contains('@')) return 'Enter a valid e-mail';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                IotTextFormField(
                  controller: _passCtrl,
                  hintText: 'Password',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  prefixIcon: const Icon(Icons.lock_outline),
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) {
                    if ((value ?? '').isEmpty) return 'Enter your password';
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                IotButton(
                  text: 'Login',
                  onPressed: _submit,
                  isLoading: isLoading,
                  height: 54,
                  borderRadius: 16,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                ),
                const SizedBox(height: 12),
                IotOutlinedButton(
                  text: 'Create account',
                  onPressed: () => context.push(Routes.signup),
                  borderRadius: 16,
                  fontSize: 16,
                  icon: Icons.person_add_alt_1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
