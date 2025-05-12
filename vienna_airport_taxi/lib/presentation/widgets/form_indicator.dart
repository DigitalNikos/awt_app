import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';

class FormIndicator extends StatelessWidget {
  final String title;
  final String destination;
  final String iconAsset;

  const FormIndicator({
    Key? key,
    required this.title,
    required this.destination,
    required this.iconAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          // Main container
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                // Title
                Text(
                  title,
                  style: AppTextStyles.heading2,
                ),

                // Icon container
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.flight_takeoff,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Floating label
          Positioned(
            bottom: -12,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.secondary,
                    Color(0xFFFEC94D),
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
                destination,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          // Bottom border
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
