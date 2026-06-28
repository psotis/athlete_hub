import 'package:athlete_hub/helpers/imports.dart';

class IotDropdown2<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String Function(T)? itemAsString;
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
  final bool enableSearch;
  final String? searchHintText;
  final double? searchInnerWidgetHeight;

  const IotDropdown2({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.itemAsString,
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
    this.enableSearch = false,
    this.searchHintText,
    this.searchInnerWidgetHeight = 60,
  });

  @override
  State<IotDropdown2<T>> createState() => _IotDropdown2State<T>();
}

class _IotDropdown2State<T> extends State<IotDropdown2<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        items: widget.items,
        value: widget.value,
        onChanged: widget.onChanged,
        isExpanded: widget.isExpanded,
        style:
            widget.itemStyle ?? const TextStyle(color: Color(0xFF0F172A)),
        hint: widget.hintText != null
            ? Text(
                widget.hintText!,
                style:
                    widget.hintStyle ??
                    const TextStyle(color: Color(0xFF64748B)),
              )
            : null,
        buttonStyleData: ButtonStyleData(
          height: widget.buttonHeight,
          width: widget.buttonWidth,
          padding: widget.buttonPadding,
          decoration:
              widget.buttonDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.white,
              ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: widget.dropdownMaxHeight,
          width: widget.dropdownWidth ?? widget.buttonWidth,
          decoration:
              widget.dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
          elevation: 8,
          scrollbarTheme: ScrollbarThemeData(
            thumbVisibility: WidgetStateProperty.all(
              widget.scrollbarAlwaysShow,
            ),
            radius: widget.scrollbarRadius,
            thickness: WidgetStateProperty.all(widget.scrollbarThickness),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: widget.icon ?? const Icon(Icons.arrow_drop_down),
          iconSize: widget.iconSize!,
          iconEnabledColor: widget.iconEnabledColor,
          iconDisabledColor: widget.iconDisabledColor,
        ),
        menuItemStyleData: MenuItemStyleData(
          selectedMenuItemBuilder: (context, child) => child,
        ),

        dropdownSearchData: widget.enableSearch
            ? DropdownSearchData(
                searchController: _searchController,
                searchInnerWidgetHeight: widget.searchInnerWidgetHeight,
                searchInnerWidget: Container(
                  height: widget.searchInnerWidgetHeight,
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _searchController,
                    expands: true,
                    maxLines: null,
                    style: const TextStyle(color: Color(0xFF0F172A)),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: widget.searchHintText ?? 'Search...',
                      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF0F172A),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  final text = item.value == null
                      ? ''
                      : (widget.itemAsString?.call(item.value as T) ??
                            item.value.toString());

                  return text.toLowerCase().contains(searchValue.toLowerCase());
                },
              )
            : null,

        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            _searchController.clear();
          }
        },
      ),
    );
  }
}
