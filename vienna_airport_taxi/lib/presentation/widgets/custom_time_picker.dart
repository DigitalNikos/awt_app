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
  late ScrollController _hoursController;
  late ScrollController _minutesController;
  int _selectedHour = 12;
  int _selectedMinute = 0;

  final List<int> _hours = List.generate(24, (index) => index);
  final List<int> _minutes = List.generate(12, (index) => index * 5);

  @override
  void initState() {
    super.initState();

    // Parse initial time if provided
    if (widget.initialTime != null) {
      final parts = widget.initialTime!.split(':');
      if (parts.length == 2) {
        _selectedHour = int.tryParse(parts[0]) ?? 12;
        _selectedMinute = int.tryParse(parts[1]) ?? 0;
      }
    }

    _hoursController = ScrollController(
      initialScrollOffset: _selectedHour * 40.0,
    );
    _minutesController = ScrollController(
      initialScrollOffset: (_selectedMinute ~/ 5) * 40.0,
    );
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
      width: 300,
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Uhrzeit auswählen',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),

          // Time selector columns
          Expanded(
            child: Row(
              children: [
                // Hours column
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Stunde',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                // Selection indicator
                                Positioned(
                                  top: constraints.maxHeight * 0.45,
                                  left: 0,
                                  right: 0,
                                  height: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                // Hours list
                                ListView.builder(
                                  controller: _hoursController,
                                  itemCount: _hours.length,
                                  itemExtent: 40,
                                  itemBuilder: (context, index) {
                                    final hour = _hours[index];
                                    final isSelected = hour == _selectedHour;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedHour = hour;
                                          _hoursController.animateTo(
                                            hour * 40.0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          hour.toString().padLeft(2, '0'),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Separator
                Container(
                  width: 1,
                  color: AppColors.border,
                  height: 200,
                ),

                // Minutes column
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Minute',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                // Selection indicator
                                Positioned(
                                  top: constraints.maxHeight * 0.45,
                                  left: 0,
                                  right: 0,
                                  height: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                // Minutes list
                                ListView.builder(
                                  controller: _minutesController,
                                  itemCount: _minutes.length,
                                  itemExtent: 40,
                                  itemBuilder: (context, index) {
                                    final minute = _minutes[index];
                                    final isSelected =
                                        minute == _selectedMinute;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedMinute = minute;
                                          _minutesController.animateTo(
                                            index * 40.0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          minute.toString().padLeft(2, '0'),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.backgroundLight,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Abbrechen',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final timeString =
                          '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}';
                      widget.onConfirm(timeString);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Bestätigen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
}
