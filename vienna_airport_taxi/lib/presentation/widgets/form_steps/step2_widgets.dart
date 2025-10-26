import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/option_card.dart';
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/option_panel.dart';
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/step1_widgets.dart';
import 'package:vienna_airport_taxi/presentation/widgets/custom_dropdown.dart';
import 'package:vienna_airport_taxi/data/models/booking_form_data.dart';
import 'package:vienna_airport_taxi/presentation/widgets/custom_time_picker.dart';
import 'package:vienna_airport_taxi/presentation/widgets/custom_date_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';

class StopoverWidget extends StatefulWidget {
  final bool isViennaSelected;
  final List<StopoverLocation> currentStopovers;
  final Function(String postalCode, String address) onAddStopover;
  final Function(int index) onRemoveStopover;
  final String? stopoverError;
  final Function(bool isOpen)? onPanelStateChanged;
  final Function(bool hasUnaddedData)? onValidatePanelData;
  final Function(String? postalCode, String address, BuildContext? context)?
      onValidateFields;
  final String? addressError;
  final String? postalCodeError;

  const StopoverWidget({
    super.key,
    required this.isViennaSelected,
    required this.currentStopovers,
    required this.onAddStopover,
    required this.onRemoveStopover,
    this.stopoverError,
    this.onPanelStateChanged,
    this.onValidatePanelData,
    this.onValidateFields,
    this.addressError,
    this.postalCodeError,
  });

  @override
  State<StopoverWidget> createState() => _StopoverWidgetState();
}

class _StopoverWidgetState extends State<StopoverWidget> {
  bool _isInputPanelVisible = false;
  bool _hasEverAddedStopover = false; // Track if user has ever added a stopover
  String? _selectedPostalCode;
  String _address = '';
  final TextEditingController _addressController = TextEditingController();

  // Method to check if panel is open with data but not added
  bool get hasUnaddedStopoverData =>
      _isInputPanelVisible &&
      ((_selectedPostalCode != null && _selectedPostalCode!.isNotEmpty) ||
          _address.isNotEmpty);

  // Helper method to get district name from postal code
  String _getDistrictName(String postalCode) {
    const Map<String, String> districts = {
      '1010': 'Innere Stadt',
      '1020': 'Leopoldstadt',
      '1030': 'Landstraße',
      '1040': 'Wieden',
      '1050': 'Margareten',
      '1060': 'Mariahilf',
      '1070': 'Neubau',
      '1080': 'Josefstadt',
      '1090': 'Alsergrund',
      '1100': 'Favoriten',
      '1110': 'Simmering',
      '1120': 'Meidling',
      '1130': 'Hietzing',
      '1140': 'Penzing',
      '1150': 'Rudolfsheim-Fünfhaus',
      '1160': 'Ottakring',
      '1170': 'Hernals',
      '1180': 'Währing',
      '1190': 'Döbling',
      '1200': 'Brigittenau',
      '1210': 'Floridsdorf',
      '1220': 'Donaustadt',
      '1230': 'Liesing',
    };
    return districts[postalCode] ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _addStopover() {
    // Validate fields before adding
    bool hasErrors = false;

    if (_selectedPostalCode == null || _selectedPostalCode!.isEmpty) {
      widget.onValidateFields?.call(null, _address, context);
      hasErrors = true;
    }

    if (_address.isEmpty) {
      widget.onValidateFields?.call(_selectedPostalCode, '', context);
      hasErrors = true;
    }

    // If both fields are empty, validate both
    if ((_selectedPostalCode == null || _selectedPostalCode!.isEmpty) &&
        _address.isEmpty) {
      widget.onValidateFields?.call(null, '', context);
      hasErrors = true;
    }

    // Only add if no errors
    if (!hasErrors && _selectedPostalCode != null && _address.isNotEmpty) {
      widget.onAddStopover(_selectedPostalCode!, _address);

      // Clear any existing field errors after successful add
      widget.onValidateFields?.call('clear_errors', 'clear_errors', context);

      setState(() {
        _selectedPostalCode = null;
        _address = '';
        _addressController.clear();
        _isInputPanelVisible = false; // Hide input panel after adding
        _hasEverAddedStopover = true; // Mark that user has added a stopover
      });
      widget.onPanelStateChanged?.call(false);
    }
  }

  // Method to close panel and clear all stopovers (main X button)
  void _closeAllAndClearStopovers() {
    // Clear all stopovers first
    for (int i = widget.currentStopovers.length - 1; i >= 0; i--) {
      widget.onRemoveStopover(i);
    }

    // Then close the panel
    setState(() {
      _isInputPanelVisible = false;
      _selectedPostalCode = null;
      _address = '';
      _addressController.clear();
      _hasEverAddedStopover = false; // Reset the flag
    });
    widget.onPanelStateChanged?.call(false);
  }

  // Method to just close input panel (input X button)
  void _closeInputPanel() {
    setState(() {
      _isInputPanelVisible = false;
      _selectedPostalCode = null;
      _address = '';
      _addressController.clear();
    });
    widget.onPanelStateChanged?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isViennaSelected) return const SizedBox.shrink();

    const maxStopovers = 3;
    final currentCount = widget.currentStopovers.length;
    final canAddMore = currentCount < maxStopovers;
    final hasInitialCard = currentCount == 0;
    final localizations = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Show initial card only when no stopovers exist and input panel is not visible
          if (hasInitialCard && !_isInputPanelVisible)
            OptionCard(
              svgIcon: 'assets/icons/panels/add_location.svg',
              title: localizations
                  .translate('form.step2.stopover_section.stopover_title'),
              description: localizations.translate(
                  'form.step2.stopover_section.stopover_description'),
              isExpanded: false,
              onTap: () {
                // Clear any existing field errors when opening panel for first time
                widget.onValidateFields
                    ?.call('clear_errors', 'clear_errors', context);

                setState(() {
                  _isInputPanelVisible = true;
                });
                widget.onPanelStateChanged?.call(true);
              },
            ),

          // Stopover list container
          if (currentCount > 0 || _isInputPanelVisible)
            OptionPanel(
              title: localizations
                  .translate('form.step2.stopover_section.stopover_title'),
              isVisible: true,
              isError: widget.stopoverError != null,
              helperText: widget.stopoverError != null
                  ? widget.stopoverError!
                  : '${localizations.translate('form.step2.stopover_section.stopover_info_message.start')} ${maxStopovers - currentCount} ${currentCount == maxStopovers - 1 ? localizations.translate('form.step2.stopover_section.stopover_info_message.single') : localizations.translate('form.step2.stopover_section.stopover_info_message.multiple')} ${localizations.translate('form.step2.stopover_section.stopover_info_message.end')}',
              onClose:
                  _closeAllAndClearStopovers, // Main X button - closes all and clears stopovers
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stopover list
                  if (currentCount > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: widget.currentStopovers.map((stopover) {
                          final index =
                              widget.currentStopovers.indexOf(stopover);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(8),
                              border: const Border(
                                left: BorderSide(
                                  color: AppColors.primary,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${stopover.address} - ${stopover.postalCode}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    widget.onRemoveStopover(index);
                                    // If input panel is visible and no more stopovers, hide it
                                    if (_isInputPanelVisible &&
                                        currentCount == 1) {
                                      setState(() {
                                        _isInputPanelVisible = false;
                                      });
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  // Input section (visible when needed) - No border, more spacing
                  if (_isInputPanelVisible && canAddMore) ...[
                    // Header with more spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.translate(
                              'form.step2.stopover_section.stopover_panel_title'),
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        // Only show input X button if user has previously added a stopover
                        if (_hasEverAddedStopover || currentCount > 0)
                          IconButton(
                            icon: const Icon(Icons.close, size: 24),
                            onPressed:
                                _closeInputPanel, // Input X button - only closes input fields
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Input fields with SVG icons (like Step 1)
                    InputFieldWithSvgIcon(
                      svgIconPath: 'assets/icons/inputs/address.svg',
                      hintText: localizations.translate(
                          'form.step2.stopover_section.stopover_input_placeholder'),
                      value: _address,
                      errorText: widget.addressError,
                      onChanged: (value) {
                        setState(() {
                          _address = value;
                        });

                        // Clear address error immediately when user starts typing
                        if (value.isNotEmpty) {
                          widget.onValidateFields?.call('clear_address_error',
                              'clear_address_error', context);
                        }

                        // Only validate panel data (for unsaved data warning), not individual fields
                        widget.onValidatePanelData
                            ?.call(hasUnaddedStopoverData);
                      },
                    ),

                    const SizedBox(height: 16),

                    CustomDropdown(
                      svgIconPath: 'assets/icons/inputs/postal-code.svg',
                      hintText: localizations.translate(
                          'form.step2.stopover_section.stopover_plz'),
                      value: _selectedPostalCode != null
                          ? '$_selectedPostalCode - ${_getDistrictName(_selectedPostalCode!)}'
                          : null,
                      items: const [
                        '1010 - Innere Stadt',
                        '1020 - Leopoldstadt',
                        '1030 - Landstraße',
                        '1040 - Wieden',
                        '1050 - Margareten',
                        '1060 - Mariahilf',
                        '1070 - Neubau',
                        '1080 - Josefstadt',
                        '1090 - Alsergrund',
                        '1100 - Favoriten',
                        '1110 - Simmering',
                        '1120 - Meidling',
                        '1130 - Hietzing',
                        '1140 - Penzing',
                        '1150 - Rudolfsheim-Fünfhaus',
                        '1160 - Ottakring',
                        '1170 - Hernals',
                        '1180 - Währing',
                        '1190 - Döbling',
                        '1200 - Brigittenau',
                        '1210 - Floridsdorf',
                        '1220 - Donaustadt',
                        '1230 - Liesing',
                      ],
                      onChanged: (fullValue) {
                        // Extract just the postal code (first 4 digits)
                        final postalCode = fullValue.split(' - ')[0];
                        setState(() {
                          _selectedPostalCode = postalCode;
                        });

                        // Clear PLZ error immediately when user selects a value
                        if (postalCode.isNotEmpty) {
                          widget.onValidateFields?.call(
                              'clear_plz_error', 'clear_plz_error', context);
                        }

                        // Only validate panel data (for unsaved data warning), not individual fields
                        widget.onValidatePanelData
                            ?.call(hasUnaddedStopoverData);
                      },
                      errorText: widget.postalCodeError,
                    ),

                    const SizedBox(height: 24),

                    // Add button with more spacing
                    ElevatedButton(
                      onPressed: _addStopover,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_location,
                              size: 18, color: Colors.black),
                          const SizedBox(width: 12),
                          Text(
                            localizations.translate(
                                'form.step2.stopover_section.stopover_new_butrton'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ] else if (!_isInputPanelVisible &&
                      currentCount > 0 &&
                      canAddMore) ...[
                    // "Add another stopover" button with better spacing
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Clear any existing field errors when opening panel for second+ stopover
                        widget.onValidateFields
                            ?.call('clear_errors', 'clear_errors', context);

                        setState(() {
                          _isInputPanelVisible = true;
                        });
                        widget.onPanelStateChanged?.call(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(
                          color: AppColors.primary,
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_location,
                              size: 18, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Text(
                            localizations.translate(
                                'form.step2.stopover_section.stopover_add_another_button'),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ReturnTripWidget extends StatefulWidget {
  final bool isReturnTripActive;
  final DateTime? returnDate;
  final String? returnTime;
  final String? flightFrom;
  final String? flightNumber;
  final Function(bool) onReturnTripChanged;
  final Function(DateTime?) onReturnDateChanged;
  final Function(String?) onReturnTimeChanged;
  final Function(String?)? onFlightFromChanged;
  final Function(String?)? onFlightNumberChanged;
  // Error message parameters
  final String? returnDateError;
  final String? returnTimeError;
  final String? flightFromError;
  final String? flightNumberError;
  final String? returnDateTimeError;

  const ReturnTripWidget({
    super.key,
    required this.isReturnTripActive,
    required this.returnDate,
    required this.returnTime,
    this.flightFrom,
    this.flightNumber,
    required this.onReturnTripChanged,
    required this.onReturnDateChanged,
    required this.onReturnTimeChanged,
    this.onFlightFromChanged,
    this.onFlightNumberChanged,
    this.returnDateError,
    this.returnTimeError,
    this.flightFromError,
    this.flightNumberError,
    this.returnDateTimeError,
  });

  @override
  State<ReturnTripWidget> createState() => _ReturnTripWidgetState();
}

class _ReturnTripWidgetState extends State<ReturnTripWidget> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Only show the option card when return trip is NOT active
          if (!widget.isReturnTripActive)
            OptionCard(
              svgIcon: 'assets/icons/panels/compare_arrows.svg',
              title: localizations
                  .translate('form.step2.return_trip_section.return_trip'),
              description: localizations.translate(
                  'form.step2.return_trip_section.return_trip_description'),
              isExpanded: widget.isReturnTripActive,
              onTap: () {
                widget.onReturnTripChanged(!widget.isReturnTripActive);
              },
            ),

          // Option panel
          OptionPanel(
            title: localizations
                .translate('form.step2.return_trip_section.return_trip'),
            isVisible: widget.isReturnTripActive,
            helperText: localizations.translate(
                'form.step2.return_trip_section.return_trip_info_message'),
            onClose: () {
              widget.onReturnTripChanged(false);
            },
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date and time section
                Text(
                  localizations.translate(
                      'form.step2.return_trip_section.return_trip_question'),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: InputFieldWithSvgIcon(
                        svgIconPath: 'assets/icons/inputs/calendar.svg',
                        hintText: localizations.translate(
                            'form.step2.return_trip_section.return_trip_date'),
                        value: widget.returnDate != null
                            ? DateFormat('dd.MM.yyyy')
                                .format(widget.returnDate!)
                            : null,
                        errorText: widget.returnDateError,
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            builder: (BuildContext context) {
                              return CustomDatePicker(
                                initialDate:
                                    widget.returnDate ?? DateTime.now(),
                                onConfirm: (selectedDate) {
                                  widget.onReturnDateChanged(selectedDate);
                                },
                                title: localizations.translate(
                                    'form.step2.return_trip_section.return_trip_date_select'),
                              );
                            },
                          );
                        },
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InputFieldWithSvgIcon(
                        svgIconPath: 'assets/icons/inputs/clock.svg',
                        hintText: localizations.translate(
                            'form.step2.return_trip_section.return_trip_time'),
                        value: widget.returnTime,
                        errorText: widget.returnTimeError,
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            builder: (BuildContext context) {
                              return CustomTimePicker(
                                initialTime: widget.returnTime,
                                onConfirm: (timeString) {
                                  widget.onReturnTimeChanged(timeString);
                                },
                              );
                            },
                          );
                        },
                        readOnly: true,
                      ),
                    ),
                  ],
                ),

                // Flight information section (only show if flight callbacks are provided)
                if (widget.onFlightFromChanged != null &&
                    widget.onFlightNumberChanged != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    localizations.translate(
                        'form.step2.return_trip_section.flight_information_title'),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InputFieldWithIcon(
                          icon: Icons.flight_land,
                          hintText: 'Abflugort',
                          value: widget.flightFrom,
                          onChanged: widget.onFlightFromChanged,
                          errorText: widget.flightFromError,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InputFieldWithIcon(
                          icon: Icons.flight,
                          hintText: 'Flugnummer',
                          value: widget.flightNumber,
                          onChanged: widget.onFlightNumberChanged,
                          errorText: widget.flightNumberError,
                        ),
                      ),
                    ],
                  ),
                ],

                // Display combined date/time validation error
                if (widget.returnDateTimeError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      widget.returnDateTimeError!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
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

class ChildSeatWidget extends StatelessWidget {
  final String selectedChildSeat;
  final Function(String) onChildSeatChanged;

  const ChildSeatWidget({
    super.key,
    required this.selectedChildSeat,
    required this.onChildSeatChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final childSeatOptions = {
      'None': localizations
          .translate('form.step2.child_seat_section.child_seat_option_none'),
      'booster_seat': localizations.translate(
          'form.step2.child_seat_section.child_seat_option_booster_seat'),
      'child_seat': localizations.translate(
          'form.step2.child_seat_section.child_seat_option_child_seat'),
      'baby_carrier': localizations.translate(
          'form.step2.child_seat_section.child_seat_option_baby_carrier'),
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // OptionCard that displays the current selection
            OptionCard(
              svgIcon: 'assets/icons/panels/child_care.svg',
              title: localizations
                  .translate('form.step2.child_seat_section.child_seat_title'),
              description: localizations.translate(
                  'form.step2.child_seat_section.child_seat_description'),
              // Removed custom indicator - will use default + icon like other panels
              selectedValue: selectedChildSeat != 'None'
                  ? childSeatOptions[selectedChildSeat]
                  : null,
            ),

            // Invisible overlay to capture taps
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Show custom dropdown
                    _showChildSeatOptions(context, selectedChildSeat,
                        childSeatOptions, onChildSeatChanged, localizations);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChildSeatOptions(
    BuildContext context,
    String currentSelection,
    Map<String, String> options,
    Function(String) onChanged,
    AppLocalizations localizations,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.translate(
                        'form.step2.child_seat_section.child_seat_select_option'),
                    style: AppTextStyles.heading3,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Options
              ...options.entries.map((entry) {
                final isSelected = entry.key == currentSelection;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      title: Text(
                        entry.value,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : null,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check,
                              color: AppColors.primary, size: 20)
                          : null,
                      onTap: () {
                        onChanged(entry.key);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class NameSignWidget extends StatelessWidget {
  final bool isReturnTripActive;
  final bool nameplateService;
  final Function(bool) onNameplateServiceChanged;

  const NameSignWidget({
    super.key,
    required this.isReturnTripActive,
    required this.nameplateService,
    required this.onNameplateServiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!isReturnTripActive) return const SizedBox.shrink();
    final localizations = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), // Fixed margin
      child: OptionCard(
        svgIcon: 'assets/icons/panels/badge.svg',
        title: localizations
            .translate('form.step2.nameplate_section.nameplate_title'),
        description: localizations
            .translate('form.step2.nameplate_section.nameplate_description'),
        indicator: SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: nameplateService,
            onChanged: (value) {
              if (value != null) {
                onNameplateServiceChanged(value);
              }
            },
            activeColor: AppColors.success,
          ),
        ),
        onTap: () {
          onNameplateServiceChanged(!nameplateService);
        },
      ),
    );
  }
}

class PaymentMethodWidget extends StatelessWidget {
  final String paymentMethod;
  final Function(String) onPaymentMethodChanged;

  const PaymentMethodWidget({
    super.key,
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: OptionCard(
        svgIcon: paymentMethod == 'cash'
            ? 'assets/icons/panels/attach_money.svg'
            : 'assets/icons/panels/credit_card.svg',
        title:
            localizations.translate('form.step2.payment_section.payment_title'),
        description: localizations
            .translate('form.step2.payment_section.payment_description'),
        indicator: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            paymentMethod == 'cash'
                ? localizations
                    .translate('form.step2.payment_section.payment_method_cash')
                : localizations.translate(
                    'form.step2.payment_section.payment_method_card'),
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
              fontSize: 14, // Ensure proper font size
            ),
          ),
        ),
        onTap: () {
          final newMethod = paymentMethod == 'cash' ? 'card' : 'cash';
          onPaymentMethodChanged(newMethod);
        },
      ),
    );
  }
}

class CommentWidget extends StatefulWidget {
  final String? comment;
  final Function(String?) onCommentChanged;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.onCommentChanged,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isExpanded = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.comment ?? '';
    _isExpanded = widget.comment != null && widget.comment!.isNotEmpty;
  }

  @override
  void didUpdateWidget(CommentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.comment != oldWidget.comment) {
      _commentController.text = widget.comment ?? '';
      _isExpanded = widget.comment != null && widget.comment!.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        // Add this to prevent overflow visual indicator
        borderRadius: BorderRadius.circular(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded ? 220 : 88,
              curve: Curves.easeInOut, // Smooth animation curve
              child: GestureDetector(
                onTap: () {
                  if (!_isExpanded) {
                    setState(() {
                      _isExpanded = true;
                    });
                  }
                },
                child: _isExpanded
                    ? _buildExpandedState()
                    : _buildCollapsedState(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCollapsedState() {
    final localizations = AppLocalizations.of(context);
    return OptionCard(
      svgIcon: 'assets/icons/panels/note_add.svg',
      title: localizations.translate('form.step2.notes_section.notes_title'),
      description:
          localizations.translate('form.step2.notes_section.notes_description'),
    );
  }

  Widget _buildExpandedState() {
    final localizations = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with icon and close button
          Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icons/panels/note_add.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    localizations
                        .translate('form.step2.notes_section.notes_title'),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Close button
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  color: AppColors.textSecondary,
                  onPressed: () {
                    setState(() {
                      _isExpanded = false;
                      _commentController.clear();
                      widget.onCommentChanged(null);
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
              ],
            ),
          ),

          // Textarea
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _commentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: localizations.translate(
                      'form.step2.notes_section.notes_input_placeholder'),
                  hintStyle: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: (value) {
                  widget.onCommentChanged(value.isEmpty ? null : value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 192,
      height: 3,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          stops: [0.0, 1.0],
          colors: [AppColors.primary, Color.fromARGB(0, 255, 255, 255)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
