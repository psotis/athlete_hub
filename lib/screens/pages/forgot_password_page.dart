import 'package:athlete_hub/helpers/imports.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  var _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false) || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      await context.read<AuthRepository>().forgotPassword(
        email: _emailCtrl.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('If this email exists, a reset link has been sent.'),
        ),
      );
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
      eyebrow: 'Password reset',
      title: 'Get a secure link and set a new password.',
      subtitle:
          'Enter your Athlete Hub email and we will send you a reset link.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IotTextFormField(
              controller: _emailCtrl,
              hintText: 'E-mail',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              prefixIcon: const Icon(Icons.mail_outline),
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Enter your e-mail';
                if (!text.contains('@')) return 'Enter a valid e-mail';
                return null;
              },
            ),
            const SizedBox(height: 18),
            IotButton(
              text: 'Send reset link',
              onPressed: _submit,
              isLoading: _isLoading,
              height: 54,
              borderRadius: 16,
              icon: const Icon(Icons.mark_email_read_outlined, size: 20),
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
