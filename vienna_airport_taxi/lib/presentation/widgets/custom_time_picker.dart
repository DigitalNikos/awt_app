// Create a professional wheel time picker that matches your requirements

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';

class CustomTimePicker extends StatefulWidget {
  final String? initialTime;
  final Function(String) onConfirm;

  const CustomTimePicker({
    super.key,
    this.initialTime,
    required this.onConfirm,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;
  int selectedHour = 8;
  int selectedMinute = 0;

  @override
  void initState() {
    super.initState();

    // Parse initial time if provided, or use current time
    if (widget.initialTime != null && widget.initialTime!.isNotEmpty) {
      final parts = widget.initialTime!.split(':');
      if (parts.length == 2) {
        selectedHour = int.tryParse(parts[0]) ?? DateTime.now().hour;
        selectedMinute = int.tryParse(parts[1]) ?? DateTime.now().minute;
      }
    } else {
      // Use current time if no initial time provided
      final now = DateTime.now();
      selectedHour = now.hour;
      selectedMinute = now.minute;
    }

    // Round minutes to nearest 5
    selectedMinute = (selectedMinute / 5).round() * 5;
    if (selectedMinute >= 60) selectedMinute = 55;

    // Use FixedExtentScrollController for wheel behavior
    _hoursController = FixedExtentScrollController(initialItem: selectedHour);
    _minutesController =
        FixedExtentScrollController(initialItem: selectedMinute ~/ 5);
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Clock SVG icon (black, same as other modals)
                        SvgPicture.asset(
                          'assets/icons/inputs/clock.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          localizations.translate(
                              'form.step1.date_time_section.select_time'),
                          style: AppTextStyles.heading3.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32), // Align with title text
                      child: Text(
                        '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textLight,
                          fontSize: 14,
                        ),
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
                    onTap: () => Navigator.of(context).pop(),
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

          // Modern time picker wheels with unified selection bar
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                children: [
                  // Headers
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          localizations
                              .translate('form.step1.date_time_section.hours'),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(width: 40), // Space for separator
                      Expanded(
                        child: Text(
                          localizations.translate(
                              'form.step1.date_time_section.minutes'),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Combined wheel picker with unified selection bar
                  Expanded(
                    child: Stack(
                      children: [
                        // Unified selection indicator spanning both wheels (no border)
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                // Removed border completely
                              ),
                            ),
                          ),
                        ),

                        // Wheels row
                        Row(
                          children: [
                            // Hours wheel (white background, no border)
                            Expanded(
                              child: _buildCleanWheelPicker(
                                controller: _hoursController,
                                itemCount: 24,
                                itemBuilder: (index) =>
                                    index.toString().padLeft(2, '0'),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedHour = index;
                                  });
                                },
                                selectedValue: selectedHour,
                              ),
                            ),

                            // Modern separator
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: const Text(
                                ':',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),

                            // Minutes wheel (white background, no border)
                            Expanded(
                              child: _buildCleanWheelPicker(
                                controller: _minutesController,
                                itemCount: 12,
                                itemBuilder: (index) =>
                                    (index * 5).toString().padLeft(2, '0'),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedMinute = index * 5;
                                  });
                                },
                                selectedValue: selectedMinute ~/ 5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Modern single OK button
          Container(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  final timeString =
                      '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
                  widget.onConfirm(timeString);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  localizations
                      .translate('form.step1.date_time_section.confirm_time'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanWheelPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) itemBuilder,
    required Function(int) onSelectedItemChanged,
    required int selectedValue,
  }) {
    // Clean wheel picker - no container decoration, white background, no borders
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 50,
      perspective: 0.01,
      diameterRatio: 1.8,
      squeeze: 1.1,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final isSelected = (itemCount == 24 && index == selectedValue) ||
              (itemCount == 12 && index == selectedValue);

          return Container(
            height: 50,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              itemBuilder(index),
              style: TextStyle(
                fontSize: isSelected ? 24 : 18,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color:
                    isSelected ? AppColors.textPrimary : Colors.grey.shade600,
              ),
            ),
          );
        },
      ),
    );
  }
}
