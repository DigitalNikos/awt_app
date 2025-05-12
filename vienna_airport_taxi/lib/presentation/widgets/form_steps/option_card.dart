// lib/presentation/widgets/form_steps/option_card.dart

import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';

class OptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? indicator;
  final Function()? onTap;
  final bool isExpanded;
  final String? selectedValue;

  const OptionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.indicator,
    this.onTap,
    this.isExpanded = false,
    this.selectedValue,
  }) : super(key: key);

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Detect if device supports hover
    final bool supportsHover =
        Theme.of(context).platform == TargetPlatform.macOS ||
            Theme.of(context).platform == TargetPlatform.windows;

    return supportsHover
        ? MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: _buildCard(),
          )
        : _buildCard();
  }

  Widget _buildCard() {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        constraints: const BoxConstraints(
          minHeight: 88, // Increased from 84 to prevent overflow
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered ? AppColors.primary : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.primary.withOpacity(0.15)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _isHovered ? 8 : 5,
              spreadRadius: _isHovered ? 0 : 1,
              offset: Offset(0, _isHovered ? 0 : 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 18), // Increased vertical padding
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Ensure center alignment
            children: [
              // Icon container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Main icon
                    Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                    // Decorative circles
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Prevent overflow
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.selectedValue != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.selectedValue!,
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 13, // Slightly smaller
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textLight,
                          fontSize: 13, // Slightly smaller
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Indicator
              SizedBox(
                width: 68,
                child: widget.indicator ??
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        widget.isExpanded ? Icons.remove : Icons.add,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
