// Create a new file: lib/presentation/widgets/custom_dropdown.dart
// This will be your professional dropdown widget

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';

class CustomDropdown extends StatefulWidget {
  final String svgIconPath;
  final String hintText;
  final String? value;
  final List<String> items;
  final Function(String) onChanged;
  final String? errorText;
  final bool enabled;

  const CustomDropdown({
    super.key,
    required this.svgIconPath,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isOpen = false;

  void _toggleDropdown() {
    if (!widget.enabled) return;

    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _isOpen = true;
    _showModalBottomSheet();
  }

  void _closeDropdown() {
    _isOpen = false;
  }

  void _showModalBottomSheet() {
    final localizations = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Modern minimal header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // SVG icon in black
                        SvgPicture.asset(
                          widget.svgIconPath,
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${widget.hintText} ${localizations.translate('select')}',
                          style: AppTextStyles.heading3.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    // Modern close button
                    Material(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.of(context).pop();
                          _closeDropdown();
                        },
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Modern options with special PLZ layout
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: widget.svgIconPath ==
                          'assets/icons/inputs/postal-code.svg'
                      ? _buildPLZGrid()
                      : _buildRegularList(),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Called when modal is dismissed
      _closeDropdown();
    });
  }

  Widget _buildPLZGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 8,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final isSelected = item == widget.value;

        // Split PLZ and district name for better layout
        final parts = item.split(' - ');
        final plz = parts[0];
        final district = parts.length > 1 ? parts[1] : '';

        return Material(
          color: isSelected ? AppColors.primaryLight : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              widget.onChanged(item);
              Navigator.of(context).pop();
              _closeDropdown();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plz,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.textPrimary
                                : Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (district.isNotEmpty)
                    Flexible(
                      child: Text(
                        district,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.textPrimary.withValues(alpha: 0.8)
                              : Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegularList() {
    return SingleChildScrollView(
      child: Column(
        children: widget.items.map((item) {
          final isSelected = item == widget.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: isSelected ? AppColors.primaryLight : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  widget.onChanged(item);
                  Navigator.of(context).pop();
                  _closeDropdown();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // border: Border.all(
                    //   color: isSelected
                    //       ? AppColors.textPrimary
                    //       : Colors.grey.shade300,
                    //   width: isSelected ? 1.5 : 1,
                    // ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? AppColors.textPrimary
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      // if (isSelected)
                      //   Container(
                      //     width: 20,
                      //     height: 20,
                      //     decoration: BoxDecoration(
                      //       color: AppColors.textPrimary,
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: const Icon(
                      //       Icons.check,
                      //       color: Colors.white,
                      //       size: 14,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main dropdown container (identical to your input fields)
        GestureDetector(
          onTap: _toggleDropdown,
          behavior: HitTestBehavior
              .opaque, // Ensure tap detection works in Expanded widgets
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

                // Icon positioned exactly like your input fields
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
