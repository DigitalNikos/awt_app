import 'package:flutter/material.dart';

class AppColors {
  // Primary colors from variables.css
  static const Color primary = Color(0xFFFEB816); // --color-yellow: #feb816
  static const Color primaryLight =
      Color(0xFFFEC94D); // --color-yellow-light: #fec94d
  static const Color primaryDark =
      Color(0xFFE19800); // --color-yellow-dark: #e19800
  static const Color primaryHover =
      Color(0xFFFFCA4D); // --color-yellow-hover: #ffca4d

  // Secondary and accent colors
  static const Color secondary = Color(0xFF76522E); // --secondary: #76522e
  // static const Color accent = Color(0xFF4D1F00); // --accent: #4d1f00
  static const Color accent = Color(0xFFCCCCCC); // --accent: #4d1f00

  // Text and background colors
  static const Color textPrimary = Color(0xFF050316); // --text: #050316
  static const Color textSecondary = Color(0xFF666666); // --color-text: #666666
  static const Color textLight =
      Color(0xFF76522E); // --color-text-light: #76522e

  // Background colors
  static const Color background =
      Color(0xFFFFFFFF); // --color-background: #ffffff
  static const Color backgroundLight =
      Color(0xFFF8F8F8); // --color-background-light: #f8f8f8

  // Utility colors
  static const Color border =
      Color.fromARGB(255, 53, 203, 23); // --color-border: #ccc
  static const Color success = Color(0xFF4CAF50); // --color-green: #4caf50
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFAB00);
  static const Color info = Color(0xFF2196F3);

  // Shadow colors
  static const Color shadow = Color(0x1A000000); // rgba(0, 0, 0, 0.1)
}
