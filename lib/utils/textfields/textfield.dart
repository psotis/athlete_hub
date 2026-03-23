import 'package:athlete_hub/helpers/imports.dart';

class IotTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry padding;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool enableSuggestions;
  final bool autocorrect;
  final void Function(String)? onFieldSubmitted;
  final Color? cursorColor;
  final TextStyle? style;
  final Iterable<String>? autofillHints;
  final EdgeInsets scrollPadding;
  final double prefixIconConstraintHeight;
  final double prefixIconConstraintWidth;
  final TextAlign textAlign;

  const IotTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onSaved,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.contentPadding,
    this.padding = const EdgeInsets.all(8.0),
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
    this.readOnly = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.onFieldSubmitted,
    this.cursorColor,
    this.style,
    this.autofillHints,
    this.scrollPadding = const EdgeInsets.all(20),
    this.prefixIconConstraintHeight = 40,
    this.prefixIconConstraintWidth = 40,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        textAlign: textAlign,
        focusNode: focusNode,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
        enableSuggestions: enableSuggestions,
        autocorrect: autocorrect,
        onFieldSubmitted: onFieldSubmitted,
        cursorColor: cursorColor,
        style: style,
        autofillHints: autofillHints,
        scrollPadding: scrollPadding,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          prefixIconConstraints: BoxConstraints(
            minWidth: prefixIconConstraintHeight,
            minHeight: prefixIconConstraintWidth,
          ),
          suffixIcon: suffixIcon,
          border: border,
          focusedBorder: focusedBorder,
          enabledBorder: enabledBorder,
          contentPadding: contentPadding,
        ),
        maxLines: maxLines,
        maxLength: maxLength,
        enabled: enabled,
        obscureText: obscureText,
        textCapitalization: textCapitalization,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}
