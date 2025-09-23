import 'package:flutter/material.dart';

/// Custom Class for Light & Dark Color Themes
class ColorConstant {
  ColorConstant._(); // To avoid creating instances

  // -- App Colors
  static const Color primary = Color(0xFF4B68FF);
  static const Color secondary = Color(0xFF687EFF);
  static const Color accent = Color(0xFFB0C7FF);

  // -- Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // -- Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F4F6);

  // -- Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = ColorConstant.white.withOpacity(0.1);

  // -- Button Colors
  static const Color buttonPrimary = Color(0xFF4B68FF);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // -- Border Colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // -- Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // -- Neutral Colors
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color lightGrey = Color(0xFFF4F4F4);
  static const Color white = Color(0xFFFFFFFF);

  // -- Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient secondaryGradient = LinearGradient(
    colors: [accent, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // -- Shadow Colors
  static const Color shadowColor = Color(0xFF000000);
  static const Color lightShadowColor = Color(0xFF000000);

  // -- Social Media Colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFF4285F4);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color instagram = Color(0xFFE4405F);

  // -- Status Colors
  static const Color online = Color(0xFF4CAF50);
  static const Color offline = Color(0xFF9E9E9E);
  static const Color busy = Color(0xFFFF9800);
  static const Color away = Color(0xFFFFC107);
}
