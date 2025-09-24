// lib/presentation/screens/home/hero_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/to_airport/to_airport_screen.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/from_airport/from_airport_screen.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 20),
      // color: AppColors.background,
      child: Column(
        children: [
          // Small tagline
          Text(
            t.translate('hero_small_title') ?? 'Willkommen bei',
            style: AppTextStyles.heading3.copyWith(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          // Main title
          Text(
            t.translate('app_name') ?? 'Airport Wien Taxi',
            style: AppTextStyles.heading1.copyWith(
              fontSize: 32,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),
          // Subtitle
          Text(
            t.translate('hero_subtitle') ?? 'Buchen Sie online...',
            style: AppTextStyles.bodyLarge.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),
          // CTA Buttons with SVG icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeroButton(
                svgAsset: 'assets/images/hero_section/to-airport.svg',
                label: t.translate('to_airport'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ToAirportScreen()),
                  );
                },
              ),
              const SizedBox(width: 16),
              _HeroButton(
                svgAsset: 'assets/images/hero_section/from-airport.svg',
                label: t.translate('from_airport'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const FromAirportScreen()),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          // Description
          Text(
            t.translate('hero_description') ??
                'Airport Wien Taxi bietet Ihnen einen komfortablen und pünktlichen 24/7 Transfer zum Fixpreis. Buchen Sie jetzt online und genießen Sie eine stressfreie Fahrt.',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// A button that displays an SVG icon above a text label.
class _HeroButton extends StatelessWidget {
  final String svgAsset;
  final String label;
  final VoidCallback onPressed;

  const _HeroButton({
    required this.svgAsset,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    print('Loading SVG asset: $svgAsset');
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        minimumSize: const Size(140, 140),
        maximumSize: const Size(140, 140),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SVG icon
          SvgPicture.asset(
            svgAsset,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.buttonText.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
