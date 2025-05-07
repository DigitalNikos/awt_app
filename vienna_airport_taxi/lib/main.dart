import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/core/constants/app_constants.dart';
import 'package:vienna_airport_taxi/core/theme/app_theme.dart';
import 'package:vienna_airport_taxi/presentation/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
