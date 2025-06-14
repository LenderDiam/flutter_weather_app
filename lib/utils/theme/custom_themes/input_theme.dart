import 'package:flutter/material.dart';
import 'color_scheme.dart';

final OutlineInputBorder _borderLight = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide(color: AppColors.light.primary, width: 4),
);

final OutlineInputBorder _borderDark = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide(color: AppColors.dark.primary, width: 4),
);

final InputDecorationTheme inputLightTheme = InputDecorationTheme(
  border: _borderLight,
  enabledBorder: _borderLight,
  focusedBorder: _borderLight,
  suffixIconColor: AppColors.light.secondary,
  labelStyle: TextStyle(color: AppColors.light.onSurface),
  hintStyle: TextStyle(color: AppColors.light.onSurface.withOpacity(0.6)),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
);

final InputDecorationTheme inputDarkTheme = InputDecorationTheme(
  border: _borderDark,
  enabledBorder: _borderDark,
  focusedBorder: _borderDark,
  suffixIconColor: AppColors.dark.secondary,
  labelStyle: TextStyle(color: AppColors.dark.onSurface),
  hintStyle: TextStyle(color: AppColors.dark.onSurface.withOpacity(0.6)),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
);
