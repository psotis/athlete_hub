import 'package:athlete_hub/helpers/imports.dart';

class IotDropdown2<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String? hintText;
  final double? buttonHeight;
  final double? buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final TextStyle? hintStyle;
  final TextStyle? itemStyle;
  final double? dropdownMaxHeight;
  final double? dropdownWidth;
  final BoxDecoration? dropdownDecoration;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final bool isExpanded;
  final bool scrollbarAlwaysShow;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;

  const IotDropdown2({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.hintText,
    this.buttonHeight = 48,
    this.buttonWidth,
    this.buttonPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.buttonDecoration,
    this.hintStyle,
    this.itemStyle,
    this.dropdownMaxHeight = 200,
    this.dropdownWidth,
    this.dropdownDecoration,
    this.icon,
    this.iconSize = 24,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.isExpanded = true,
    this.scrollbarAlwaysShow = false,
    this.scrollbarRadius,
    this.scrollbarThickness,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        items: items,
        value: value,
        onChanged: onChanged,
        isExpanded: isExpanded,
        hint: hintText != null
            ? Text(
                hintText!,
                style:
                    hintStyle ?? TextStyle(color: Theme.of(context).hintColor),
              )
            : null,
        buttonStyleData: ButtonStyleData(
          height: buttonHeight,
          width: buttonWidth,
          padding: buttonPadding,
          decoration:
              buttonDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.white,
              ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: dropdownMaxHeight,
          width: dropdownWidth ?? buttonWidth,
          decoration:
              dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
          elevation: 8,
          scrollbarTheme: ScrollbarThemeData(
            thumbVisibility: WidgetStateProperty.all(scrollbarAlwaysShow),
            radius: scrollbarRadius,
            thickness: WidgetStateProperty.all(scrollbarThickness),
          ),
        ),

        iconStyleData: IconStyleData(
          icon: icon ?? const Icon(Icons.arrow_drop_down),
          iconSize: iconSize!,
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconDisabledColor,
        ),
        menuItemStyleData: MenuItemStyleData(
          selectedMenuItemBuilder: (context, child) => child,
        ),

        // customItemsHeights: List.generate(items.length, (_) => null),
      ),
    );
  }
}
