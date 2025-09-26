// lib/presentation/screens/booking/to_airport/step3_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/to_airport/form_provider.dart';
import 'package:vienna_airport_taxi/data/models/booking_form_data.dart'; // Add this import
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/step2_widgets.dart'; // For SectionDivider

class Step3Screen extends StatelessWidget {
  const Step3Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Consumer<ToAirportFormProvider>(
      builder: (context, provider, child) {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),

                  // Section title
                  Text(
                    'Überblick',
                    style: AppTextStyles.heading2,
                  ),

                  const SizedBox(height: 8),
                  const SectionDivider(),
                  const SizedBox(height: 16),

                  // Overview container (border removed)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        // Yellow top border (30% width)
                        // Positioned(
                        //   top: 0,
                        //   left: 0,
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width * 0.25,
                        //     height: 3,
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //         colors: [AppColors.accent, Colors.transparent],
                        //         begin: Alignment.centerLeft,
                        //         end: Alignment.centerRight,
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fahrtdetails section
                              _buildSection(
                                'Fahrtdetails',
                                {
                                  'Datum': provider.formData.pickupDate != null
                                      ? '${provider.formData.pickupDate!.day.toString().padLeft(2, '0')}.${provider.formData.pickupDate!.month.toString().padLeft(2, '0')}.${provider.formData.pickupDate!.year}'
                                      : '-',
                                  'Uhrzeit':
                                      provider.formData.pickupTime ?? '-',
                                  'Ort': provider.formData.city ?? '-',
                                  'PLZ': provider.formData.city == 'Wien'
                                      ? provider.formData.postalCode ?? '-'
                                      : null,
                                  'Adresse': provider.formData.address ?? '-',
                                  'Personen':
                                      '${provider.formData.passengerCount}',
                                  'Gepäck': '${provider.formData.luggageCount}',
                                },
                              ),

                              // Optionen section
                              _buildSection(
                                'Optionen',
                                {
                                  'Kindersitz': _getChildSeatText(
                                      provider.formData.childSeat),
                                  'Namenschild':
                                      provider.formData.nameplateService
                                          ? 'Ja'
                                          : 'Nein',
                                  'Zahlungsart':
                                      provider.formData.paymentMethod == 'cash'
                                          ? 'Bar'
                                          : 'Karte',
                                  'Anmerkungen':
                                      provider.formData.comment?.isEmpty ?? true
                                          ? '-'
                                          : provider.formData.comment!,
                                },
                              ),

                              // Zwischenstopps section (if any)
                              if (provider.formData.stops.isNotEmpty)
                                _buildStopoverSection(
                                    'Zwischenstopps', provider.formData.stops),

                              // Rückfahrt section (if return trip is active)
                              if (provider.formData.roundTrip)
                                _buildSection(
                                  'Rückfahrt',
                                  {
                                    'Datum': provider.formData.returnDate !=
                                            null
                                        ? '${provider.formData.returnDate!.day.toString().padLeft(2, '0')}.${provider.formData.returnDate!.month.toString().padLeft(2, '0')}.${provider.formData.returnDate!.year}'
                                        : '-',
                                    'Uhrzeit':
                                        provider.formData.returnTime ?? '-',
                                    'Abflugort':
                                        provider.formData.flightFrom ?? '-',
                                    'Flugnummer':
                                        provider.formData.flightNumber ?? '-',
                                  },
                                ),

                              // Kontakt section
                              _buildSection(
                                'Kontakt',
                                {
                                  'Name': provider.formData.customerName ?? '-',
                                  'E-Mail':
                                      provider.formData.customerEmail ?? '-',
                                  'Telefon':
                                      provider.formData.customerPhone ?? '-',
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Terms and Privacy checkbox
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: provider.termsAccepted
                            ? AppColors.success
                            : AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        provider.toggleTermsAccepted();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: provider.termsAccepted
                                      ? AppColors.success
                                      : AppColors.border,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                color: provider.termsAccepted
                                    ? AppColors.success
                                    : Colors.white,
                              ),
                              child: provider.termsAccepted
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Ich akzeptiere die ',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'AGB',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(text: ' und die '),
                                    TextSpan(
                                      text: 'Datenschutzerklärung',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Price and buttons
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
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          provider.formData.price != null
                              ? '${provider.formData.price!.toStringAsFixed(2)} €'
                              : '0,00 €',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

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

                      // Submit button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (provider.termsAccepted) {
                              // Submit the form
                              await provider.submitForm(context);

                              // Navigate to success screen or handle result
                              if (provider.errorMessage == null) {
                                // Success - navigate to success screen
                                // Navigator.pushReplacement(context, MaterialPageRoute(
                                //   builder: (context) => const SuccessScreen(),
                                // ));
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(provider.errorMessage!),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Bitte akzeptieren Sie die AGB und Datenschutzerklärung.'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: provider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Jetzt buchen',
                                  style: AppTextStyles.buttonText.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSection(String title, Map<String, String?> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17.6, // 1.1rem equivalent
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: fields.entries
                .where((entry) => entry.value != null)
                .map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 130,
                            child: Text(
                              '${entry.key}:',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              entry.value!,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStopoverSection(String title, List<StopoverLocation> stopovers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17.6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: stopovers
                .map((stopover) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6, right: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${stopover.address} - ${stopover.postalCode}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  String _getChildSeatText(String childSeat) {
    switch (childSeat) {
      case 'booster_seat':
        return 'Kindersitzerhöhung';
      case 'child_seat':
        return 'Kindersitz';
      case 'baby_carrier':
        return 'Babyschale';
      default:
        return 'Ohne';
    }
  }
}
