import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vienna_airport_taxi/core/constants/app_constants.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';
import 'dart:ui' as ui show TextDirection;
import 'package:vienna_airport_taxi/presentation/widgets/custom_time_picker.dart';
import 'package:vienna_airport_taxi/presentation/widgets/custom_date_picker.dart';
import 'package:vienna_airport_taxi/presentation/widgets/custom_dropdown.dart';
import 'package:vienna_airport_taxi/presentation/widgets/phone_input_field.dart';

class DateTimeSelectionWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final String? selectedTime;
  final Function(DateTime) onDateSelected;
  final Function(String) onTimeSelected;
  final String? dateError;
  final String? timeError;

  const DateTimeSelectionWidget({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
    this.dateError,
    this.timeError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datum und Uhrzeit',
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 8),
        const SectionDivider(),
        const SizedBox(height: 16),
        Row(
          children: [
            // Date picker
            Expanded(
              child: InputFieldWithSvgIcon(
                svgIconPath: 'assets/icons/inputs/calendar.svg',
                hintText: 'Datum',
                value: selectedDate != null
                    ? DateFormat('dd.MM.yyyy').format(selectedDate!)
                    : null,
                onTap: () => _showDatePicker(context),
                readOnly: true,
                errorText: dateError,
              ),
            ),
            const SizedBox(width: 12),

            // Time picker
            Expanded(
              child: InputFieldWithSvgIcon(
                svgIconPath: 'assets/icons/inputs/clock.svg',
                hintText: 'Uhrzeit',
                value: selectedTime,
                onTap: () => _showTimePicker(context),
                readOnly: true,
                errorText: timeError,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Replace your _showDatePicker method with this version:

  Future<void> _showDatePicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return CustomDatePicker(
          initialDate: selectedDate,
          onConfirm: (date) {
            onDateSelected(date);
          },
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          title: 'Datum auswählen',
        );
      },
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return CustomTimePicker(
          initialTime: selectedTime,
          onConfirm: (timeString) {
            onTimeSelected(timeString);
          },
        );
      },
    );
  }
}

class AddressSelectionWidget extends StatelessWidget {
  final String? selectedCity;
  final String? selectedPostalCode;
  final String? address;
  final Function(String) onCitySelected;
  final Function(String) onPostalCodeSelected;
  final Function(String) onAddressChanged;
  final String? cityError;
  final String? postalCodeError;
  final String? addressError;

  const AddressSelectionWidget({
    Key? key,
    required this.selectedCity,
    required this.selectedPostalCode,
    required this.address,
    required this.onCitySelected,
    required this.onPostalCodeSelected,
    required this.onAddressChanged,
    this.cityError,
    this.postalCodeError,
    this.addressError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Zieladresse',
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 8),
        const SectionDivider(),
        const SizedBox(height: 16),

        // City selector
        CustomDropdown(
          svgIconPath: 'assets/icons/inputs/location.svg',
          hintText: 'Ort',
          value: selectedCity,
          items: const [
            'Wien',
            'Klagenfurt am Wörthersee',
            'Achau',
            'Salzburg',
            'Linz',
            'Klagenfurt',
          ],
          onChanged: onCitySelected,
          errorText: cityError,
        ),

        const SizedBox(height: 12),

        // Postal code selector (only shown when Wien is selected)
        if (selectedCity == 'Wien')
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CustomDropdown(
              svgIconPath: 'assets/icons/inputs/postal-code.svg',
              hintText: 'PLZ',
              value: selectedPostalCode != null
                  ? '$selectedPostalCode - ${_getDistrictName(selectedPostalCode!)}'
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
                // Extract only the postal code (first 4 digits)
                final postalCode = fullValue.split(' - ')[0];
                onPostalCodeSelected(postalCode);
              },
              errorText: postalCodeError,
            ),
          ),

        // Address input
        InputFieldWithSvgIcon(
          svgIconPath: 'assets/icons/inputs/address.svg',
          hintText: 'Adresse',
          value: address,
          onChanged: onAddressChanged,
          errorText: addressError,
        ),
      ],
    );
  }

  // Helper method to get district name from postal code
  String _getDistrictName(String postalCode) {
    final districts = {
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
}

// In your step1_widgets.dart file, update the PassengerAndLuggageWidget:

class PassengerAndLuggageWidget extends StatelessWidget {
  final int passengerCount;
  final int luggageCount;
  final Function(int) onPassengerCountChanged;
  final Function(int) onLuggageCountChanged;
  final String? passengerError;
  final String? luggageError;

  const PassengerAndLuggageWidget({
    Key? key,
    required this.passengerCount,
    required this.luggageCount,
    required this.onPassengerCountChanged,
    required this.onLuggageCountChanged,
    this.passengerError,
    this.luggageError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Passenger count
        Expanded(
          child: CustomDropdown(
            svgIconPath: 'assets/icons/inputs/people.svg',
            hintText: 'Personen',
            value: passengerCount > 0 ? passengerCount.toString() : '1',
            items: ['1', '2', '3', '4', '5', '6', '7', '8'],
            onChanged: (value) {
              onPassengerCountChanged(int.parse(value));
            },
            errorText: passengerError,
          ),
        ),

        const SizedBox(width: 12),

        // Luggage count
        Expanded(
          child: CustomDropdown(
            svgIconPath: 'assets/icons/inputs/luggage.svg',
            hintText: 'Koffer',
            value: luggageCount.toString(),
            items: ['0', '1', '2', '3', '4', '5', '6', '7', '8'],
            onChanged: (value) {
              onLuggageCountChanged(int.parse(value));
            },
            errorText: luggageError,
          ),
        ),
      ],
    );
  }
}

class ContactInformationWidget extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;
  final Function(String) onNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPhoneChanged;
  final String? nameError;
  final String? emailError;
  final String? phoneError;

  const ContactInformationWidget({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    this.nameError,
    this.emailError,
    this.phoneError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kontakt',
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 8),
        const SectionDivider(),
        const SizedBox(height: 16),

        // Name
        InputFieldWithSvgIcon(
          svgIconPath: 'assets/icons/inputs/person.svg',
          hintText: 'Name',
          value: name,
          onChanged: onNameChanged,
          errorText: nameError,
        ),

        const SizedBox(height: 12),

        // Email
        InputFieldWithSvgIcon(
          svgIconPath: 'assets/icons/inputs/email.svg',
          hintText: 'Email',
          value: email,
          onChanged: onEmailChanged,
          keyboardType: TextInputType.emailAddress,
          errorText: emailError,
        ),

        const SizedBox(height: 12),

        // Phone with +43 prefix
        PhoneInputField(
          value: phone,
          onChanged: onPhoneChanged,
          errorText: phoneError,
          hintText: 'Telefonnummer',
        ),
      ],
    );
  }
}

// Reusable components - Legacy Material Icon versions (for backward compatibility)

class InputFieldWithIcon extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final String? value;
  final Function(String)? onChanged;
  final Function()? onTap;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? errorText;

  const InputFieldWithIcon({
    Key? key,
    required this.icon,
    required this.hintText,
    this.value,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
  }) : super(key: key);

  @override
  State<InputFieldWithIcon> createState() => _InputFieldWithIconState();
}

class _InputFieldWithIconState extends State<InputFieldWithIcon> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(InputFieldWithIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: widget.errorText != null
                  ? AppColors.error
                  : const Color(0xFFCCCCCC), // #ccc border
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: TextFormField(
            controller: _controller,
            onChanged: widget.onChanged,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            onTap: widget.onTap,
            textDirection: ui.TextDirection.ltr,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: AppColors.textLight),
              // COMPLETELY REMOVE ALL BORDERS FROM TEXTFORMFIELD
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              prefixIcon: Icon(
                widget.icon,
                size: 20,
                color: AppColors.textLight,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                maxWidth: 40,
                minHeight: 48,
                maxHeight: 48,
              ),
            ),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
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

class DropdownFieldWithIcon extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final String? value;
  final List<String> items;
  final Function(String) onChanged;
  final String? errorText;

  const DropdownFieldWithIcon({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: errorText != null
                  ? AppColors.error
                  : const Color(0xFFCCCCCC), // #ccc border
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.textLight),
              // COMPLETELY REMOVE ALL BORDERS FROM DROPDOWN
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              prefixIcon: Icon(
                icon,
                size: 30,
                color: AppColors.textLight,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                maxWidth: 40,
                minHeight: 48,
                maxHeight: 48,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: AppTextStyles.bodyMedium),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            dropdownColor: Colors.white,
            // Remove default dropdown arrow
            icon: const SizedBox.shrink(),
            isExpanded: true,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText!,
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

// Reusable components with SVG support

class InputFieldWithSvgIcon extends StatefulWidget {
  final String svgIconPath;
  final String hintText;
  final String? value;
  final Function(String)? onChanged;
  final Function()? onTap;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? errorText;

  const InputFieldWithSvgIcon({
    Key? key,
    required this.svgIconPath,
    required this.hintText,
    this.value,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
  }) : super(key: key);

  @override
  State<InputFieldWithSvgIcon> createState() => _InputFieldWithSvgIconState();
}

class _InputFieldWithSvgIconState extends State<InputFieldWithSvgIcon> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(InputFieldWithSvgIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: widget.errorText != null
                  ? AppColors.error
                  : const Color(0xFFCCCCCC), // #ccc border
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: TextFormField(
            controller: _controller,
            onChanged: widget.onChanged,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            onTap: widget.onTap,
            textDirection: ui.TextDirection.ltr,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: AppColors.textLight),
              // COMPLETELY REMOVE ALL BORDERS FROM TEXTFORMFIELD
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              prefixIcon: Container(
                width: 40,
                height: 48,
                padding: const EdgeInsets.all(
                    10), // Increased padding for smaller icons
                child: SvgPicture.asset(
                  widget.svgIconPath,
                  width: 18, // Reduced from 20 to 16
                  height: 18, // Reduced from 20 to 16
                  // Removed colorFilter to show original SVG colors
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                maxWidth: 40,
                minHeight: 48,
                maxHeight: 48,
              ),
            ),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
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

class DropdownFieldWithSvgIcon extends StatefulWidget {
  final String svgIconPath;
  final String hintText;
  final String? value;
  final List<String> items;
  final Function(String) onChanged;
  final String? errorText;

  const DropdownFieldWithSvgIcon({
    Key? key,
    required this.svgIconPath,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  State<DropdownFieldWithSvgIcon> createState() =>
      _DropdownFieldWithSvgIconState();
}

class _DropdownFieldWithSvgIconState extends State<DropdownFieldWithSvgIcon> {
  void _showModalBottomSheet() {
    print('DEBUG: Showing modal for ${widget.hintText}');
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
                          '${widget.hintText} auswählen',
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
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
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

              // Modern options grid
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: widget.hintText == 'Personen' ||
                          widget.hintText == 'Koffer'
                      ? _buildModernNumberGrid()
                      : _buildModernList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernNumberGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final isSelected = item == widget.value;
        return Material(
          color: isSelected ? AppColors.primaryLight : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              widget.onChanged(item);
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isSelected ? AppColors.textPrimary : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.textPrimary
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernList() {
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
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.textPrimary
                          : Colors.grey.shade300,
                      width: isSelected ? 1.5 : 1,
                    ),
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
                      if (isSelected)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
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
        // Main dropdown container (same styling as inputs)
        GestureDetector(
          onTap: () {
            print('DEBUG: Tapping ${widget.hintText} dropdown');
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

class FlightInformationWidget extends StatelessWidget {
  final String? flightFrom;
  final String? flightNumber;
  final Function(String?) onFlightFromChanged;
  final Function(String?) onFlightNumberChanged;
  final String? flightFromError;
  final String? flightNumberError;

  const FlightInformationWidget({
    Key? key,
    required this.flightFrom,
    required this.flightNumber,
    required this.onFlightFromChanged,
    required this.onFlightNumberChanged,
    this.flightFromError,
    this.flightNumberError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fluginformationen',
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 8),
        const SectionDivider(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InputFieldWithIcon(
                icon: Icons.flight_land,
                hintText: 'Abflugort',
                value: flightFrom,
                onChanged: onFlightFromChanged,
                errorText: flightFromError,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InputFieldWithIcon(
                icon: Icons.flight,
                hintText: 'Flugnummer',
                value: flightNumber,
                onChanged: onFlightNumberChanged,
                errorText: flightNumberError,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 192,
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: const [0.0, 1.0],
          colors: [AppColors.primary, const Color.fromARGB(0, 255, 255, 255)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
