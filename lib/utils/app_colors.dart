import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00796B); // Teal 700
  static const Color primaryLight = Color(0xFFB2DFDB); // Teal 100
  static const Color secondary = Color(0xFFE91E63); // Pink
  static const Color background = Color(0xFFF5F7FA); // Light Grey
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF263238);
  static const Color textLight = Color(0xFF78909C);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF004D40), Color(0xFF009688)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
