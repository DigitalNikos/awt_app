// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hero_section.dart';
import 'package:vienna_airport_taxi/presentation/providers/auth_provider.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';
import 'package:vienna_airport_taxi/presentation/screens/auth/login_screen.dart';
import 'package:vienna_airport_taxi/presentation/widgets/bottom_navbar.dart';
import 'package:vienna_airport_taxi/core/localization/language_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      // Set background color to ensure consistency
      backgroundColor: Colors.white,

      // Remove default bottom padding since our navbar handles it
      bottomNavigationBar: const SizedBox.shrink(),

      // Using a Stack to position all elements
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Yellow circle background element
          Positioned(
            top: -125,
            left: -95,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 50,
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints
                        .maxHeight, // Make content fill available height
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // This centers children vertically
                      children: const [
                        HeroSection(),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          // Floating bottom navbar positioned at the bottom of the screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              languageProvider: languageProvider,
            ),
          ),
        ],
      ),
    );
  }
}
