import 'package:athlete_hub/helpers/imports.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;

  const ResetPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  var _isLoading = false;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reset link is missing the token.')),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false) || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      await context.read<AuthRepository>().resetPassword(
        token: widget.token,
        password: _passwordCtrl.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed. You can log in now.')),
      );
      context.go(Routes.login);
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < DeviceSizes.mobileSize;

    return AuthShell(
      maxWidth: isMobile ? 430 : 520,
      eyebrow: 'New password',
      title: 'Choose a new password for your account.',
      subtitle: 'Your new password must have at least 8 characters.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IotTextFormField(
              controller: _passwordCtrl,
              hintText: 'New password',
              obscureText: true,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              prefixIcon: const Icon(Icons.lock_outline),
              validator: (value) {
                if ((value ?? '').length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            IotTextFormField(
              controller: _confirmCtrl,
              hintText: 'Confirm password',
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              prefixIcon: const Icon(Icons.lock_reset_rounded),
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                if ((value ?? '').isEmpty) return 'Confirm your password';
                if (value != _passwordCtrl.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            IotButton(
              text: 'Reset password',
              onPressed: _submit,
              isLoading: _isLoading,
              height: 54,
              borderRadius: 16,
              icon: const Icon(Icons.check_rounded, size: 20),
            ),
            const SizedBox(height: 12),
            IotOutlinedButton(
              text: 'Back to login',
              onPressed: () => context.go(Routes.login),
              borderRadius: 16,
              fontSize: 16,
              icon: Icons.arrow_back_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
