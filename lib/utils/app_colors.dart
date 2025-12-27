import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors (Bright & Crisp)
  static const Color primary = Color(0xFF00796B); // Teal 700
  static const Color primaryLight = Color(0xFFB2DFDB); // Teal 100
  static const Color secondary = Color(0xFFE91E63);
  static const Color background = Color(0xFFEFEEEE); // Classic Neumorphic White/Grey
  static const Color surface = Color(0xFFEFEEEE);
  static const Color cardColor = Color(0xFFEFEEEE);
  
  static const Color textDark = Color(0xFF263238);
  static const Color textLight = Color(0xFF78909C);
  
  // Dark Theme Colors (Deep Black/Grey)
  static const Color backgroundDark = Color(0xFF191919); // Very Deep Grey, almost Black
  static const Color surfaceDark = Color(0xFF191919); // Match background
  static const Color cardColorDark = Color(0xFF212121); // Slightly elevated for cards if needed, else match surface
  static const Color textWhite = Color(0xFFF5F5F5); // High Contrast White
  static const Color textGrey = Color(0xFF9E9E9E);

  // Neumorphic Shadows
  // Light Mode
  static const Color shadowLightTop = Colors.white;
  static const Color shadowLightBottom = Color(0xFFA7A9AF);
  
  // Dark Mode (Black Shadows for depth)
  static const Color shadowDarkTop = Color(0xFF2C2C2C); // Lighter highlight
  static const Color shadowDarkBottom = Color(0xFF000000); // Pure Black shadow

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF004D40), Color(0xFF009688)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
