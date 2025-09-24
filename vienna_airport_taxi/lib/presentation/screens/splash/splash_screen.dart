// lib/presentation/screens/splash/splash_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/core/constants/app_constants.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/presentation/screens/home/home_screen.dart';
import 'package:vienna_airport_taxi/presentation/widgets/animations/animated_taxi.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showAnimation = true;

  @override
  void initState() {
    super.initState();
    _handleSplashFlow();
  }

  void _handleSplashFlow() async {
    // Wait for SVGator animation to complete (adjust timing as needed)
    await Future.delayed(
        const Duration(seconds: 4)); // Adjust based on your animation length

    if (mounted) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: AppConstants.pageDuration,
      ),
    );
  }

  // Handle animation events from SVGator
  void _onAnimationMessage(String message) {
    try {
      final data = json.decode(message);
      final event = data['event'];

      if (event == 'end' || event == 'stop') {
        // Animation completed - navigate immediately
        if (mounted) {
          _navigateToHome();
        }
      }
    } catch (e) {
      // Handle any parsing errors
      print('Animation message parsing error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
              AppColors.primaryHover,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SVGator Animation
              if (_showAnimation)
                SizedBox(
                  width: 300,
                  height: 200,
                  child: _buildAnimationWidget(),
                ),

              const SizedBox(height: 40),

              // App name - always visible from the start
              Text(
                AppConstants.appName,
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtitle - always visible from the start
              Text(
                'Your reliable airport transfer',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color.fromARGB(255, 90, 90, 90),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationWidget() {
    return Toairport(
      width: 300,
      height: 200,
      onMessage: _onAnimationMessage,
    );
  }
}
