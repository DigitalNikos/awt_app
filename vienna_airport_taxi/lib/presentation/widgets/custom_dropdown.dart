// Create a new file: lib/presentation/widgets/custom_dropdown.dart
// This will be your professional dropdown widget

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';

class CustomDropdown extends StatefulWidget {
  final String svgIconPath;
  final String hintText;
  final String? value;
  final List<String> items;
  final Function(String) onChanged;
  final String? errorText;
  final bool enabled;

  const CustomDropdown({
    Key? key,
    required this.svgIconPath,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _iconRotation;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _iconRotation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _closeDropdown();
    _animationController.dispose();
    super.dispose();
  }

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
    _animationController.forward();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
    _isOpen = false;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 4),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            child: AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scaleY: _expandAnimation.value,
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: _expandAnimation.value,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 200,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = item == widget.value;

                            return InkWell(
                              onTap: () {
                                widget.onChanged(item);
                                _closeDropdown();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withOpacity(0.1)
                                      : Colors.transparent,
                                  border: index < widget.items.length - 1
                                      ? Border(
                                          bottom: BorderSide(
                                            color: AppColors.primary
                                                .withOpacity(0.2),
                                            width: 1,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item,
                                        style:
                                            AppTextStyles.bodyMedium.copyWith(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textPrimary,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        color: AppColors.primary,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: Stack(
            children: [
              // Main dropdown container (identical to your input fields)
              GestureDetector(
                key: _dropdownKey,
                onTap: _toggleDropdown,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: widget.errorText != null
                          ? AppColors.error
                          : _isOpen
                              ? AppColors.primary
                              : const Color(0xFFCCCCCC),
                      width: _isOpen ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
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
                ),
              ),

              // Icon positioned exactly like your input fields
              Positioned(
                left: 12,
                top: 14,
                child: Container(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(
                    widget.svgIconPath,
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error message
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
