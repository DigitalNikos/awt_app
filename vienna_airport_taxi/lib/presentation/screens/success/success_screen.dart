import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';
import 'package:vienna_airport_taxi/presentation/screens/home/home_screen.dart';

class SuccessScreen extends StatelessWidget {
  final String bookingId;
  final String? userEmail;

  const SuccessScreen({
    Key? key,
    required this.bookingId,
    this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(localizations.translate('app_name')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 60,
                color: AppColors.success,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              'Vielen Dank für Ihre Buchung!',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.textPrimary,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Success Message
            Text(
              'Wir haben Ihre Anfrage erhalten und werden uns in Kürze bei Ihnen melden.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Booking Details Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Email confirmation message
                  if (userEmail != null) ...[
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Eine Bestätigungsemail wurde an ',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: userEmail!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const TextSpan(text: ' gesendet.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Booking ID
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Ihre Buchungsnummer: ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: bookingId,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Back to Home Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to home and remove all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundLight,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.border),
                  ),
                  elevation: 1,
                ),
                child: Text(
                  'Zur Startseite',
                  style: AppTextStyles.buttonText.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
