import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
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
  final String? reservationTimeError;

  const DateTimeSelectionWidget({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
    this.dateError,
    this.timeError,
    this.reservationTimeError,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('form.step1.date_time_section.date_and_time'),
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
                hintText: localizations
                    .translate('form.step1.date_time_section.date'),
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
                hintText: localizations
                    .translate('form.step1.date_time_section.time'),
                value: selectedTime,
                onTap: () => _showTimePicker(context),
                readOnly: true,
                errorText: timeError,
              ),
            ),
          ],
        ),
        // ADD THE RESERVATION ERROR DISPLAY HERE:
        if (reservationTimeError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reservationTimeError!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Replace your _showDatePicker method with this version:

  Future<void> _showDatePicker(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
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
          title: localizations
              .translate('form.step1.date_time_section.select_date'),
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
    super.key,
    required this.selectedCity,
    required this.selectedPostalCode,
    required this.address,
    required this.onCitySelected,
    required this.onPostalCodeSelected,
    required this.onAddressChanged,
    this.cityError,
    this.postalCodeError,
    this.addressError,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('form.step1.address_section.address_title'),
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 8),
        const SectionDivider(),
        const SizedBox(height: 16),

        // City selector
        CustomDropdown(
          svgIconPath: 'assets/icons/inputs/location.svg',
          hintText: localizations.translate('form.step1.address_section.city'),
          value: selectedCity,
          items: const [
            'Wien',
            'Achau',
            'Alland',
            'Bad Sauerbrunn',
            'Bad Vöslau',
            'Baden',
            'Berndorf',
            'Bisamberg',
            'Breitenfurt bei Wien',
            'Bruck an der Leitha',
            'Brunn am Gebirge',
            'Deutsch-Wagram',
            'Deutschkreutz',
            'Eichgraben',
            'Eisenstadt',
            'Enzesfeld',
            'Frauenkirchen',
            'Gablitz',
            'Gerasdorf bei Wien',
            'Gießhübl',
            'Gloggnitz',
            'Graz',
            'Groß-Enzersdorf',
            'Guntramsdorf',
            'Gänserndorf',
            'Hagenbrunn',
            'Hinterbrühl',
            'Hollabrunn',
            'Kaltenleutgeben',
            'Kierling',
            'Klagenfurt am Wörthersee',
            'Klosterneuburg',
            'Korneuburg',
            'Kottingbrunn',
            'Krems an der Donau',
            'Kritzendorf',
            'Langenzersdorf',
            'Laxenburg',
            'Leobendorf',
            'Leopoldsdorf bei Wien',
            'Linz',
            'Maria Enzersdorf',
            'Mattersburg',
            'Mauerbach',
            'Melk',
            'Mistelbach',
            'Mödling',
            'Münichsthal',
            'Neunkirchen',
            'Neusiedl am See',
            'Parndorf',
            'Perchtoldsdorf',
            'Pernitz',
            'Pressbaum',
            'Puchberg am Schneeberg',
            'Purkersdorf',
            'Rekawinkel',
            'Salzburg',
            'Schwechat',
            'Semmering',
            'Siegenfeld',
            'St. Pölten',
            'Steyr',
            'Stockerau',
            'Traiskirchen',
            'Tulln an der Donau',
            'Tullnerbach',
            'Villach',
            'Vösendorf',
            'Wiener Neudorf',
            'Wiener Neustadt',
            'Wolfsgraben',
            'Wolkersdorf',
            'Zwettl',
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
              hintText: localizations
                  .translate('form.step1.address_section.postal_code'),
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
          hintText:
              localizations.translate('form.step1.address_section.address'),
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
    super.key,
    required this.passengerCount,
    required this.luggageCount,
    required this.onPassengerCountChanged,
    required this.onLuggageCountChanged,
    this.passengerError,
    this.luggageError,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Row(
      children: [
        // Passenger count
        Expanded(
          child: CustomDropdown(
            svgIconPath: 'assets/icons/inputs/people.svg',
            hintText:
                localizations.translate('form.step1.address_section.person'),
            value: passengerCount > 0 ? passengerCount.toString() : '1',
            items: const ['1', '2', '3', '4', '5', '6', '7', '8'],
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
            hintText:
                localizations.translate('form.step1.address_section.luggage'),
            value: luggageCount.toString(),
            items: const ['0', '1', '2', '3', '4', '5', '6', '7', '8'],
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
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    this.nameError,
    this.emailError,
    this.phoneError,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('form.step1.contact_section.contact_title'),
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 8),
        const SectionDivider(),
        const SizedBox(height: 16),

        // Name
        InputFieldWithSvgIcon(
          svgIconPath: 'assets/icons/inputs/person.svg',
          hintText: localizations.translate('form.step1.contact_section.name'),
          value: name,
          onChanged: onNameChanged,
          errorText: nameError,
        ),

        const SizedBox(height: 12),

        // Email
        InputFieldWithSvgIcon(
          svgIconPath: 'assets/icons/inputs/email.svg',
          hintText: localizations.translate('form.step1.contact_section.email'),
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
          hintText: localizations.translate('form.step1.contact_section.phone'),
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
    super.key,
    required this.icon,
    required this.hintText,
    this.value,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
  });

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
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      // Preserve cursor position when updating text
      final int cursorPosition = _controller.selection.baseOffset;
      final String newText = widget.value ?? '';
      _controller.value = _controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
          offset: cursorPosition.clamp(0, newText.length),
        ),
      );
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
              hintStyle: const TextStyle(color: AppColors.textLight),
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

class DropdownFieldWithIcon extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final String? value;
  final List<String> items;
  final Function(String) onChanged;
  final String? errorText;

  const DropdownFieldWithIcon({
    super.key,
    required this.icon,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

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
              hintStyle: const TextStyle(color: AppColors.textLight),
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
    super.key,
    required this.svgIconPath,
    required this.hintText,
    this.value,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
  });

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
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      // Preserve cursor position when updating text
      final int cursorPosition = _controller.selection.baseOffset;
      final String newText = widget.value ?? '';
      _controller.value = _controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
          offset: cursorPosition.clamp(0, newText.length),
        ),
      );
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
              hintStyle: const TextStyle(color: AppColors.textLight),
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

class FlightInformationWidget extends StatelessWidget {
  final String? flightFrom;
  final String? flightNumber;
  final Function(String?) onFlightFromChanged;
  final Function(String?) onFlightNumberChanged;
  final String? flightFromError;
  final String? flightNumberError;

  const FlightInformationWidget({
    super.key,
    required this.flightFrom,
    required this.flightNumber,
    required this.onFlightFromChanged,
    required this.onFlightNumberChanged,
    this.flightFromError,
    this.flightNumberError,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate(
              'form.step1.flight_information_section.flight_information_title'),
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
                hintText: localizations.translate(
                    'form.step1.flight_information_section.flight_from'),
                value: flightFrom,
                onChanged: onFlightFromChanged,
                errorText: flightFromError,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InputFieldWithIcon(
                icon: Icons.flight,
                hintText: localizations.translate(
                    'form.step1.flight_information_section.flight_number'),
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
