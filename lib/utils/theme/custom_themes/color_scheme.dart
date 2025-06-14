import 'package:flutter/material.dart';

class AppColors {
  static const Color bondiBlue = Color(0xFF008AB8);
  static const Color robinEggBlue = Color(0xFF00BDD6);
  static const Color pictonBlue = Color(0xFF4CCFE1);
  static const Color spray = Color(0xFF80DEEA);
  static const Color blizzardBlue = Color(0xFFB1EAF2);

  static const Color error = Color(0xFFB00020);

  static const Color backgroundLight = Color(0xFFF6F8FA);
  static const Color backgroundDark = Color(0xFF121212);

  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: bondiBlue,
    secondary: pictonBlue,
    surface: blizzardBlue,
    error: error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
    onError: Colors.white,
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: robinEggBlue,
    secondary: spray,
    surface: pictonBlue,
    error: error,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white70,
    onError: Colors.black,
  );
}
