import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/to_airport/form_provider.dart';
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/step1_widgets.dart';
import 'package:vienna_airport_taxi/presentation/providers/auth_provider.dart';

class Step1Screen extends StatelessWidget {
  const Step1Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAuthenticated = authProvider.isAuthenticated;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Consumer<ToAirportFormProvider>(
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
              DateTimeSelectionWidget(
                selectedDate: provider.formData.pickupDate,
                selectedTime: provider.formData.pickupTime,
                onDateSelected: provider.updatePickupDate,
                onTimeSelected: provider.updatePickupTime,
                dateError: provider.validationErrors['date'],
                timeError: provider.validationErrors['time'],
              ),

              const SizedBox(height: 32),

              // Address Selection
              AddressSelectionWidget(
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

              const SizedBox(height: 32),

              // Passenger and Luggage Selection
              PassengerAndLuggageWidget(
                passengerCount: provider.formData.passengerCount,
                luggageCount: provider.formData.luggageCount,
                onPassengerCountChanged: provider.updatePassengerCount,
                onLuggageCountChanged: provider.updateLuggageCount,
                passengerError: provider.validationErrors['passengers'],
                luggageError: provider.validationErrors['luggage'],
              ),

              const SizedBox(height: 32),

              // Contact Information
              if (!isAuthenticated)
                ContactInformationWidget(
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

              if (!isAuthenticated) const SizedBox(height: 32),

              // Price Display and Navigation Buttons
              Column(
                children: [
                  // Price Display Container
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.primary,
                        width: 4,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Preis:',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
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
                        style: TextStyle(
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
                        if (provider.validateStep(0)) {
                          provider.nextStep();
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
                            'Weiter',
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
