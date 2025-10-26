import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/presentation/widgets/custom_number_picker.dart';
import 'package:vienna_airport_taxi/presentation/widgets/custom_list_picker.dart';

class DropdownFieldWithSvgIcon extends StatefulWidget {
  final String svgIconPath;
  final String hintText;
  final String? value;
  final List<String> items;
  final void Function(String) onChanged;
  final String? errorText;

  const DropdownFieldWithSvgIcon({
    super.key,
    required this.svgIconPath,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<DropdownFieldWithSvgIcon> createState() =>
      _DropdownFieldWithSvgIconState();
}

class _DropdownFieldWithSvgIconState extends State<DropdownFieldWithSvgIcon> {
  void _showModalBottomSheet() {

    // Determine if this is a number picker (Personen, Koffer) or list picker
    // Use SVG icon path instead of text to support multiple languages
    final isNumberPicker =
        widget.svgIconPath == 'assets/icons/inputs/people.svg' ||
            widget.svgIconPath == 'assets/icons/inputs/luggage.svg';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        if (isNumberPicker) {
          return CustomNumberPicker(
            title: widget.hintText,
            svgIconPath: widget.svgIconPath,
            items: widget.items,
            selectedValue: widget.value,
            onChanged: widget.onChanged,
          );
        } else {
          return CustomListPicker(
            title: widget.hintText,
            svgIconPath: widget.svgIconPath,
            items: widget.items,
            selectedValue: widget.value,
            onChanged: widget.onChanged,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main dropdown container (same styling as inputs)
        GestureDetector(
          onTap: () {
            _showModalBottomSheet();
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: widget.errorText != null
                    ? AppColors.error
                    : const Color(0xFFCCCCCC),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Container(
                  height: 48,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.value ?? widget.hintText,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: widget.value != null
                          ? AppColors.textPrimary
                          : AppColors.textLight,
                    ),
                  ),
                ),

                // Icon positioned exactly like other input fields
                Positioned(
                  left: 12,
                  top: 14,
                  child: SvgPicture.asset(
                    widget.svgIconPath,
                    width: 18,
                    height: 18,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Error message
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
