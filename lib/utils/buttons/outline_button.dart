import 'package:athlete_hub/helpers/imports.dart';

class IotOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final double borderRadius;
  final double fontSize;
  final Color? borderColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final double borderWidth;

  const IotOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.borderRadius = 12.0,
    this.fontSize = 16.0,
    this.borderColor,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextColor = textColor ?? theme.colorScheme.primary;
    final effectiveBorderColor = borderColor ?? theme.colorScheme.primary;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: effectiveBorderColor, width: borderWidth),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      child: icon == null
          ? Text(
              text,
              style: TextStyle(fontSize: fontSize, color: effectiveTextColor),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: effectiveTextColor, size: fontSize + 2),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: effectiveTextColor,
                  ),
                ),
              ],
            ),
    );
  }
}
