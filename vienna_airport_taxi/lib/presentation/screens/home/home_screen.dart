import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/core/constants/app_constants.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: const Center(
        child: Text(
          'Home Screen Placeholder',
          style: AppTextStyles.heading2,
        ),
      ),
    );
  }
}
