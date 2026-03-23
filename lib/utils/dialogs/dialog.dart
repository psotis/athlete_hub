import 'package:athlete_hub/helpers/imports.dart';

class IotDialog {
  IotDialog._();

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    String? confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    Color? backgroundColor,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    IconData? icon,
    double borderRadius = 12,
    double fontSize = 16.0,
    Color? borderColor,
    Color? textColor,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    ),
    double borderWidth = 1.5,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(title, style: titleTextStyle),
        content: content,
        actions: [
          if (cancelText != null)
            IotOutlinedButton(
              borderColor: borderColor,
              borderRadius: borderRadius,
              borderWidth: borderWidth,
              padding: padding,
              textColor: textColor,
              icon: icon,
              fontSize: fontSize,
              onPressed: () {
                if (onCancel != null) onCancel();
                Navigator.of(context).pop();
              },
              text: cancelText,
            ),
          if (confirmText != null)
            IotOutlinedButton(
              borderColor: borderColor,
              borderRadius: borderRadius,
              borderWidth: borderWidth,
              padding: padding,
              textColor: textColor,
              icon: icon,
              fontSize: fontSize,
              onPressed: () {
                if (onConfirm != null) onConfirm();
                Navigator.of(context).pop();
              },
              text: confirmText,
            ),
        ],
      ),
    );
  }
}
