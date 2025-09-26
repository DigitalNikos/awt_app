// lib/presentation/screens/booking/to_airport/step2_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/to_airport/form_provider.dart';
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/step2_widgets.dart';
// import 'package:vienna_airport_taxi/presentation/widgets/form_steps/step1_widgets.dart';

class Step2Screen extends StatefulWidget {
  const Step2Screen({Key? key}) : super(key: key);

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  final ScrollController _scrollController = ScrollController();

  // GlobalKeys for each section to enable scrolling
  final GlobalKey _returnTripKey = GlobalKey();
  final GlobalKey _stopoverKey = GlobalKey();
  final GlobalKey _childSeatKey = GlobalKey();
  final GlobalKey _paymentKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Method to scroll to the first error field
  void _scrollToFirstError(Map<String, String?> errors) {
    // Define the order of fields and their corresponding keys
    final Map<String, GlobalKey> fieldKeys = {
      'returnDate': _returnTripKey,
      'returnTime': _returnTripKey,
      'flightFrom': _returnTripKey,
      'flightNumber': _returnTripKey,
      'returnDateTime': _returnTripKey,
      'returnReservationTime': _returnTripKey,
      'stopover': _stopoverKey,
      'stopoverAddress': _stopoverKey,
      'stopoverPostalCode': _stopoverKey,
    };

    // Find the first error in the defined order
    for (String fieldName in fieldKeys.keys) {
      if (errors.containsKey(fieldName) && errors[fieldName] != null) {
        final targetKey = fieldKeys[fieldName]!;

        // Scroll to the section containing the error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (targetKey.currentContext != null) {
            Scrollable.ensureVisible(
              targetKey.currentContext!,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              alignment: 0.1, // Show the field near the top of the screen
            );
          }
        });
        break; // Only scroll to the first error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ToAirportFormProvider>(
      builder: (context, provider, child) {
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),

                  // Section title
                  Text(
                    'Optionen',
                    style: AppTextStyles.heading2,
                  ),

                  const SizedBox(height: 8),
                  const SectionDivider(),
                  const SizedBox(height: 16),

                  // Return trip widget
                  Container(
                    key: _returnTripKey,
                    child: ReturnTripWidget(
                      isReturnTripActive: provider.formData.roundTrip,
                      returnDate: provider.formData.returnDate,
                      returnTime: provider.formData.returnTime,
                      flightFrom: provider.formData.flightFrom,
                      flightNumber: provider.formData.flightNumber,
                      onReturnTripChanged: provider.updateRoundTrip,
                      onReturnDateChanged: provider.updateReturnDate,
                      onReturnTimeChanged: provider.updateReturnTime,
                      onFlightFromChanged: provider.updateFlightFrom,
                      onFlightNumberChanged: provider.updateFlightNumber,
                      // Pass validation errors
                      returnDateError: provider.validationErrors['returnDate'],
                      returnTimeError: provider.validationErrors['returnTime'],
                      flightFromError: provider.validationErrors['flightFrom'],
                      flightNumberError:
                          provider.validationErrors['flightNumber'],
                      returnDateTimeError:
                          provider.validationErrors['returnDateTime'],
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Child seat widget
                  ChildSeatWidget(
                    selectedChildSeat: provider.formData.childSeat,
                    onChildSeatChanged: provider.updateChildSeat,
                  ),

                  const SizedBox(height: 2),

                  // Nameplate widget (only visible when return trip is active)
                  NameSignWidget(
                    isReturnTripActive: provider.formData.roundTrip,
                    nameplateService: provider.formData.nameplateService,
                    onNameplateServiceChanged: provider.updateNameplateService,
                  ),

                  const SizedBox(height: 2),

                  // Stopover widget (only visible for Vienna)
                  Container(
                    key: _stopoverKey,
                    child: StopoverWidget(
                      isViennaSelected: provider.formData.city == 'Wien',
                      currentStopovers: provider.formData.stops,
                      onAddStopover: provider.addStopover,
                      onRemoveStopover: provider.removeStopover,
                      stopoverError: provider.validationErrors['stopover'],
                      onPanelStateChanged: provider.setStopoverPanelOpen,
                      onValidatePanelData: provider.validateStopoverPanel,
                      onValidateFields: provider.validateStopoverFields,
                      addressError:
                          provider.validationErrors['stopoverAddress'],
                      postalCodeError:
                          provider.validationErrors['stopoverPostalCode'],
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Payment method widget
                  PaymentMethodWidget(
                    paymentMethod: provider.formData.paymentMethod,
                    onPaymentMethodChanged: provider.updatePaymentMethod,
                  ),

                  const SizedBox(height: 2),

                  // Comment widget
                  CommentWidget(
                    comment: provider.formData.comment,
                    onCommentChanged: provider.updateComment,
                  ),

                  const SizedBox(height: 24),

                  // Price Display (above the buttons)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(
                          color: AppColors.primary,
                          width: 4,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Preis:',
                          style: TextStyle(
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

                  const SizedBox(height: 16), // Space between price and buttons

                  // Navigation buttons
                  Row(
                    children: [
                      // Back button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: provider.previousStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.backgroundLight,
                            foregroundColor: AppColors.textSecondary,
                            side: BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 1,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Zurück',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Next button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            if (provider.validateStep(1)) {
                              provider.nextStep();
                            } else {
                              // Scroll to first error when validation fails
                              _scrollToFirstError(provider.validationErrors);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Weiter',
                                style: AppTextStyles.buttonText.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Bottom padding to ensure content is not cut off
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
