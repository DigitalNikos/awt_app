import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onConfirm;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String title;

  const CustomDatePicker({
    super.key,
    this.initialDate,
    required this.onConfirm,
    this.firstDate,
    this.lastDate,
    this.title = 'Datum auswählen',
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime tempSelectedDate;

  @override
  void initState() {
    super.initState();
    tempSelectedDate = widget.initialDate ?? DateTime.now();
  }

  // Helper method to get localized weekday names
  List<String> _getLocalizedWeekdays(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final locale = localizations.locale;

    // Create a date that starts on Monday (to get correct order)
    final monday = DateTime(2024, 1, 1); // January 1, 2024 was a Monday

    return List.generate(7, (index) {
      final day = monday.add(Duration(days: index));
      return DateFormat('E', locale.languageCode).format(day).substring(0, 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
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
                        // Calendar SVG icon (black, same as other modals)
                        SvgPicture.asset(
                          'assets/icons/inputs/calendar.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.title,
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
                        DateFormat('EEEE, d. MMMM yyyy',
                                localizations.locale.languageCode)
                            .format(tempSelectedDate),
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

          // Modern custom calendar grid
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildModernCalendar(localizations),
            ),
          ),

          // Bottom safe area padding
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildModernCalendar(AppLocalizations localizations) {
    final now = DateTime.now();
    final firstDayOfMonth =
        DateTime(tempSelectedDate.year, tempSelectedDate.month, 1);
    // Calculate start date: DateTime.weekday is 1 (Monday) to 7 (Sunday)
    // We want Monday to be day 0, so we subtract 1, but handle Sunday (7) specially
    final daysToSubtract = firstDayOfMonth.weekday == 7 ? 6 : firstDayOfMonth.weekday - 1;
    final startDate = firstDayOfMonth.subtract(Duration(days: daysToSubtract));

    return Column(
      children: [
        // Month navigation
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous month
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      tempSelectedDate = DateTime(
                          tempSelectedDate.year, tempSelectedDate.month - 1, 1);
                    });
                  },
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),

              // Month/Year display
              Text(
                DateFormat('MMMM yyyy', localizations.locale.languageCode)
                    .format(tempSelectedDate),
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              // Next month
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      tempSelectedDate = DateTime(
                          tempSelectedDate.year, tempSelectedDate.month + 1, 1);
                    });
                  },
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Weekday headers
        Row(
          children: _getLocalizedWeekdays(context).map((day) {
            return Expanded(
              child: SizedBox(
                height: 32,
                child: Center(
                  child: Text(
                    day,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // Calendar grid - generate 6 weeks to handle all edge cases
        ...List.generate(6, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              // Use proper date arithmetic to avoid DST issues
              final dayOffset = weekIndex * 7 + dayIndex;
              final date = DateTime(
                startDate.year,
                startDate.month,
                startDate.day + dayOffset,
              );
              final isCurrentMonth = date.month == tempSelectedDate.month;
              final isSelected = date.day == tempSelectedDate.day &&
                  date.month == tempSelectedDate.month &&
                  date.year == tempSelectedDate.year;
              final isToday = date.day == now.day &&
                  date.month == now.month &&
                  date.year == now.year;
              final isPastDate = date
                  .isBefore(DateTime.now().subtract(const Duration(days: 1)));

              return Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.all(1),
                  child: Material(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: isCurrentMonth && !isPastDate
                          ? () {
                              setState(() {
                                tempSelectedDate = date;
                              });
                              // Auto-confirm selection after brief delay
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                if (!context.mounted) return;
                                widget.onConfirm(tempSelectedDate);
                                Navigator.of(context).pop();
                              });
                            }
                          : null,
                      child: Center(
                        child: Text(
                          date.day.toString(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isPastDate
                                ? Colors.grey.shade300
                                : !isCurrentMonth
                                    ? Colors.grey.shade400
                                    : isSelected
                                        ? Colors.black
                                        : isToday
                                            ? AppColors.primary
                                            : Colors.black87,
                            fontWeight: isSelected || isToday
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}
