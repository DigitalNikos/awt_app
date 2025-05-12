import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vienna_airport_taxi/core/constants/app_constants.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';
import 'dart:ui' as ui show TextDirection;
import 'package:vienna_airport_taxi/presentation/widgets/custom_time_picker.dart';

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
              child: InputFieldWithIcon(
                icon: Icons.calendar_month,
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
              child: InputFieldWithIcon(
                icon: Icons.access_time,
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

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('de'),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: CustomTimePicker(
            initialTime: selectedTime,
            onConfirm: (timeString) {
              onTimeSelected(timeString);
            },
          ),
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
        DropdownFieldWithIcon(
          icon: Icons.location_on,
          hintText: 'Ort',
          value: selectedCity,
          errorText: cityError,
          items: const [
            'Wien',
            'Klagenfurt am Wörthersee',
            'Achau',
            'Salzburg',
            'Linz',
            'Klagenfurt',
          ],
          onChanged: onCitySelected,
        ),

        const SizedBox(height: 12),

        // Postal code selector (only shown when Wien is selected)
        if (selectedCity == 'Wien')
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DropdownFieldWithIcon(
              icon: Icons.markunread_mailbox,
              hintText: 'PLZ',
              value: selectedPostalCode != null
                  ? '$selectedPostalCode - ${_getDistrictName(selectedPostalCode!)}'
                  : null,
              errorText: postalCodeError,
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
            ),
          ),

        // Address input
        InputFieldWithIcon(
          icon: Icons.home,
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
          child: DropdownFieldWithIcon(
            icon: Icons.people,
            hintText: 'Personen',
            value: passengerCount.toString(),
            errorText: passengerError,
            items: List.generate(8, (index) => (index + 1).toString()),
            onChanged: (value) => onPassengerCountChanged(int.parse(value)),
          ),
        ),

        const SizedBox(width: 12),

        // Luggage count
        Expanded(
          child: DropdownFieldWithIcon(
            icon: Icons.luggage,
            hintText: 'Koffer',
            value: luggageCount.toString(),
            errorText: luggageError,
            items: List.generate(9, (index) => index.toString()),
            onChanged: (value) => onLuggageCountChanged(int.parse(value)),
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
        InputFieldWithIcon(
          icon: Icons.person,
          hintText: 'Name',
          value: name,
          onChanged: onNameChanged,
          errorText: nameError,
        ),

        const SizedBox(height: 12),

        // Email
        InputFieldWithIcon(
          icon: Icons.email,
          hintText: 'Email',
          value: email,
          onChanged: onEmailChanged,
          keyboardType: TextInputType.emailAddress,
          errorText: emailError,
        ),

        const SizedBox(height: 12),

        // Phone
        InputFieldWithIcon(
          icon: Icons.phone,
          hintText: 'Telefonnummer',
          value: phone,
          onChanged: onPhoneChanged,
          keyboardType: TextInputType.phone,
          errorText: phoneError,
        ),
      ],
    );
  }
}

// Reusable components

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
              color:
                  widget.errorText != null ? AppColors.error : AppColors.border,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
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
              border: InputBorder.none,
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
              color: errorText != null ? AppColors.error : AppColors.border,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.textLight),
              border: InputBorder.none,
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
