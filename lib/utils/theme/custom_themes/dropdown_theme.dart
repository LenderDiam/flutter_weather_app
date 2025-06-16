import 'package:flutter/material.dart';
import 'color_scheme.dart';
import 'input_theme.dart';
import 'text_theme.dart';

final DropdownMenuThemeData dropdownMenuLightTheme = DropdownMenuThemeData(
  textStyle: AppTextTheme.light.bodyMedium,
  inputDecorationTheme: inputLightTheme,
  menuStyle: MenuStyle(
    backgroundColor: const WidgetStatePropertyAll(AppColors.backgroundLight),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);

final DropdownMenuThemeData dropdownMenuDarkTheme = DropdownMenuThemeData(
  textStyle: AppTextTheme.dark.bodyMedium,
  inputDecorationTheme: inputDarkTheme,
  menuStyle: MenuStyle(
    backgroundColor: const WidgetStatePropertyAll(AppColors.backgroundDark),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);

