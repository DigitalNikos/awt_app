// lib/presentation/screens/booking/from_airport/step2_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/from_airport/form_provider.dart';
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/step2_widgets.dart';

class Step2Screen extends StatelessWidget {
  const Step2Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FromAirportFormProvider>(
      builder: (context, provider, child) {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),

                  // Section title
                  Text(
                    'Optionen',
                    style: AppTextStyles.heading2,
                  ),

                  const SizedBox(height: 12),

                  // Return trip widget
                  ReturnTripWidget(
                    isReturnTripActive: provider.formData.roundTrip,
                    returnDate: provider.formData.returnDate,
                    returnTime: provider.formData.returnTime,
                    onReturnTripChanged: provider.updateRoundTrip,
                    onReturnDateChanged: provider.updateReturnDate,
                    onReturnTimeChanged: provider.updateReturnTime,
                  ),

                  const SizedBox(height: 2),

                  // Child seat widget
                  ChildSeatWidget(
                    selectedChildSeat: provider.formData.childSeat,
                    onChildSeatChanged: provider.updateChildSeat,
                  ),

                  const SizedBox(height: 2),

                  // Nameplate widget (ALWAYS visible for FROM AIRPORT)
                  NameSignWidget(
                    isReturnTripActive: true, // Always show for from_airport
                    nameplateService: provider.formData.nameplateService,
                    onNameplateServiceChanged: provider.updateNameplateService,
                  ),

                  const SizedBox(height: 2),

                  // Stopover widget (only visible for Vienna)
                  StopoverWidget(
                    isViennaSelected: provider.formData.city == 'Wien',
                    currentStopovers: provider.formData.stops,
                    onAddStopover: provider.addStopover,
                    onRemoveStopover: provider.removeStopover,
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
                            color: AppColors.accent,
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
                              // Show validation error if needed
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Bitte füllen Sie alle erforderlichen Felder aus.'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
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
                              const Icon(Icons.arrow_forward, size: 20),
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
