// Create a professional wheel time picker that matches your requirements

import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';

class CustomTimePicker extends StatefulWidget {
  final String? initialTime;
  final Function(String) onConfirm;

  const CustomTimePicker({
    Key? key,
    this.initialTime,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;
  int selectedHour = 8;
  int selectedMinute = 0;

  static const double itemHeight = 34.0;
  static const int visibleItems = 5; // Show 5 items at once

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
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCCCCCC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with yellow background (matching date picker)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              'Uhrzeit auswählen',
              style: AppTextStyles.heading3.copyWith(
                color: Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Time picker wheels
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Hours column
                Expanded(
                  child: Column(
                    children: [
                      // Header
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Stunde',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                      // Hours wheel
                      _buildWheelPicker(
                        controller: _hoursController,
                        itemCount: 24,
                        itemBuilder: (index) =>
                            index.toString().padLeft(2, '0'),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedHour = index;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Separator
                Container(
                  width: 20,
                  child: Center(
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                // Minutes column
                Expanded(
                  child: Column(
                    children: [
                      // Header
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Minute',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      // Minutes wheel
                      _buildWheelPicker(
                        controller: _minutesController,
                        itemCount:
                            12, // 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55
                        itemBuilder: (index) =>
                            (index * 5).toString().padLeft(2, '0'),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedMinute = index * 5;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action buttons (matching date picker style)
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel button (red)
                Expanded(
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(156, 162, 159, 159),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Abbrechen',
                        style: TextStyle(
                          fontSize: 12, // Reduced font size to fit better
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1, // Ensure single line
                        overflow:
                            TextOverflow.ellipsis, // Handle overflow gracefully
                      ),
                    ),
                  ),
                ),

                // OK button (green)
                Expanded(
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        final timeString =
                            '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
                        widget.onConfirm(timeString);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheelPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) itemBuilder,
    required Function(int) onSelectedItemChanged,
  }) {
    return Container(
      height: 180,
      child: Stack(
        children: [
          // Selection indicator (middle highlight)
          Positioned.fill(
            child: Center(
              child: Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          // Wheel picker
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: itemHeight,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                return Container(
                  height: itemHeight,
                  alignment: Alignment.center,
                  child: Text(
                    itemBuilder(index),
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
