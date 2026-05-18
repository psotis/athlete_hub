import 'package:athlete_hub/helpers/imports.dart';

class ProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const ProfileField({
    super.key,
    required this.controller,
    required this.label,
    required this.enabled,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withAlpha(184)),
        filled: true,
        fillColor: Colors.white.withAlpha(enabled ? 20 : 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withAlpha(26)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withAlpha(20)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0xFF7DEBFF)),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0xFFEF4444)),
        ),
      ),
    );
  }
}
