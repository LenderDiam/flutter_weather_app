import 'package:flutter/material.dart';
import 'package:flutter_weather_app/utils/theme/custom_themes/dropdown_theme.dart';
import 'custom_themes/color_scheme.dart';
import 'custom_themes/text_theme.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/card_theme.dart';
import 'custom_themes/button_theme.dart';
import 'custom_themes/input_theme.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.light,
    textTheme: AppTextTheme.light,
    appBarTheme: appBarLightTheme,
    cardTheme: appCardLightTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyleLight),
    inputDecorationTheme: inputLightTheme,
    dropdownMenuTheme: dropdownMenuLightTheme,
    scaffoldBackgroundColor: AppColors.backgroundLight,
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.dark,
    textTheme: AppTextTheme.dark,
    appBarTheme: appBarDarkTheme,
    cardTheme: appCardDarkTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyleDark),
    inputDecorationTheme: inputDarkTheme,
    dropdownMenuTheme: dropdownMenuDarkTheme,
    scaffoldBackgroundColor: AppColors.backgroundDark,
  );
}
