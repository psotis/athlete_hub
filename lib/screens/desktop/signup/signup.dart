import 'package:athlete_hub/helpers/imports.dart';

class SignupDesktop extends StatefulWidget {
  const SignupDesktop({super.key});

  @override
  State<SignupDesktop> createState() => _SignupDesktopState();
}

class _SignupDesktopState extends State<SignupDesktop> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signup is not connected yet. Please contact admin.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      maxWidth: 560,
      eyebrow: 'Get Started',
      title: 'Build your athlete workspace with Athlete Hub.',
      subtitle:
          'Create an account to organize performance data, health records and day-to-day progress.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: IotTextFormField(
                    controller: _nameCtrl,
                    hintText: 'Full name',
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) return 'Enter your name';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: IotTextFormField(
                    controller: _emailCtrl,
                    hintText: 'E-mail',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.mail_outline),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Enter your e-mail';
                      if (!text.contains('@')) return 'Enter a valid e-mail';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: IotTextFormField(
                    controller: _passCtrl,
                    hintText: 'Password',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (value) {
                      if ((value ?? '').length < 6) {
                        return 'Use at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: IotTextFormField(
                    controller: _confirmCtrl,
                    hintText: 'Confirm password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(Icons.verified_user_outlined),
                    onFieldSubmitted: (_) => _submit(),
                    validator: (value) {
                      if (value != _passCtrl.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: IotButton(
                    text: 'Create account',
                    onPressed: _submit,
                    height: 56,
                    borderRadius: 16,
                    icon: const Icon(Icons.person_add_alt_1, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: IotOutlinedButton(
                    text: 'Back to login',
                    onPressed: () => context.pop(),
                    borderRadius: 16,
                    fontSize: 16,
                    icon: Icons.arrow_back_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
