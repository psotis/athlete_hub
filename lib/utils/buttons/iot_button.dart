import 'package:flutter/material.dart';

class IotButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isLoading;
  final Color? backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double? width;
  final double? height;
  final Widget? icon;
  final TextStyle? textStyle;
  final double elevation;
  final Color borderColor;
  final double borderWidth;

  const IotButton({
    super.key,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.width,
    this.height,
    this.icon,
    this.textStyle,
    this.elevation = 1.0,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        onLongPress: isLoading ? null : onLongPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: elevation,
          padding: padding,
          animationDuration: Duration(milliseconds: 200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor, width: borderWidth),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (icon != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: icon,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: textStyle ?? TextStyle(color: textColor),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
