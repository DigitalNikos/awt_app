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

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // Get the screen height to calculate proper centering
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Using a Stack to position the decorative circle
      body: Stack(
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
          LayoutBuilder(builder: (context, constraints) {
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
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
