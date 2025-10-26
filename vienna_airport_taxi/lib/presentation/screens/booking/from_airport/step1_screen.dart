import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/from_airport/form_provider.dart';
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/step1_widgets.dart';
import 'package:vienna_airport_taxi/presentation/widgets/dropdown_field_with_svg_icon.dart';
import 'package:vienna_airport_taxi/presentation/providers/auth_provider.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({super.key});

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  final ScrollController _scrollController = ScrollController();

  // GlobalKeys for each section to enable scrolling
  final GlobalKey _dateTimeKey = GlobalKey();
  final GlobalKey _addressKey = GlobalKey();
  final GlobalKey _passengersKey = GlobalKey();
  final GlobalKey _flightKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Method to scroll to the first error field
  void _scrollToFirstError(Map<String, String?> errors) {
    // Define the order of fields and their corresponding keys
    final Map<String, GlobalKey> fieldKeys = {
      'date': _dateTimeKey,
      'time': _dateTimeKey,
      'reservationTime': _dateTimeKey,
      'city': _addressKey,
      'postalCode': _addressKey,
      'address': _addressKey,
      'passengers': _passengersKey,
      'luggage': _passengersKey,
      'flightFrom': _flightKey,
      'flightNumber': _flightKey,
      'name': _contactKey,
      'email': _contactKey,
      'phone': _contactKey,
    };

    // Find the first error in the defined order
    for (String fieldName in fieldKeys.keys) {
      if (errors.containsKey(fieldName) && errors[fieldName] != null) {
        final targetKey = fieldKeys[fieldName]!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (targetKey.currentContext != null) {
            Scrollable.ensureVisible(
              targetKey.currentContext!,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              alignment: 0.1,
            );
          }
        });
        break; // Stop after finding the first error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAuthenticated = authProvider.isAuthenticated;
    final localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Consumer<FromAirportFormProvider>(
        builder: (context, provider, child) {
          // Pre-fill contact information if user is authenticated
          if (isAuthenticated && authProvider.currentUser != null) {
            final user = authProvider.currentUser!;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.updateCustomerName(user.name);
              provider.updateCustomerEmail(user.email);
              provider.updateCustomerPhone(user.phone);
            });
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and Time Selection
              Container(
                key: _dateTimeKey,
                child: DateTimeSelectionWidget(
                  selectedDate: provider.formData.pickupDate,
                  selectedTime: provider.formData.pickupTime,
                  onDateSelected: provider.updatePickupDate,
                  onTimeSelected: provider.updatePickupTime,
                  dateError: provider.validationErrors['date'],
                  timeError: provider.validationErrors['time'],
                ),
              ),

              const SizedBox(height: 32),

              // Address Selection
              Container(
                key: _addressKey,
                child: AddressSelectionWidget(
                  selectedCity: provider.formData.city,
                  selectedPostalCode: provider.formData.postalCode,
                  address: provider.formData.address,
                  onCitySelected: provider.updateCity,
                  onPostalCodeSelected: provider.updatePostalCode,
                  onAddressChanged: provider.updateAddress,
                  cityError: provider.validationErrors['city'],
                  postalCodeError: provider.validationErrors['postalCode'],
                  addressError: provider.validationErrors['address'],
                ),
              ),

              const SizedBox(height: 12), // REDUCED from 32px to 12px

              // MOVED UP: Passenger and Luggage Selection (now after Address)
              Container(
                key: _passengersKey,
                child: Row(
                  children: [
                    // Passenger count
                    Expanded(
                      child: DropdownFieldWithSvgIcon(
                        svgIconPath: 'assets/icons/inputs/people.svg',
                        hintText: localizations
                            .translate('form.step1.address_section.person'),
                        value: provider.formData.passengerCount > 0
                            ? provider.formData.passengerCount.toString()
                            : null, // Show placeholder when 0
                        errorText: provider.validationErrors['passengers'],
                        items:
                            List.generate(8, (index) => (index + 1).toString()),
                        onChanged: (value) =>
                            provider.updatePassengerCount(int.parse(value)),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Luggage count
                    Expanded(
                      child: DropdownFieldWithSvgIcon(
                        svgIconPath: 'assets/icons/inputs/luggage.svg',
                        hintText: localizations
                            .translate('form.step1.address_section.luggage'),
                        value: provider.formData.luggageCount >= 0 &&
                                provider.hasSelectedLuggage
                            ? provider.formData.luggageCount.toString()
                            : null, // Show placeholder when not selected
                        errorText: provider.validationErrors['luggage'],
                        items: List.generate(9, (index) => index.toString()),
                        onChanged: (value) =>
                            provider.updateLuggageCount(int.parse(value)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Flight Information (FROM AIRPORT SPECIFIC)
              Container(
                key: _flightKey,
                child: FlightInformationWidget(
                  flightFrom: provider.formData.flightFrom,
                  flightNumber: provider.formData.flightNumber,
                  onFlightFromChanged: provider.updateFlightFrom,
                  onFlightNumberChanged: provider.updateFlightNumber,
                  flightFromError: provider.validationErrors['flightFrom'],
                  flightNumberError: provider.validationErrors['flightNumber'],
                ),
              ),

              const SizedBox(height: 32),

              // Contact Information (moved down)
              if (!isAuthenticated)
                Container(
                  key: _contactKey,
                  child: ContactInformationWidget(
                    name: provider.formData.customerName,
                    email: provider.formData.customerEmail,
                    phone: provider.formData.customerPhone,
                    onNameChanged: provider.updateCustomerName,
                    onEmailChanged: provider.updateCustomerEmail,
                    onPhoneChanged: provider.updateCustomerPhone,
                    nameError: provider.validationErrors['name'],
                    emailError: provider.validationErrors['email'],
                    phoneError: provider.validationErrors['phone'],
                  ),
                ),

              if (!isAuthenticated) const SizedBox(height: 32),

              // Price Display and Navigation Buttons
              Column(
                children: [
                  // Price Display Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(
                        left: BorderSide(
                          color: AppColors.primary,
                          width: 4,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.translate('form.price_section.price'),
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            if (provider.isCalculatingPrice)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(AppColors.primary),
                                ),
                              ),
                            if (!provider.isCalculatingPrice)
                              Text(
                                provider.formData.price != null
                                    ? '${provider.formData.price!.toStringAsFixed(2)} €'
                                    : '0 €',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Price Error Message
                  if (provider.priceErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        provider.priceErrorMessage!,
                        style: const TextStyle(
                          color: AppColors.warning,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (provider.validateStep(0, context)) {
                          provider.nextStep();
                        } else {
                          _scrollToFirstError(provider.validationErrors);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localizations.translate('form.button.next'),
                            style:
                                AppTextStyles.buttonText.copyWith(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
