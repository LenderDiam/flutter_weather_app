import 'package:flutter/material.dart';
import 'color_scheme.dart';

final CardTheme appCardLightTheme = CardTheme(
  color: AppColors.light.surface,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
);

final CardTheme appCardDarkTheme = CardTheme(
  color: AppColors.dark.surface,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
);
