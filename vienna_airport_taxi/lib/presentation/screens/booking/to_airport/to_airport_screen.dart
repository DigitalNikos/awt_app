import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/app_constants.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';
import 'package:vienna_airport_taxi/core/localization/language_provider.dart';
import 'package:vienna_airport_taxi/presentation/widgets/progress_bar.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/to_airport/form_provider.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/to_airport/step1_screen.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/to_airport/step2_screen.dart';
import 'package:vienna_airport_taxi/presentation/screens/booking/to_airport/step3_screen.dart';
import 'package:vienna_airport_taxi/presentation/widgets/bottom_navbar.dart';

class ToAirportScreen extends StatelessWidget {
  const ToAirportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ToAirportFormProvider(),
      child: const _ToAirportScreenContent(),
    );
  }
}

class _ToAirportScreenContent extends StatelessWidget {
  const _ToAirportScreenContent({Key? key}) : super(key: key);

  List<String> _getLocalizedSteps(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return [
      localizations.translate('form.progress_bar.step1'),
      localizations.translate('form.progress_bar.step2'),
      localizations.translate('form.progress_bar.step3'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      // Updated AppBar with white background and bottom border only
      appBar: AppBar(
        // Reduce padding around title to move it closer to the back arrow
        titleSpacing: 0,
        title: Text(
          localizations.translate('to_airport') ?? 'Zum Flughafen',
          style: AppTextStyles.heading2.copyWith(
            fontSize: 18, // Smaller font size than heading2
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow

        // Left align title
        centerTitle: false,

        // Change back arrow color to black
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary, // Black color for back arrow
        ),

        // Add bottom border to AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bottom border
              Container(
                height: 2,
                width: double.infinity,
                color: AppColors.textPrimary,
              ),

              // SVG Icon in separate container above the label
              Positioned(
                bottom: 15, // Position it above where the label will be
                right: 30,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: SvgPicture.asset(
                    'assets/images/hero_section/to-airport.svg',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),

              // Floating label (Wien-Schwechat) repositioned above the border
              Positioned(
                bottom: -11,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    'Wien-Schwechat',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<ToAirportFormProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              const SizedBox(height: 16),
              // Progress Bar
              ProgressBar(
                currentStep: provider.currentStep + 1,
                steps: _getLocalizedSteps(context),
              ),

              // Form Content
              Expanded(
                child: IndexedStack(
                  index: provider.currentStep,
                  children: const [
                    Step1Screen(),
                    Step2Screen(),
                    Step3Screen(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      // Add the custom bottom navigation bar
      bottomNavigationBar: CustomBottomNavBar(
        // Pass the language provider so we can handle language changes from the bottom bar
        languageProvider: languageProvider,
      ),
    );
  }
}
