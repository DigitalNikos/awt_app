import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';

class ProgressBar extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const ProgressBar({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          Stack(
            children: [
              // Base container - white background
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),

              // Yellow progress indicator
              LayoutBuilder(
                builder: (context, constraints) {
                  // For step 1 out of 3, width should be 1/3 of the total width
                  final double stepWidth = constraints.maxWidth / steps.length;

                  // Width calculation based on current step (not a percentage)
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 30,
                      width: stepWidth * currentStep,
                      decoration: BoxDecoration(
                        color: AppColors.primary, // Yellow background
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),

              // Steps text on top
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(steps.length, (index) {
                    // Step is active if index+1 is less than or equal to currentStep
                    final bool isActive = index < currentStep;
                    return Expanded(
                      child: Center(
                        child: Text(
                          steps[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w500,
                            color: isActive
                                ? AppColors
                                    .textPrimary // Black text for active steps
                                : AppColors
                                    .textSecondary, // Gray text for inactive steps
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Thin border
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
