import 'package:flutter/material.dart';
import 'color_scheme.dart';

final CardTheme appCardLightTheme = CardTheme(
  color: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
);

final CardTheme appCardDarkTheme = CardTheme(
  color: AppColors.pictonBlue.withOpacity(0.1),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
);
