// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hero_section.dart';
import 'booking_steps_section.dart';
import 'important_info_section.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/presentation/widgets/bottom_navbar.dart';
import 'package:vienna_airport_taxi/core/localization/language_provider.dart';
import 'package:vienna_airport_taxi/presentation/widgets/floating_action_buttons.dart';
import 'package:vienna_airport_taxi/presentation/widgets/footer/app_footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButtons = false;

  // Approximate height where hero section ends (adjust based on your hero section height)
  static const double _heroSectionHeight = 400.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool shouldShowButtons =
        _scrollController.offset > _heroSectionHeight;
    if (shouldShowButtons != _showFloatingButtons) {
      setState(() {
        _showFloatingButtons = shouldShowButtons;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const SizedBox.shrink(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Yellow circle background element (positioned relative to hero section)
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

          // Main content - scrollable with proper layout
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Hero Section (this will be positioned behind the yellow circle)
                  const HeroSection(),

                  // Booking Steps Section
                  const BookingStepsSection(),

                  // Important Info Section
                  const ImportantInfoSection(),

                  // Footer
                  const AppFooter(),

                  // Add bottom padding to account for floating navbar
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Floating Action Buttons
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButtons(
              isVisible: _showFloatingButtons,
            ),
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
